//
//  Property.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 23/12/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Property: Identifiable, Decodable, Equatable {
    static func == (lhs: Property, rhs: Property) -> Bool {
        lhs.address == rhs.address &&
        lhs.title == rhs.title &&
        lhs.area == rhs.area &&
        lhs.noRooms == rhs.noRooms
    }
    
    @DocumentID var id: String?
    var imgName: String? = "casa1"
    var title: String
    var address: String
    var tenant: Tenant?
    var area: Double? = 10.0
    var noRooms: Int? = 4

    
    enum CodingKeys: String, CodingKey {
        case id = "uid"
        case title = "name"
        case address = "address"
        case area = "area"
        case noRooms = "noRooms"
    }
}
