//
//  Double.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 17/04/23.
//

import Foundation

extension Double {
    var stringFormat: String {
        if self  >= 1000 && self <= 999999 {
            return String(format: "%.1fK", self / 1000)
        }
        if self > 999999 {
            return String(format: "%.1M", self / 1000000)
        }
        
        return String(format: "%.0f.0", self)
    }
    
}
