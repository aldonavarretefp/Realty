//
//  AjustesView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 23/12/22.
//

import SwiftUI
import Kingfisher

struct AjustesView: View {
    
    @EnvironmentObject var authModel: AuthViewModel
    
    @State private var isOn:Bool = false
    @State private var showingAlert: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    @State private var textFieldName: String = ""
    
    @State private var user: LandLordUser? = nil
    
    var body: some View {
        NavigationView {
            if let user = authModel.currentLandlord {
                List{
                    HStack{
                        Text(user.name)
                            .font(.title)
                            .padding(.horizontal, 10)
                        Spacer()
                        Button {
                            showImagePicker.toggle()
                        } label: {
                            if let profileImageUrl = authModel.currentLandlord?.profileImageUrl {
                                KFImage(URL(string: profileImageUrl))
                                    .resizable()
                                    .scaledToFill()
                                    .modifier(ProfileImageModifier())
                            } else {
                                Image(systemName: "person.fill")
                                    .renderingMode(.template)
                                    .font(.largeTitle)
                                    .modifier(ProfileImageModifier())
                            }
                        }
                        .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                            ImagePicker(selectedImage: $selectedImage)
                        }
                    }
                    Section("Perfil"){
                        Button("Cambiar Nombre") {
                            withAnimation {
                                self.showingAlert.toggle()
                            }
                        }
                        .alert("Nombre", isPresented: $showingAlert, actions: {
                            TextField("e.g. Roberto Martinez", text: $textFieldName)
                            Button("Confirmar") {
                                loadName()
                            }
                            Button("Cancel", role: .cancel) {
                                
                            }
                        }, message: {
                            // Any view other than Text would be ignored
                            TextField("TextField", text: .constant("Inserte un nombre"))
                        })
                        .foregroundColor(Color(UIColor.black))
                    }
                    Section("Apariencia"){
                        Toggle("Modo obscuro", isOn: $isOn)
                    }
                    Button {
                        
                    } label: {
                        Label("Borrar Cuenta", systemImage: "trash")
                    }
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
            else {
                VStack {
                    Text("Oh no, it seems that the user could not be fetched, if you think that's an error please contact the developer.")   
                }
            }
        }
        .accentColor(.black)
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    //MARK: - loading
    
    func loadName() -> Void {
        guard textFieldName != "" else { return }
        authModel.updateName(with: textFieldName)
    }
    
    func loadImage() {
        guard let selectedImage = selectedImage else {
            print("DEBUG error selectedImage is nil")
            return
        }
        profileImage = Image(uiImage: selectedImage)
        authModel.uploadProfileImage(selectedImage)
    }
}

private struct ProfileImageModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(width: 80,height: 80)
            .foregroundColor(.white)
            .background(Color(.systemGray5))
            .clipShape(Circle())
    }
}

struct Previews_AjustesView_Previews: PreviewProvider {
    static var previews: some View {
        AjustesView()
            .environmentObject(AuthViewModel())
    }
}
