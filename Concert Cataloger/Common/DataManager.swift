//
//  DataManager.swift
//  Concert Cataloger
//
//  Created by Jesse Morgan on 6/7/22.
//

import Foundation

class DataManager {

    @DiskBacked(filename: "Concerts.data")
    private(set) var concerts: [Concert] = []

    func saveConcert(_ concert: Concert) {
        concerts.append(concert)
    }

}
