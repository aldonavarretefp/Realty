//
//  ExpandedTenantView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 21/12/22.
//

import SwiftUI
import Kingfisher

struct ExpandedTenantView: View {
    
    private var tenant: Tenant = .init(id: UUID().uuidString, name: "Doris", middleName: "Gray", lastName: "Gorczany", secondLastName: "Donnelly", startDate: Date.from(day: 12, month: 05, year: 2022), endDate: Date.from(day: 30, month: 04, year: 2023), paymentDOTM: 2, contract: URL(fileURLWithPath: "pr-sample-contract"))
    
    private var guestName: String { tenant.name }
    private var startDate: Date {
        if let startDate = tenant.startDate {
            return startDate
        }
        return Date.now
    }
    private var endDate: Date {
        if let endDate = tenant.endDate {
            return endDate
        }
        return Date.now
    }
    
    @State private var showPDFSheet: Bool = false
    
    public var tenantL: Tenant
    
    init(tenantLim: Tenant){
        self.tenantL = tenantLim
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image("avatar 1")
                    .resizable()
                    .scaledToFill()
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        minHeight: 0,
                        maxHeight: 400
                    )
                    .clipped()
                Text(tenantL.name)
                    .font(.system(size: 40))
                    .fontWeight(.bold)
                    .padding(.leading, 20)
                DateInfoView(startDate: startDate, endDate: endDate)
                VStack(alignment: .center) {
                    HStack(spacing: 40) {
                        Button("Ver contrato"){
                            showPDFSheet.toggle()
                        }
                        .bold()
                        .font(.callout)
                        .padding(10)
                        .frame(width: 120, height: 44)
                        .foregroundColor(Color.white)
                        .background(Color(.systemBlue))
                        .cornerRadius(12)
                        Button("Renovar contrato"){
                            showPDFSheet.toggle()
                        }
                        .bold()
                        .lineLimit(1)
                        .minimumScaleFactor(0.7)
                        .font(.callout)
                        .padding(10)
                        .frame(width: 120, height: 44)
                        .foregroundColor(Color.white)
                        .background(Color(.systemGreen))
                        .cornerRadius(12)
                    }
                    
                    
                }
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 120,
                    maxHeight: .infinity
                )
            }
        }
        .edgesIgnoringSafeArea(.top)
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .topLeading
        )
        .sheet(isPresented: $showPDFSheet){
            ContractView(withTenantName: tenant.name)
        }
    }
}

struct DateInfoView: View {
    
    let startDate: Date
    let endDate: Date
    var nextPaymentDate: Date {
        guard let nextPaymentDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate) else { return Date.now }
        return nextPaymentDate
    }
    var tempPercentage: Double {
        let daysPassed: Int = Calendar.current.numberOfDaysBetween(startDate, and: Date.now)
        let x: Double = Double(daysPassed) / Double(365)
        return x
    }
    
    private let adaptiveCol = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        LazyVGrid(columns: adaptiveCol, spacing: 20) {
            VStack {
                Text("Fecha de inicio")
                    .font(.caption)
                    .padding(.bottom, 1)
                Text(startDate.localizedString)
                    .font(.headline)
                    .foregroundColor(Color(.systemBlue))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
            }
            VStack {
                Text("Fin de contrato")
                    .font(.caption)
                    .padding(.bottom, 1)
                Text(endDate.localizedString)
                    .font(.headline)
                    .foregroundColor(Color(.systemBlue))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
            }
            VStack {
                Text("Próxima fecha de pago")
                    .font(.caption)
                    .padding(.bottom, 1)
                Text(endDate.localizedString)
                    .font(.headline)
                    .foregroundColor(Color(.systemBlue))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
            }
            VStack {
                Text("Linea temporal")
                    .font(.caption)
                    .padding(.bottom, 15)
                ProgressView(value: tempPercentage)
                    .frame(width: 100)
                    .foregroundColor(.blue)
                    .tint(.blue)
                    .progressViewStyle(.linear)
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 100,
            maxHeight: 200
        )
    }
}

//struct Previews_ContactoExpandidoView_Previews: PreviewProvider {
//    static var previews: some View {
//        ExpandedTenantView(tenantLimited: .init(name: "Abuelo"))
//    }
//}
