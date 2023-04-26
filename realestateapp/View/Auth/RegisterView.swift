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
    @EnvironmentObject var authModel:AuthViewModel
    
    var body: some View {
        VStack {
            Text("Regístrate")
                .font(.largeTitle)
                .fontWeight(.bold)
                .frame(height: 100)
            ZStack{
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color(#colorLiteral(red: 0.1725490242242813, green: 0.1725490242242813, blue: 0.18039216101169586, alpha: 1)))
                    .frame(height: 450)
                    .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:8, x:2, y:15)
                VStack(alignment: .leading) {
                    Text("Email")
                        .foregroundColor(.white)
                        .padding(.leading,5)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(#colorLiteral(red: 0.9490196108818054, green: 0.9490196108818054, blue: 0.9686274528503418, alpha: 1)))
                        TextField("Email", text: $email)
                            .padding(.leading,10)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled(true)
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
                            
                    }
                    .frame(width: 301, height: 54)
                    .padding(.leading,5)
                    Text("Name")
                        .foregroundColor(.white)
                        .padding(.leading,5)
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(#colorLiteral(red: 0.9490196108818054, green: 0.9490196108818054, blue: 0.9686274528503418, alpha: 1)))
                            .frame(width: 301, height: 54)
                        TextField("Name", text: $name)
                            .padding(.leading,10)
                            
                    }
                    .frame(width: 301, height: 54)
                    .padding(.leading,5)
                    Text("Last Name")
                        .foregroundColor(.white)
                        .padding(.leading,5)
                    ZStack {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color(#colorLiteral(red: 0.9490196108818054, green: 0.9490196108818054, blue: 0.9686274528503418, alpha: 1)))
                            .frame(width: 301, height: 54)
                        TextField("Last Name", text: $lastName)
                            .padding(.leading,10)
                            
                    }
                    .frame(width: 301, height: 54)
                    .padding(.leading,5)
                    
                }
                .padding(.top,-50)
            }
            .frame(width: 334)
            Button {
                authModel.register(withEmail: email, password: password,name: name, lastName: lastName)
            } label: {
                Text("Registrar")
                    .frame(width: 334, height: 50)
                    .background(Color(.systemBlue))
                    .foregroundColor(.white)
                    .cornerRadius(14)
                    .padding(.top,20)
            }
            Spacer()
            HStack {
                Text("Ya tienes cuenta?")
                    .font(.caption)
                NavigationLink(destination: LoginView()) {
                    Text("Inicia Sesión")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(Color(.systemBlue))
                }
            }
            
        }
            .frame(width: 334)
            .navigationBarBackButtonHidden()
    }
}
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
