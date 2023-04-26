//
//  Guest.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 23/12/22.
//

import FirebaseFirestoreSwift
import Foundation


struct Tenant: Identifiable, Decodable {
    @DocumentID var id: String?
    var name: String
    var middleName: String?
    var lastName: String?
    var secondLastName: String?
    var startDate: Date?
    var endDate: Date?
    var paymentDOTM: Int?
    var contract: URL?
    var imgUrl: String?
}