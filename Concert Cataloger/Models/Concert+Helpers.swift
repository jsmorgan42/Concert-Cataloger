//
//  Concert+Helpers.swift
//  Concert Cataloger
//
//  Created by Jesse Morgan on 8/15/22.
//
//

import Foundation
import CoreData

extension Concert {

    var firstArtistName: String {
        return (artists?.firstObject as? Artist)?.name ?? ""
    }
}
