//
//  TransactionView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 21/12/22.
//

import SwiftUI

struct TransactionView: View {

    var transactionItemArr: [Transaction] = []
    
    init(_ transactionItemArray: [Transaction]) {
        self.transactionItemArr = transactionItemArray
    }
    
    var body: some View {
        LazyVStack(spacing: 15) {
            ForEach(transactionItemArr.sorted(by: { $0.date > $1.date }), id:\.id) {
                TransactionViewRow(transaction: $0)
            }
        }
        
    }
    
}

struct TransactionViewRow: View {
    let transaction: Transaction
    @State private var showSheet: Bool = false
    var body: some View {
        HStack {
            Image(systemName: "lightbulb.min")
                .resizable()
                .padding()
                .scaledToFill()
                .frame(width: 60, height: 60)
                .foregroundStyle(.black.opacity(0.8))
                .background(.secondary.opacity(0.3))
                .clipShape(Circle())
            
            Group {
                VStack(alignment: .leading) {
                    Text("Costco Gas")
                        .bold()
                    Spacer()
                    Text("Gas & Fuel")
                        .foregroundStyle(.secondary)
                }
                
                VStack(alignment: .trailing) {
                    Text("+\(transaction.income, specifier: "%.2f")")
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Spacer()
                    Text("Nov 29, 2021")
                        .foregroundStyle(.secondary)
                }
                .frame(maxHeight: .infinity, alignment: .trailing)
                .padding(.leading, 30)
            }
            .frame(maxWidth: 150)
            .font(.subheadline)
            .padding(.vertical, 10)

            
            
        }
        .frame(
            maxWidth: .infinity
        )
        .padding()
        .background(.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
    
}

struct Previews_TransactionViewRow_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView([.init(date: .now, income: 213.2, tenantId: "12213")])
    }
}
