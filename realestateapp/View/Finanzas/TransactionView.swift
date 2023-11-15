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
        HStack(spacing: 30) {
            Text("name")
                .font(.subheadline)
                .fontWeight(.bold)
                .lineLimit(2)
                .frame(width: 100, alignment: .center)
            VStack {
                Text("\(transaction.date.getMonthLocalizedString.capitalized)")
                    .font(.subheadline)
                    .bold()
                Text("\(transaction.date.get(.day))")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.blue)
            }
            .frame(width: 50, alignment: .center)
            Text("+\(transaction.income, specifier: "%.2f")")
                .font(.callout)
                .fontWeight(.bold)
                .foregroundColor(Color(#colorLiteral(red: 0.2, green: 0.78, blue: 0.35, alpha: 1)))
                .frame(width: 100, alignment: .center)
        }
        .frame(
            maxWidth: 320,
            minHeight: 60,
            maxHeight: 90
        )
        .cornerRadius(10)
        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius:8, x:2, y:5)
    }
    
}

struct Previews_TransactionViewRow_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView([.init(date: .now, income: 213.2, tenantId: "12213")])
    }
}
