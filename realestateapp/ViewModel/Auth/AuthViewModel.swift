//
//  AuthViewModel.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 04/03/23.
//

import Foundation
import SwiftUI
import Firebase

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    init() {
        self.userSession = Auth.auth().currentUser
        print("DEBUG: Current User session is \(String(describing: userSession))")
    }
    func login(withEmail email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else { return }
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print("DEBUG: Error, signin failed \(e.localizedDescription)")
                return
            }
            
            guard let user = authResult?.user else { return }
            
            self.userSession = user
            print("DEBUG: User Signed in Succesfully")
            print(user)
        }
    }
    
    func register(withEmail email: String, password: String, name: String, lastName: String) {
        guard !email.isEmpty, !password.isEmpty else { return }
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print("DEBUG: Error, register failed \(e.localizedDescription)")
                return
            }
            guard let user = authResult?.user else { return }
            self.userSession = user
            
            let data:[String: String] = [
                "email": email,
                "name": name,
                "lastname": lastName,
                "uid": user.uid
            ]
            
            Firestore.firestore().collection("users").document(user.uid)
                .setData(data) { _ in
                    print("DEBUG: User data set!")
                }
            
            print("DEBUG: User Registered Succesfully")
        }
    }
    
    func logOut() {
        try? Auth.auth().signOut()
        userSession = nil
        print("DEBUG: User Signed Out Succesfully")
    }
}
