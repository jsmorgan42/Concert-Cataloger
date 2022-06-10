//
//  Artist.swift
//  Concert Cataloger
//
//  Created by Jesse Morgan on 5/31/22.
//

import Foundation

struct Artist: Codable {

    let name: String
    let concerts: [Concert]
}
