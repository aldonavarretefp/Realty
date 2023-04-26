//
//  FetcherService.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 06/03/23.
//

import Firebase

struct UserService {
    func fetchUser(withUid uid: String, completion: @escaping((LandLordUser) -> (Void))) {
        let docRef = Firestore.firestore().collection("users").document(uid)
        docRef.getDocument { (snapshot, error) in
            if let document = snapshot, document.exists {
                guard let user = try? snapshot?.data(as: LandLordUser.self) else {
                    print("DEBUG could not decode user.")
                    return
                }
                print("DEBUG user is: ", user)
                completion(user)
            } else {
                print("Document does not exist")
            }
        }
    }
    
    func fetchTransactions(fromUserWithUid uid: String, completion: @escaping(([Transaction]) -> Void)) {
        let collectionRef = Firestore.firestore().collection("users").document(uid).collection("transactions")
        var transactions: [Transaction] = []
        
        collectionRef.addSnapshotListener({ snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("DEBUG errror listening to the database")
                return
            }
            snapshot.documentChanges.forEach { documentChange in
                if documentChange.type == .added {
                    do {
                        let transaction = try documentChange.document.data(as: Transaction.self)
                        transactions.append(transaction)
                    } catch {
                        print(error.localizedDescription)
                        print(documentChange.document.data().description)
                    }
                   
                }
            }
            completion(transactions)
            
        })
    }
}


struct PropertyService {
    
    func fetchProperties(fromUserWithUid uid: String, completion: @escaping(([Property]) -> Void)){

        let collectionRef = Firestore.firestore().collection("properties").whereField("landlord", isEqualTo: uid)
    
        var properties: [Property] = []
        
        collectionRef.addSnapshotListener({ snapshot, error in
            guard let snapshot = snapshot, error == nil else {
                print("DEBUG errror listening to the database")
                return
            }
            
            snapshot.documentChanges.forEach { documentChange in
                if documentChange.type == .added {
                    guard let property = try? documentChange.document.data(as: Property.self) else { return }
                    properties.append(property)
                }
            }
            completion(properties)
        })
    
        
    }
}
