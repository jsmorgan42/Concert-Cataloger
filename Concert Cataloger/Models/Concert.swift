//
//  Concert.swift
//  Concert Cataloger
//
//  Created by Jesse Morgan on 5/31/22.
//

//import CoreLocation
import UIKit

struct Concert: Codable {

    let uuid: UUID
    let artists: [Artist]
    let date: Date
//    let location: CLLocation?
//    let images: [UIImage]?
}
