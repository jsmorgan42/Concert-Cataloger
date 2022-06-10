//
//  DiskBacked.swift
//  Concert Cataloger
//
//  Created by Jesse Morgan on 6/1/22.
//

import Disk
import Foundation

private extension Disk.Directory {
    static let appGroup = Disk.Directory.sharedContainer(appGroupName: "jsm.Concert-Cataloger")
}

private final class Box<Value> {
    var value: Value
    init(_ value: Value) {
        self.value = value
    }
}

/// A thread-safe wrapper for accessing a value saved on disk.
///
/// This property wrapper keeps an in-memory copy of the value,
/// which is used for all reads. To force a read from disk, you
/// can access the projected value with the `$` prefix.
@propertyWrapper
public struct DiskBacked<Value: Codable> {
    private let filename: String
    private let queue: DispatchQueue

    private let box: Box<Value>

    public var wrappedValue: Value {
        get {
            queue.sync { box.value }
        }
        nonmutating set {
            queue.async(flags: .barrier) {
                box.value = newValue
                save(newValue)
            }
        }
    }

    /// Accessing the projected value will force a read from disk.
    /// This can be useful if you have reason to suspect the value
    /// in memory is outdated, for example when crossing the process
    /// barrier.
    ///
    /// If the disk read fails for any reason, the value in memory will
    /// be returned.
    public var projectedValue: Value {
        queue.sync {
            do {
                box.value = try load()
            } catch {
                print("[DiskBacked] Error: \(error)")
            }

            return box.value
        }
    }

    public init(wrappedValue: Value, filename: String) {
        self.box = Box(wrappedValue)
        self.filename = filename
        self.queue = DispatchQueue(label: "com.foxweather.disk-io.\(filename)", qos: .userInitiated)

        self.performInitialLoad()
    }

    private func performInitialLoad() {
        queue.async(flags: .barrier) {
            if let savedValue = try? load() {
                box.value = savedValue
            } else {
                save(box.value)
            }
        }
    }

    private func load() throws -> Value {
        let loadedValue = try Disk.retrieve(filename, from: .appGroup, as: Value.self)
        print("[DiskBacked] Retrieved existing value from \(filename) in \(Disk.Directory.appGroup)")
        return loadedValue
    }

    private func save(_ newValue: Value) {
        do {
            if let optional = newValue as? AnyOptional, optional.isNil {
                // Let's allow this to fail silently if the file doesn't exist
                try? Disk.remove(filename, from: .appGroup)
                print("[DiskBacked] Deleted \(filename) from \(Disk.Directory.appGroup)")
            } else {
                try Disk.save(newValue, to: .appGroup, as: filename)
                print("[DiskBacked] Updated \(filename) in \(Disk.Directory.appGroup)")
            }
        } catch {
            print("[DiskBacked] Error: \(error)")
        }
    }
}

// MARK: - Helpers for Optional Values

extension DiskBacked where Value: ExpressibleByNilLiteral {
    init(filename: String) {
        self.init(wrappedValue: nil, filename: filename)
    }
}

private protocol AnyOptional {
    var isNil: Bool { get }
}
