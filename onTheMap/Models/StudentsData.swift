//
//  StudentData.swift
//  onTheMap
//
//  Created by MACBOOK PRO on 11/17/22.
//

import Foundation

class StudentsData: NSObject {

    var students = [StudentInformation]()

    class func sharedInstance() -> StudentsData {
        struct Singleton {
            static var sharedInstance = StudentsData()
        }
        return Singleton.sharedInstance
    }

}
