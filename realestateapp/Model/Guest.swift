//
//  Guest.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 23/12/22.
//

import Foundation


struct Guest:Identifiable {
    var id: String
    var name: String
    var middleName: String?
    var lastName: String?
    var secondLastName: String?
    var startDate: Date?
    var endDate: Date?
    var nextPaymentDate: Date?
    
}
