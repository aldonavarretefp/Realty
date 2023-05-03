//
//  EditPropertyView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 16/04/23.
//

import SwiftUI

struct EditPropertyView: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @EnvironmentObject private var authModel: AuthViewModel
    
    @Binding var property: Property
    
    @Binding var isHomeActive: Bool
    
    // MARK: State vars
    @State private var isLoading: Bool = false
    @State private var isSubmitButtonDisabled: Bool = true
    @State private var isPresentingConfirm: Bool = false
    @State private var noRooms: Int?
    @State private var tenant: Tenant = .init(name: "")
    
    var body: some View {
        ZStack {
            Form {
                Section("Nombre de la propiedad") {
                    TextField("Cambiar nombre", text: $property.title)
                        .submitLabel(.go)
                        .onChange(of: property) {
                            isSubmitButtonDisabled = $0 != property ? true : false
                        }
                }
                Section("Número de cuartos") {
                    Stepper("\(property.noRooms)", value: $property.noRooms, in: 0...20)
                }
                
                Section("Dirección") {
                    TextField("¿Dónde se encuentra?", text: $property.address)
                        .submitLabel(.go)
                }
                
                Section(content: {
                    NavigationLink("Información de inquilino/huésped", destination: {NewTenantView(tenantName: $tenant.name)})
                        .onChange(of: tenant) { newValue in
                            property.tenant = newValue
                        }
                }, header: {
                    Text("Inquilino")
                }, footer: {
                    Text("Puedes omitir este campo para después.")
                })
                
                Section("Área (en metros cuadrados)") {
                    TextField("Area", value: $property.area, format: .number)
                        .keyboardType(.decimalPad)
                }
                Button(role: .destructive, action: {deleteProperty(property: property)}) {
                    Label("Borrar", systemImage: "trash")
                        .foregroundColor(.red)
                }
                .confirmationDialog("¿Está seguro de borrar la propiedad?",
                                    isPresented: $isPresentingConfirm) {
                    Button(role: .destructive, action: {deleteProperty(property: property)}) {
                        Label("Borrar", systemImage: "trash")
                    }
                }
            }
            if isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .opacity(0.9)
                    .background(.black)
                    .opacity(0.4)
                    .edgesIgnoringSafeArea(.all)
            }
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Button(action: hideKeyboard) {
                    Text("Listo")
                }
            }
            
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    updateProperty()
                } label: {
                    Text("Actualizar")
                }
                .disabled(isSubmitButtonDisabled)
            }
            
        }
        .navigationTitle(property.title)
    }
    
    func deleteProperty(property: Property) -> Void {
        isLoading = true
        authModel.deleteProperty(property: property)
        isHomeActive = false
        presentationMode.wrappedValue.dismiss()
    }
    
    func updateProperty() {
        isLoading = true
        authModel.updateProperty(property: property)
        presentationMode.wrappedValue.dismiss()
    }
}

struct EditPropertyView_Previews: PreviewProvider {
    static var previews: some View {
        EditPropertyView(property: .constant(.init(title: "Nueva", address: "Propiedad")), isHomeActive: .constant(false))
    }
}
