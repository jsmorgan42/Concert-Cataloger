//
//  Artist+Helpers.swift
//  Concert Cataloger
//
//  Created by Jesse Morgan on 8/15/22.
//extension Artist : Identifiable {
//

import Foundation
import CoreData

extension Artist {

    var displayName: String {
        name ?? ""
    }
}
