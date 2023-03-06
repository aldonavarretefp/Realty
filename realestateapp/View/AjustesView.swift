//
//  AjustesView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 23/12/22.
//

import SwiftUI

struct AjustesView: View {
    
    @State private var isOn:Bool = false
    @State private var inputOn: Bool = false
    
    @EnvironmentObject var authModel: AuthViewModel
    
    var body: some View {
        NavigationView {
            List{
                HStack{
                    Text("Nombre")
                        .font(.title)
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: "person.fill")
                        .resizable()
                        .frame(width: 50,height: 50)
                        .padding(20)
                        .clipShape(Circle())
                        .background(Color(.systemGray5))
                        .foregroundColor(.white)
                        .cornerRadius(50)
                }
                Section("Perfil"){
                    Button("Cambiar Nombre") {
                        inputOn.toggle()
                            }
                            .alert("Nombre", isPresented: $inputOn, actions: {
                                TextField("e.g. Roberto Martinez", text: .constant(""))
                                Button("Confirmar", action: {})
                                           Button("Cancel", role: .cancel, action: {})
                            }, message: {
                                // Any view other than Text would be ignored
                                TextField("TextField", text: .constant("Inserte un nombre"))
                            }
                            )
                    Text("Otro ajuste")
                    Text("Otro ajuste")
                    Text("Otro ajuste")
                    
                }
                Section("Propiedades"){
                    Toggle("Modo obscuro", isOn: $isOn)
                    Text("Otro ajuste")
                    
                }
                Section("Guéspedes"){
                    Toggle("Modo obscuro", isOn: $isOn)
                    Text("Otro ajuste")
                    
                }
                Section("Apariencia"){
                    Toggle("Modo obscuro", isOn: $isOn)
                    Text("Otro ajuste")
                    
                }
                
                Button(role: .destructive, action: {}, label: {
                    Label("Borrar Cuenta", systemImage: "trash")
                }).foregroundColor(.red)
            }
            .navigationTitle("Ajustes")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            authModel.logOut()
                        }, label: {
                            Label("Salir", systemImage: "rectangle.portrait.and.arrow.right")
                        }).foregroundColor(Color(.systemBlue))
                        
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.init(degrees: 90))
                            .scaleEffect(0.8)
                            .tint(.accentColor)
                    }
                    
                }
            }
            
        }
    }
}

struct Previews_AjustesView_Previews: PreviewProvider {
    static var previews: some View {
        AjustesView()
    }
}
