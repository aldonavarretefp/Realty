//
//  ContactoExpandidoView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 21/12/22.
//

import SwiftUI

struct ContactoExpandidoView: View {
    
    var guestName: String = "Talan Schleifer"
    var startDate: Date = Date.now
    var endDate: Date = Date.from(day: 2, month: 12)
    var nextPaymentDate = Date.from(day:10, month:11)
    var tempPercentage: Float = 0.45
    @State private var showPDFSheet: Bool = false
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Image("avatar 1")
                    .resizable()
                    .scaledToFill()
                VStack(alignment: .leading) {
                    Text(guestName)
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                    GuestInfoView(startDate: startDate, endDate: endDate, nextPaymentDate: nextPaymentDate, tempPercentage: tempPercentage)
                    Text("Contrato")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 16)
                    Spacer()
                    VStack {
                        Spacer()
                        HStack {
                            Spacer()
                            Button("Ver contrato"){
                                showPDFSheet.toggle()
                            }
                            .sheet(isPresented: $showPDFSheet){
                                ContractView()
                            }
                            .bold()
                            .font(.callout)
                            .padding(10)
                            .foregroundColor(Color.white)
                            .background(Color(.systemBlue))
                            .cornerRadius(12)
                            Spacer()
                        }
                        Spacer()
                    }
                    
                    
                }
                .padding(.leading, 20)
                
                
            }
            
        }
            .edgesIgnoringSafeArea(.top)
    }
}

struct GuestInfoView: View {
    
    var startDate: Date = Date.now
    var endDate: Date = Date.from(day: 2, month: 12)
    var nextPaymentDate = Date.from(day:10, month:11)
    var tempPercentage: Float = 0.45
    
    var body: some View {
        HStack {
            VStack {
                Text("Fecha de inicio")
                    .font(.caption)
                    .padding(.bottom, 1)
                Text(startDate, style: .date)
                    .font(.headline)
                    .foregroundColor(Color(.systemBlue))
                    .fontWeight(.bold)
            }
            Spacer()
            VStack {
                Text("Fin de contrato")
                    .font(.caption)
                    .padding(.bottom, 1)
                Text(endDate, style: .date)
                    .font(.headline)
                    .foregroundColor(Color(.systemBlue))
                    .fontWeight(.bold)
            }
            Spacer()
        }
        .padding(.leading, 10)
        .padding(.top, -5)
        
        HStack{
            VStack{
                Text("Proxima fecha de pago")
                    .font(.caption)
                    .padding(.bottom, 1)
                Text(nextPaymentDate, style: .date)
                    .font(.headline)
                    .foregroundColor(Color(.systemBlue))
                    .fontWeight(.bold)
            }
            Spacer()
            VStack{
                Text("Línea Temporal")
                    .font(.caption)
                    .padding(.bottom, 10)
                ProgressView(value: 0.2)
                    .frame(width: 100)
                
            }
            Spacer()
        }
        .padding(.top, 20)
        .padding(.leading, 10)
        .padding(.top, -5)
    }
}


struct Previews_ContactoExpandidoView_Previews: PreviewProvider {
    static var previews: some View {
        ContactoExpandidoView()
    }
}
