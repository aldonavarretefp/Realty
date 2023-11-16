//
//  Guest.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 23/12/22.
//

import FirebaseFirestore
import Foundation


class Tenant: User {
    var startDate: Date?
    var endDate: Date?
    var imgUrl: String?
    var contractUrl: String?
    
    static func ==(lhs: Tenant, rhs: Tenant) -> Bool {
        return lhs.id == rhs.id
    }
}
