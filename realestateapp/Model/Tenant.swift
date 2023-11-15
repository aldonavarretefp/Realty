//
//  Guest.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 23/12/22.
//

import FirebaseFirestore
import Foundation


struct Tenant: Identifiable, Codable, Equatable {
    @DocumentID var id: String?
    var name: String
    var middleName: String?
    var lastName: String?
    var secondLastName: String?
    var startDate: Date?
    var endDate: Date?
    var contract: URL?
    var imgUrl: String?
    var contractUrl: String?
    
    static func ==(lhs: Tenant, rhs: Tenant) -> Bool {
        return lhs.id == rhs.id
    }
}
