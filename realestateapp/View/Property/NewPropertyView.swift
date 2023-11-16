//
//  NewPropertyView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 13/04/23.
//

import SwiftUI

struct NewPropertyView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    
    // MARK: Bingings
    @Environment(\.presentationMode) var presentationMode
    
    // MARK: State vars
    @State private var noRooms: Int = 0
    @State private var navTitle: String = "Nueva Propiedad"
    @State private var propertyName: String = ""
    @State private var sqFootArea: String = ""
    @State private var address: String = ""
    @State private var isLoading: Bool = false
    @State private var isSubmitButtonDisabled: Bool = true
    @State private var tenantName: String = ""
    
    var body: some View {
        NavigationView {
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
    }
    
    func submitProperty(_ name: String, noRooms: Int, address: String, area: String, tenantName: String) async -> Void {
        guard let areaDouble: Double = Double(area) else { return }
        
        isLoading = true
        
        let property: Property = .init(title: name, address: address, tenant: .init(id: "", profileImageUrl: "", name: "", lastName: "", email: "", userRole: .landlord), area: areaDouble, noRooms: noRooms)
        
        await authModel.uploadProperty(property: property)
        
        presentationMode.wrappedValue.dismiss()
    }
    
    func updateNavTitle() -> Void {
        navTitle = propertyName
    }
}

extension NewPropertyView {
    var form: some View {
        Form {
            Section("Nombre de la propiedad") {
                TextField("Dále un nombre a tu propiedad", text: $propertyName, onCommit: updateNavTitle)
                    .onChange(of: propertyName) {
                        isSubmitButtonDisabled = $0 != "" ? false : true
                    }
            }
            Section("Número de cuartos") {
                Stepper("\(noRooms)", value: $noRooms, in: 0...20)
            }
            Section("Dirección") {
                TextField("¿Dónde se encuentra?", text: $address)
                    .submitLabel(.go)
                    
            }
            Section(content: {
                NavigationLink("Información de inquilino/huésped", destination: NewTenantView(tenantName: $tenantName))
            }, header: {
                Text("Inquilino")
            }, footer: {
                Text("Puedes omitir este campo para después.")
            })
            
            Section("Área (en metros cuadrados)") {
                TextField("\(sqFootArea)", text: $sqFootArea)
                    .keyboardType(.numberPad)
                
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
                        await submitProperty(propertyName, noRooms: noRooms, address: address, area: sqFootArea, tenantName: tenantName)
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
