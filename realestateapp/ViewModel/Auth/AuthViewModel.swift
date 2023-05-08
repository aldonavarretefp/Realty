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
import FirebaseStorage

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
        tempUserSession = nil
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
            self.currentLandlord?.lastName = lastName
        }
       
        let name = fullNameArr[0] as String
        
        docRef
            .updateData(["name": name])
        
        self.currentLandlord?.name = name
        
    }
    
    func updateProperty(property: Property) -> Void {
        guard let propertyUid: String = property.id else { return }
        
        let docRef = Firestore.firestore().collection("properties").document(propertyUid)
        
        docRef.updateData([
            "address": property.address,
            "area": property.area,
            "noRooms": property.noRooms,
            "name": property.title,
            "tenant": [
                "name": property.tenant?.name
            ]
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
    
    func deleteUser() async -> Void {
        guard let uid = userSession?.uid else { return }
        // Delete properties documents and storage
        let propertiesIds = userProperties?.compactMap({ $0.id })
        let db = Firestore.firestore()
        propertiesIds?.forEach({ propertyId in
            db.collection("properties").document(propertyId).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
            let storageRef = Storage.storage().reference().child(propertyId)
            storageRef.delete { error in
                if let error {
                    print("DEBUG error while deleting folder: \(error.localizedDescription)")
                }
            }
        })
        // Delete user
        do {
            try await db.collection("users").document(uid).delete()
        } catch {
            print("DEBUG error while removing user \(error.localizedDescription)")
        }
        
        
        
    }
    
    //MARK: - upload To Firebase
    
    func uploadProfileImage(_ image: UIImage) {
        guard let uid = userSession?.uid else { return }
        ImageUploader.uploadImage(image: image, withId: uid) { profileImageUrl in
            Firestore.firestore().collection("users")
                .document(uid)
                .updateData(["profileImageUrl": profileImageUrl])
            self.currentLandlord?.profileImageUrl = profileImageUrl
        }
    }
    
    func uploadContract(_ url: URL?, tenant: Tenant) {
        guard let tenantId = tenant.id else {
            print("DEBUG tenantId does not exists.")
            return
        }
        DocumentUploader.uploadDocument(withDocUrl: url, forTenant: tenant) { url in
            let docRef = Firestore.firestore().collection("properties").document(tenantId)
            docRef.updateData([
                "tenant": [
                    "name": tenant.name,
                    "contractUrl": url
                ]
            ]) { err in
                if let err = err {
                    print("DEBUG Error writing document: \(err)")
                    return
                }
                print("DEBUG Contract successfully updated!")
            
            }
        }
    }
    
    func uploadProperty(property: Property) async -> Void {
        guard let uid = userSession?.uid else { return }
        let docRef = Firestore.firestore().collection("properties")
        docRef.addDocument(data: [
                "name": property.title,
                "noRooms": property.noRooms ,
                "address": property.address,
                "area": property.area ,
                "landlord": uid,
                "tenant": [
                    "name": property.tenant?.name
                ]
            ]) { err in
                if let err = err {
                    print("DEBUG Error writing document: \(err)")
                } else {
                    print("DEBUG Property successfully uploaded!")
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
                return
            } 
            print("DEBUG transaction successfully updated!")
        }
    }
    
    //MARK: - fetching data
    
    func fetchUser() {
        guard let uid = self.userSession?.uid else { return }
        userService.fetchUser(withUid: uid) { result in
            switch result {
            case .success(let user):
                self.currentLandlord = user
            case .failure(let error):
                self.userSession = nil
                print("DEBUG Error: \(error.localizedDescription)")
            }
            
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
