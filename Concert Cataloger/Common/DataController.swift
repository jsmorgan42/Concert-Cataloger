//
//  DataController.swift
//  Concert Cataloger
//
//  Created by Jesse Morgan on 8/15/22.
//

import CoreData
import Foundation

class DataController: ObservableObject {

    let container = NSPersistentContainer(name: "ConcertCataloger")

    init() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Core Data failed to load: \(error.localizedDescription)")
            }
        }
    }
}
