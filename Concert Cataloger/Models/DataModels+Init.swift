//
//  Concert+Init.swift
//  Concert Cataloger
//
//  Created by Jesse Morgan on 8/15/22.
//

import CoreData
import Foundation

extension Concert {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(Date(), forKey: #keyPath(date))
        setPrimitiveValue(UUID(), forKey: #keyPath(identifier))
        setPrimitiveValue([], forKey: #keyPath(mediaIdentifiers))
    }
}

extension Artist {

    public override func awakeFromInsert() {
        super.awakeFromInsert()
        setPrimitiveValue(UUID(), forKey: #keyPath(identifier))
    }
}
