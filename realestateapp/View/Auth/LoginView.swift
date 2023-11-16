//
//  LoginView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 01/03/23.
//

import SwiftUI

struct LoginView: View {
    
    @State var email: String = ""
    @State var password: String = ""
    @EnvironmentObject var authModel:AuthViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Bienvenido")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .frame(height: 200)
                ZStack{
                    RoundedRectangle(cornerRadius: 14)
                        .fill(Color(#colorLiteral(red: 0.1725490242242813, green: 0.1725490242242813, blue: 0.18039216101169586, alpha: 1)))
                        .frame(height: 320)
                        .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:8, x:2, y:15)
                    VStack(alignment: .leading) {
                        Text("Email")
                            .foregroundColor(.white)
                            .padding(.leading,5)
                            .padding(.leading,10)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(#colorLiteral(red: 0.9490196108818054, green: 0.9490196108818054, blue: 0.9686274528503418, alpha: 1)))
                            TextField("Email", text: $email)
                                .padding(.leading,10)
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled(true)
                                .foregroundColor(.black)
                        }
                        .frame(width: 301, height: 54)
                        .padding(.leading,5)
                        Text("Password")
                            .foregroundColor(.white)
                            .padding(.leading,5)
                        ZStack {
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color(#colorLiteral(red: 0.9490196108818054, green: 0.9490196108818054, blue: 0.9686274528503418, alpha: 1)))
                                .frame(width: 301, height: 54)
                            SecureField("Password", text: $password)
                                .padding(.leading,10)
                                .foregroundColor(.black)
                                
                        }
                        .frame(width: 301, height: 54)
                        .padding(.leading,5)
                    }
                    .padding(.top,-50)
                }
                .frame(width: 334)
                Button {
                    authModel.login(withEmail: email, password: password)
                } label: {
                    Text("Ingresa")
                        .frame(maxWidth: .infinity,minHeight: 50, maxHeight: 50)
                        .background(Color(.systemBlue))
                        .foregroundColor(.white)
                        .cornerRadius(14)
                        .padding(.top,10)
                }

                HStack {
                    Spacer()
                    NavigationLink {
                        Text("Olvidaste tu contraseña")
                    }label: {
                        Text("Olvidaste tu contraseña?")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(.systemBlue))
                    }
                }
                Spacer()
                HStack {
                    Text("No tienes cuenta?")
                        .font(.caption)
                    NavigationLink {
                        RegisterView()
                    }label: {
                        Text("Registrate")
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(Color(.systemBlue))
                        
                    }
                }
            }
                .frame(width: 334)
                .onTapGesture {
                    self.hideKeyboard()
                }
        }
        
        
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
