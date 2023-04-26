//
//  NewTenantView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 13/04/23.
//

import SwiftUI

struct NewTenantView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    
    // MARK: Bingings
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: State vars
    @State private var navTitle: String = "Nuevo Inquilino"
    @State private var tenantName: String = ""
    @State private var isLoading: Bool = false
    @State private var isSubmitButtonDisabled: Bool = true
    
    var body: some View {
        ZStack {
            form
            if isLoading {
                ZStack {
                    Color.black
                        .opacity(0.4)
                        .ignoresSafeArea(.all)
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .opacity(0.9)
                    
                }
            }
        }
    }
    
    func submitTenantToProperty(_ name: String) async  {
        isLoading = true
        
//        await authModel.uploadProperty(name, noRooms: noRooms, address: address, area: Int(area) ?? 0)
        presentationMode.wrappedValue.dismiss()
    }
}

extension NewTenantView {
    var form: some View {
        Form {
            Section {
                Button(action: {
                    print("TApped button")
                }) {
                    HStack {
                        Spacer()
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                            .font(.title)
                            .frame(width: 80, height: 80)
                            .background(Color(#colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.5)))
                            .clipShape(Circle(), style: FillStyle())
                            .onTapGesture {
                                print("submit tenant photo")
                            }
                        Spacer()
                    }
                }
                .listRowBackground(Color.clear)
                .frame(height: 80)
            }
            Section("Nombre") {
                TextField("Inserte nombre", text: $tenantName)
                    .onChange(of: tenantName, perform: { value in
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

struct Previews_NewTenantView_Previews: PreviewProvider {
    static var previews: some View {
        NewTenantView()
    }
}
