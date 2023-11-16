//
//  Owner.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 23/12/22.
//

import Foundation
import FirebaseFirestore


enum UserRole: String, Codable {
    case landlord
    case tenant
}

class User: Codable, Identifiable {
    @DocumentID var id: String?
    var profileImageUrl: String
    var name: String
    var lastName: String
    var email: String
    var userRole: UserRole
    
    init(id: String? = nil, profileImageUrl: String, name: String, lastName: String, email: String, userRole: UserRole) {
        self.id = id
        self.profileImageUrl = profileImageUrl
        self.name = name
        self.lastName = lastName
        self.email = email
        self.userRole = userRole
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case lastName
        case name
        case email
        case profileImageUrl
        case userRole
    }
}
