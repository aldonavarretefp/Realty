//
//  TransactionView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 21/12/22.
//

import SwiftUI

struct TransactionView: View {
    
    var TransactionItemArr: [TransactionItemData] = [
        .init(pay: 8350.4),
        .init(pay: 850.31221),
        .init(pay: 3350),
        .init(pay: 1000),
        .init(pay: 2300),
        .init(pay: 100),
    ]
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(Color("AccentColor 1"))
                .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
            VStack {
                Spacer()
                ForEach(TransactionItemArr,id:\.id) { item in
                    TransactionItemView(showPay: item.showPay, pay: Double(item.pay))
                }
                Spacer()
                
            }
        }
        .frame(width: 380)
    }
    
}

struct TransactionItemData {
    let id = UUID()
    var pay: Double
    var showPay: Bool
    init(pay: Double = 0) {
        self.pay = pay
        self.showPay = pay == 0 ? false : true
        
    }
}

struct TransactionItemView: View {
    var showPay: Bool
    var pay: Double
    @State private var showSheet: Bool = false
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                .frame(width: 331, height: 54)
                .cornerRadius(14)
            HStack {
                Spacer()
                Image("avatar 1")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
                    .frame(width: 40, height: 40)
                Spacer()
                Text("Zaire Mango")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.black)
                Spacer()
                if showPay{
                    Text("+\(pay, specifier: "%.2f")")
                        .font(.callout)
                        .scaledToFill()
                        .fontWeight(.bold)
                        .foregroundColor(Color(#colorLiteral(red: 0.2, green: 0.78, blue: 0.35, alpha: 1)))
                        .multilineTextAlignment(.center)
                    Spacer()

                }
                Button("Mas info"){
                    showSheet.toggle()
                }
                .sheet(isPresented: $showSheet){
                    ContactoExpandidoView()
                        .presentationDetents([.fraction(0.75),.large])
                }
                Spacer()
            }
            .frame(width: 330)
            
        }
            
    }
}
