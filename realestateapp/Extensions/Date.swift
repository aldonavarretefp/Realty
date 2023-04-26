//
//  Date.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 16/04/23.
//

import Foundation

extension Date {
    
    static func from(day:Int, month:Int, year: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
    
    var localizedString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.setLocalizedDateFormatFromTemplate("dd MMMM YYYY")
        return formatter.string(from: self)
    }
    
    var getMonthLocalizedString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_MX")
        formatter.setLocalizedDateFormatFromTemplate("MMM")
        return formatter.string(from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
            return calendar.component(component, from: self)
    }

}

