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
    
    // MARK: State vars
    @State private var isLoading: Bool = false
    @State private var isSubmitButtonDisabled: Bool = true
    @State private var isPresentingConfirm: Bool = false
    @State private var noRooms: Int?
//    private var noRoomsVar: Int {
//        guard let noRooms = property.noRooms else {
//            return 0
//        }
//        return noRooms
//    }
    @Binding var property: Property
    
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
                    Stepper("\(String(describing: noRooms))", onIncrement: {
                        property.noRooms = noRooms
                    }, onDecrement: {
                        property.noRooms = noRooms
                    })
                }
                Section("Dirección") {
                    TextField("¿Dónde se encuentra?", text: $property.address)
                        .submitLabel(.go)
                }
                Section(content: {
                    NavigationLink("Información de inquilino/huésped", destination: NewTenantView())
                }, header: {
                    Text("Inquilino")
                }, footer: {
                    Text("Puedes omitir este campo para después.")
                })
                Section("Área (en metros cuadrados)") {
                    TextField("Area", value: $property.area, format: .number)
                        .keyboardType(.decimalPad)
                }
                Button("Borrar", role: .destructive) {
                    isPresentingConfirm = true
                }
                .confirmationDialog("¿Está seguro de borrar la propiedad?",
                                    isPresented: $isPresentingConfirm) {
                    Button("Borrar Propiedad", role: .destructive) {
                        deleteProperty(property: property)
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
                        .padding(.trailing, 10)
                }
                .disabled(isSubmitButtonDisabled)
                .cornerRadius(10)
            }
            
        }
        .navigationTitle(property.title)
    }
    
    func deleteProperty(property: Property) -> Void {
        isLoading = true
        authModel.deleteProperty(property: property)
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
        EditPropertyView(property: .constant(.init(title: "Nueva", address: "Propiedad")))
    }
}
