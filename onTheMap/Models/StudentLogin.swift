//
//  StudentLogin.swift
//  onTheMap
//
//  Created by MACBOOK PRO on 11/17/22.
//

import Foundation

//Student Login Details

struct StudentLogin: Codable {
    let account: StudentAccount
    let session: Session
}

struct StudentAccount: Codable {
    let registered: Bool
    let key: String
}

