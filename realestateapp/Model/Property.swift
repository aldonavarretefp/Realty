//
//  Property.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 23/12/22.
//

import Foundation

struct Property: Identifiable {
    var id: String
    
    var guests: [Guest]?
    var sqFeetArea: Double?
    
}
