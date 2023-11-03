//
//  Transaction.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 25/04/23.
//

import Foundation
import FirebaseFirestore

struct Transaction: Codable, Identifiable {
    @DocumentID var id: String?
    var date: Date
    var income: Double
    var tenantId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case date
        case income = "amount"
        case tenantId
      }
}
