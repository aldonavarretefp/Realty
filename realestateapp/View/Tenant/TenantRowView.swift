//
//  TenantRowView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 25/04/23.
//

import SwiftUI


struct TenantRowView: View {
    let tenant: Tenant
    @State private var showSheet: Bool = false
    var body: some View {
        HStack {
            Text(tenant.name)
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(.black)
                .lineLimit(2)
                .frame(width: 100, alignment: .leading)
                .padding(.leading, 20)
            Spacer()
            Button {
                showSheet.toggle()
            } label: {
                Image(systemName: "info.circle")
                    .foregroundColor(.blue)
                    .padding(.trailing, 20)
                    .font(.title3)
            }

            
//            VStack {
//                Text("\(transaction.date.getMonthLocalizedString.capitalized)")
//                    .font(.subheadline)
//                    .bold()
//                    .foregroundColor(Color("primary"))
//                Text("\(transaction.date.get(.day))")
//                    .font(.headline)
//                    .bold()
//                    .foregroundColor(.blue)
//            }
//            .frame(width: 50, alignment: .leading)
//            Text(transaction.date.localizedString)
//                .font(.subheadline)
//                .fontWeight(.bold)
//                .foregroundColor(Color("primary"))
//                .lineLimit(2)
//                .frame(width: 100, alignment: .leading)
//            Text("+\(transaction.income, specifier: "%.2f")")
//                .font(.callout)
//                .fontWeight(.bold)
//                .foregroundColor(Color(#colorLiteral(red: 0.2, green: 0.78, blue: 0.35, alpha: 1)))
//                .frame(width: 90, alignment: .leading)
//            Button(action: {
//                showSheet.toggle()
//            }, label: {
//                Image(systemName: "plus")
//                    .colorInvert()
//                    .foregroundColor(Color("primaryInvert"))
//                    .font(.system(size: 30))
//                    .bold()
//            })
//            .padding(.trailing, 5)
            
        }
        .frame(
            minWidth: 0,
            maxWidth: 250,
            minHeight: 50,
            maxHeight: 50
        )
        .background(.white)
        .cornerRadius(10)
        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius:8, x:2, y:5)
        .sheet(isPresented: $showSheet){
            ExpandedTenantView(tenantLim: tenant)
                .presentationDetents([.fraction(0.80), .large])
        }
    }
    
}
 

struct TenantRowView_Previews: PreviewProvider {
    static var previews: some View {
        TenantRowView(tenant: .init(name: "Aldo Navarrete"))
    }
}
