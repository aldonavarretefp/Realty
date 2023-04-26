//
//  Calendar.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 17/04/23.
//

import Foundation

extension Calendar {
    func numberOfDaysBetween(_ from: Date, and to: Date) -> Int {
        
        let fromDate = startOfDay(for: from)
        let toDate = startOfDay(for: to)
        let diff = dateComponents([.day], from: fromDate, to: toDate)
    
        guard let numberOfDays = diff.day else { return 0 }
        
        return numberOfDays
    }
}
