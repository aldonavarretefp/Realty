//
//  NewTransactionView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 08/05/23.
//

import SwiftUI

struct NewTransactionView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var transactions: [Transaction]

    @State private var transactionTenantName: String = ""
    @State private var transactionAmount: Double = 0.0
    @State private var transactionDate: Date = Date.now
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Nombre", text: $transactionTenantName)
                TextField("Cantidad", value: $transactionAmount, format: .number)
                    .keyboardType(.decimalPad)
                DatePicker("Fecha", selection: $transactionDate, in: ...Date.now, displayedComponents: .date)
                    .datePickerStyle(.compact)
            }
            .navigationTitle("Nueva transacción")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Agregar") {
                        Task {
                            await uploadTransaction()
                        }
                    }
                }
            }
            
        }
    }
    private func uploadTransaction() async {
        let newTransaction:Transaction = Transaction(date: transactionDate, income: transactionAmount, tenantId: "")
        await authModel.uploadTransaction(transaction: newTransaction)
        presentationMode.wrappedValue.dismiss()
    }
}

struct NewTransactionView_Previews: PreviewProvider {
    static var previews: some View {
        NewTransactionView(transactions: .constant([]))
    }
}
