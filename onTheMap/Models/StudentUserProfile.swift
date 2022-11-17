//
//  StudentUserProfile.swift
//  onTheMap
//
//  Created by MACBOOK PRO on 11/17/22.
//

import Foundation

struct StudentUserProfile: Codable {
    let firstName: String
    let lastName: String
    let nickname: String
    
    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case nickname
    }
 
}
