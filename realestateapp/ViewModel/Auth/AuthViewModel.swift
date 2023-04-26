//
//  AuthViewModel.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 04/03/23.
//

import Foundation
import SwiftUI
import FirebaseAuth
import FirebaseFirestore

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var didAuthenticateUser: Bool = false
    @Published var currentLandlord: LandLordUser?
    @Published var userProperties: [Property]?
    @Published var userTransactions: [Transaction]?
    private var tempUserSession: FirebaseAuth.User?
    private var userService = UserService()
    private var propertyService = PropertyService()
    
    init() {
        self.userSession = Auth.auth().currentUser
        self.fetchUser()
    }
    
    //MARK: - Authentication
    
    func login(withEmail email: String, password: String) {
        guard !email.isEmpty, !password.isEmpty else { return }
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let e = error {
                print("DEBUG: Error, signin failed \(e.localizedDescription)")
                return
            }
            
            guard let user = authResult?.user else { return }
            self.userSession = user
            self.fetchUser()
            print("DEBUG: User Signed in Succesfully")
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
            self.tempUserSession = user
            
            let data: Dictionary<String, String> = [
                "email": email,
                "name": name,
                "lastname": lastName,
                "uid": user.uid
            ]
            Firestore.firestore().collection("users").document(user.uid)
                .setData(data) { _ in
                    self.didAuthenticateUser = true
                    
                }
            self.userSession = user
        }
    }
    
    func logOut() {
        try? Auth.auth().signOut()
        userSession = nil
    }
    
    //MARK: - Update
    
    func updateName(with newCompleteName: String) -> Void {
        guard let uid = userSession?.uid else { return }
        
        let fullNameArr:[String] = newCompleteName.components(separatedBy: " ")
        
        let docRef = Firestore.firestore().collection("users").document(uid)
        
        let lastName: String? = fullNameArr.count > 1 ? fullNameArr[1] : nil
        if let lastName {
            docRef
                .updateData(["lastname": lastName])
        }
       
        let name = fullNameArr[0] as String
        
        docRef
            .updateData(["name": name])
    }
    
    func updateProperty(property: Property) -> Void {
        guard let propertyUid: String = property.id else { return }
        
        let docRef = Firestore.firestore().collection("properties").document(propertyUid)
        
        docRef.updateData([
            "address": property.address,
            "area": property.area as Any,
            "noRooms": property.noRooms as Any,
            "name": property.title
        ]) { err in
            if let err = err {
                print("DEBUG Error writing document: \(err)")
            } else {
                print("DEBUG Document successfully written!")
            }
        }
    }
    
    //MARK: - Delete
    
    func deleteProperty(property: Property) -> Void {
        guard let propertyUid: String = property.id else { return }
        
        let docRef = Firestore.firestore().collection("properties").document(propertyUid)
        docRef.delete { error in
            if error != nil {
                print("DEBUG error while deleting property.")
            } else {
                print("DEBUG property deleted succesfully.")
            }
        }
    }
    
    //MARK: - upload To Firebase
    
    func uploadProfileImage(_ image: UIImage) {
        guard let uid = userSession?.uid else { return }
        ImageUploader.uploadImage(image: image) { profileImageUrl in
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(["profileImageUrl": profileImageUrl])
        }
    }
    
    func uploadProperty(property: Property) async -> Void {
        guard let uid = userSession?.uid else { return }
        let docRef = Firestore.firestore().collection("properties")
        docRef.addDocument(data: [
                "name": property.title,
                "noRooms": property.noRooms ?? 0,
                "address": property.address,
                "area": property.area ?? 0.0,
                "landlord": uid,
                "tenant": [
                    "name": property.tenant?.name
                ]
            ]) { err in
                if let err = err {
                    print("DEBUG Error writing document: \(err)")
                } else {
                    print("DEBUG Document successfully updated!")
                }
            }
        
    }
    
    func uploadTransaction(transaction: Transaction) async -> Void {
        guard let uid = userSession?.uid else { return }
        let collectionRef = Firestore.firestore().collection("users").document(uid).collection("transactions")
        collectionRef.addDocument(data: [
            "amount": transaction.income,
            "date": transaction.date,
            "tenantId": "JrAyC1dj9Cu6ShumCzZP",
        ]) { err in
            if let err = err {
                print("DEBUG Error writing document: \(err)")
            } else {
                print("DEBUG Document successfully updated!")
            }
        }
    }
    
    
    //MARK: - fetching data
    
    func fetchUser() {
        guard let uid = self.userSession?.uid else { return }
        userService.fetchUser(withUid: uid) { user in
            self.currentLandlord = user
        }
    }
    
    func fetchProperties() {
        guard let uid = self.userSession?.uid else { return }
        propertyService.fetchProperties(fromUserWithUid: uid) { properties in
            self.userProperties = properties
        }
    }
    
    func fetchTransactions(_ completion: @escaping(([Transaction]) -> Void)) {
        guard let uid = self.userSession?.uid else { return }
        userService.fetchTransactions(fromUserWithUid: uid) { transactions in
            completion(transactions)
        }
    }
}
