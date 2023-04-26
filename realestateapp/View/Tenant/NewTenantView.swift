//
//  NewTenantView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 13/04/23.
//

import SwiftUI

struct NewTenantView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: Bingings
    @Binding var tenantName: String
    
    // MARK: State vars
    @State private var navTitle: String = "Nuevo Inquilino"
    @State private var isSubmitButtonDisabled: Bool = true
    
    var body: some View {
        form
    }
    
    func submitTenantToProperty(_ name: String) async {
        presentationMode.wrappedValue.dismiss()
    }
}

extension NewTenantView {
    var form: some View {
        Form {
//            Section {
//                Button(action: {
//                    print("TApped button")
//                }) {
//                    HStack {
//                        Spacer()
//                        Image(systemName: "plus")
//                            .foregroundColor(.black)
//                            .font(.title)
//                            .frame(width: 80, height: 80)
//                            .background(Color(#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5)))
//                            .clipShape(Circle(), style: FillStyle())
//                            .onTapGesture {
//                                print("submit tenant photo")
//                            }
//                        Spacer()
//                    }
//                }
//                .listRowBackground(Color.clear)
//                .frame(height: 80)
//            }
            Section("Nombre") {
                TextField("Inserte nombre", text: $tenantName)
                    .onChange(of: tenantName, perform: { newValue in
                        isSubmitButtonDisabled = tenantName.isEmpty ? true : false
                    })
            }
        }
        .navigationTitle(navTitle)
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button(action: hideKeyboard) {
                    Text("Listo")
                }
            }
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    Task {
                        await submitTenantToProperty(tenantName)
                    }
                } label: {
                    Text("Crear")
                        .padding(.trailing, 10)
                }
                .disabled(isSubmitButtonDisabled)
                .cornerRadius(10)
            }
        }
    }
}
