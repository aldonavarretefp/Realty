//
//  Owner.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 23/12/22.
//

import Foundation
import FirebaseFirestore

struct LandLordUser: Codable, Identifiable {
    @DocumentID var id: String?
    var profileImageUrl: String?
    var name: String
    var lastName: String
    var email: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case lastName = "lastname"
        case name
        case email
        case profileImageUrl
      }
}
