//
//  Location.swift
//  onTheMap
//
//  Created by MACBOOK PRO on 11/17/22.
//

import Foundation
//Struct for Location
struct Location: Codable {
    let objectId: String
    let uniqueKey: String?
    let firstName: String?
    let lastName: String?
    let mapString: String?
    let mediaURL: String?
    let latitude: Double?
    let longitude: Double?
    let createdAt: String
    let updatedAt: String
}
