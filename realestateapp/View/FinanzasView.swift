//
//  FinanzasView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 21/12/22.
//

import SwiftUI
import Charts


struct FinanzasView: View {
    
    let monthEarns: [MonthEarnsData] = [
        .init(date: Date.from(day: 1, month: 1), income: 3000.4),
        .init(date: Date.from(day: 2, month: 2), income: 4030.4),
        .init(date: Date.from(day: 5, month: 3), income: 5230.4),
        .init(date: Date.from(day: 10, month: 4), income: 6030.4),
        .init(date: Date.from(day: 12, month: 5), income: 7030.4),
        .init(date: Date.from(day: 15, month: 6), income: 9030.4),
        .init(date: Date.from(day: 20, month: 7), income: 9030.4),
        .init(date: Date.from(day: 24, month: 8), income: 9000),
        .init(date: Date.from(day: 30, month: 9), income: 8030.4),
    ]
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .center) {
                    Text("Anual")
                        .font(.title2)
                        .fontWeight(.bold)
                    Chart {
                        ForEach(monthEarns) { monthEarn in
                            BarMark (
                                x: .value("Mes", monthEarn.date, unit: .month),
                                y: .value("Ingresos", monthEarn.income)
                            )
                            .foregroundStyle(Color.green.gradient)
                            .lineStyle(.init(lineWidth: 3, lineJoin: .round))
                            .interpolationMethod(.cardinal)
                            
                        }
                    }
                    .frame(width: 350, height: 210)
                    .chartXAxisLabel(position: .bottom, alignment: .center) {
                        Label("Mes del año", systemImage: "calendar")
                    }
                    .chartYAxisLabel {
                        Label("Ingresos", systemImage: "dollarsign")
                    }
                    
                    Text("Mensual")
                        .font(.title)
                        .fontWeight(.bold)
                    Chart {
                        ForEach(monthEarns) { monthEarn in
                            LineMark (
                                x: .value("Día del mes", monthEarn.date, unit: .day),
                                y: .value("Ingresos", monthEarn.income)
                            )
                            .foregroundStyle(Color.green.gradient)
                            .interpolationMethod(.cardinal)
                        }
                    }
                    .chartXAxisLabel(position: .bottom,alignment: .center, content: {
                        Label("Día del mes", systemImage: "calendar")
                    })
                    .chartYAxisLabel {
                        Label("Ingresos", systemImage: "dollarsign.circle")
                    }
                    .frame(width: 350, height: 210)
                    
                    
                    Text("Últimas transacciones")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    TransactionView()
                    
                    
                    
                }.navigationTitle("Finanzas")
            }
        }
    }
}

struct MonthEarnsData: Identifiable {
    var id = UUID()
    let date: Date
    let income: Float
}

//For testing
extension Date {
    static func from(day:Int, month:Int) -> Date {
        let components = DateComponents(year: 2022, month: month, day: day)
        return Calendar.current.date(from: components)!
    }
}


struct Previews_FinanzasView_Previews: PreviewProvider {
    static var previews: some View {
        FinanzasView()
    }
}
