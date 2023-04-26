//
//  ImageUploader.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 06/03/23.
//

import FirebaseStorage
import UIKit

struct ImageUploader {
    
    static func uploadImage(image: UIImage, completion: @escaping(String) -> () ) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        
        let filename = NSUUID().uuidString
        let ref = Storage.storage().reference(withPath: "/profile_image/\(filename)")
        
        ref.putData(imageData, metadata: nil) {_, error in
            if let e = error {
                print("DEBUG Failed to upload image with error: \(e.localizedDescription)")
                return
            }
            
            ref.downloadURL { imageURL, _ in
                guard let imageURL = imageURL?.absoluteString else { return }
                completion(imageURL)
            }
        }
    }
}
