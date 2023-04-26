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
        HStack(spacing: 10) {
            Text("name")
                .font(.subheadline)
                .fontWeight(.bold)
                .foregroundColor(Color("primary"))
                .lineLimit(2)
                .frame(width: 100, alignment: .leading)
            VStack {
                Text("\(transaction.date.getMonthLocalizedString.capitalized)")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(Color("primary"))
                Text("\(transaction.date.get(.day))")
                    .font(.headline)
                    .bold()
                    .foregroundColor(.blue)
            }
            .frame(width: 50, alignment: .leading)
//            Text(transaction.date.localizedString)
//                .font(.subheadline)
//                .fontWeight(.bold)
//                .foregroundColor(Color("primary"))
//                .lineLimit(2)
//                .frame(width: 100, alignment: .leading)
            Text("+\(transaction.income, specifier: "%.2f")")
                .font(.callout)
                .fontWeight(.bold)
                .foregroundColor(Color(#colorLiteral(red: 0.2, green: 0.78, blue: 0.35, alpha: 1)))
                .frame(width: 90, alignment: .leading)
            Button(action: {
                showSheet.toggle()
            }, label: {
                Image(systemName: "plus")
                    .colorInvert()
                    .foregroundColor(Color("primaryInvert"))
                    .font(.system(size: 30))
                    .bold()
            })
            .padding(.trailing, 5)
            .sheet(isPresented: $showSheet){
                ExpandedTenantView()
                    .presentationDetents([.fraction(0.80), .large])
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: 380,
            minHeight: 60,
            maxHeight: 80
        )
        .background(Color("primaryInvert"))
        .cornerRadius(10)
        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), radius:8, x:2, y:5)
    }
    
}

struct Previews_TransactionViewRow_Previews: PreviewProvider {
    static var previews: some View {
        TransactionView([])
    }
}
