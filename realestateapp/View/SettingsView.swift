//
//  SettingsView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 23/12/22.
//

import SwiftUI
import Kingfisher

struct SettingsView: View {
    
    @AppStorage("isDarkMode") private var isDark = false
    @EnvironmentObject var authModel: AuthViewModel
    @State private var showingAlert: Bool = false
    @State private var showImagePicker: Bool = false
    @State private var selectedImage: UIImage?
    @State private var profileImage: Image?
    @State private var textFieldName: String = ""
    @State private var confirmationShown = false
    
    var body: some View {
        NavigationView {
            if let user = authModel.currentLandlord {
                List {
                    Section {
                        VStack {
                            Button(action: {
                                showImagePicker.toggle()
                            }) {
                                HStack {
                                    Spacer()
                                    if let profileImageUrl = user.profileImageUrl {
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
                                    Spacer()
                                }
                            }
                            .buttonStyle(BorderlessButtonStyle())
                            Text(user.name)
                                .font(.title)
                                .padding(.horizontal, 50)
                        }
                        .listRowInsets(.init())
                        .cornerRadius(15)
                    }
                    .listRowBackground(Color.clear)
                    
                    Section("Perfil") {
                        Button("Cambiar Nombre") {
                            withAnimation {
                                showingAlert.toggle()
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
                    
                    }
                    
                    Section("Apariencia") {
                        Toggle("Modo obscuro", isOn: $isDark)
                    }
                    
                    Section("Cuenta") {
                        NavigationLink("Ajustes de la cuenta") {
                            List {
                                Button(role: .destructive) {
                                    confirmationShown.toggle()
                                } label: {
                                    Label("Borrar Cuenta", systemImage: "trash")
                                        .foregroundColor(.red)
                                }
                                .confirmationDialog("Are you sure?",
                                                    isPresented: $confirmationShown) {
                                    Button("Borrar Cuenta", role: .destructive) {
                                        Task {
                                            await authModel.deleteUser()
                                        }
                                    }
                                } message: {
                                    Text("No podrá deshacer esta acción y la información proporcionada será borrada.")
                                }
                                
                            }
                        }
                    }
                    
                    Section {
                        Button(action: {
                            authModel.logOut()
                        }, label: {
                            Label("Salir", systemImage: "rectangle.portrait.and.arrow.right")
                        })
                        .foregroundColor(Color(.systemBlue))
                    }
                    
                }
                .navigationTitle("Ajustes")
                .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                    ImagePicker(selectedImage: $selectedImage)
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
        SettingsView()
            .environmentObject(AuthViewModel())
    }
}
