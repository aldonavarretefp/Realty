//
//  RegisterView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 04/03/23.
//

import SwiftUI

struct RegisterView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @State var name: String = ""
    @State var lastName: String = ""
    @State var isTenant: Bool = false
    @EnvironmentObject var authModel:AuthViewModel
    
    var body: some View {
        VStack {
            Text("Regístrate")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(height: 100)
                VStack(alignment: .leading) {
                    Text("Email")
                        .foregroundColor(.white)
                        .padding(.leading,5)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    ZStack {
                        TextField("Email", text: $email)
                            .frame(height: 53)
                            .padding(.leading,10)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.secondary)
                            )
                            
                        
                        
                    }
                    .frame(width: 301, height: 54)
                    .padding(.leading,5)
                    Text("Password")
                        .foregroundColor(.white)
                        .padding(.leading,5)
                    ZStack {
                        SecureField("Password", text: $password)
                            .padding(.leading,10)
                            .frame(height: 53)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.secondary)
                            )
                        
                    }
                    .frame(width: 301, height: 54)
                    .padding(.leading,5)
                    Text("Name")
                        .foregroundColor(.white)
                        .padding(.leading,5)
                    ZStack {
                        TextField("Name", text: $name)
                            .padding(.leading,10)
                            .frame(height: 53)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.secondary)
                                
                            )
                        
                    }
                    .frame(width: 301, height: 54)
                    .padding(.leading,5)
                    Text("Last Name")
                        .foregroundColor(.white)
                        .padding(.leading,5)
                    ZStack {
                        TextField("Last Name", text: $lastName)
                            .padding(.leading,10)
                            .frame(height: 53)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(.secondary)
                                
                            )
                    }
                    .frame(width: 301, height: 54)
                    .padding(.leading,5)
                    
                    ZStack {
                        Toggle("Tenant", isOn: $isTenant)
                            .foregroundStyle(.primary)
                    }
                    .frame(width: 301, height: 54)
                    .padding(.leading,5)
                    
                }
                .frame(width: 334)
                .padding(.vertical, 30)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.primary.opacity(0.5))
                        .shadow(color: .secondary, radius: 8, x: 2, y: 15)
                )
            
            Button {
                authModel.register(withEmail: email, password: password,name: name, lastName: lastName, isTenant: isTenant)
            } label: {
                Text("Registrar")
                    .frame(width: 334, height: 50)
                    .background(Color(.systemBlue))
                    .foregroundColor(.white)
                    .cornerRadius(14)
                    .padding(.top,20)
            }
        }
        .frame(width: 334)
    }
}
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
/**
 
 var profileImageUrl: String
 var name: String
 var lastName: String
 var email: String
 var userRole: UserRole
 
 */
