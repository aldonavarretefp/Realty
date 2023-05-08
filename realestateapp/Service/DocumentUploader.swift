//
//  DocumentUploader.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 03/05/23.
//

import Foundation
import FirebaseStorage

struct DocumentUploader {
    
    static func uploadDocument(withDocUrl docUrl: URL?, forTenant tenant: Tenant, completion: @escaping((String) -> Void)) {
        
        guard let docUrl = docUrl, let tenantId = tenant.id else {
            print("DEBUG upload error")
            return
        }
        let storageRef = Storage.storage().reference()
        let formattedFileNameString = tenant.name.replacingOccurrences(of: " ", with: "")
        let tenantContractRef = storageRef.child("\(tenantId)/contrato_\(formattedFileNameString).pdf")
        tenantContractRef.getMetadata() { metadata, error in
            guard let storageError = error else { return }
            guard let errorCode = StorageErrorCode(rawValue: storageError._code) else { return }
            switch errorCode {
            case .objectNotFound:
                tenantContractRef.putFile(from: docUrl, metadata: nil) { (metadata, err) in
                    //TODO: Handle file size
                    if let err {
                        print("DEBUG Error while puting file document: \(err.localizedDescription)")
                        return
                    }
                    print("DEBUG Document successfully put!")
                    
                    tenantContractRef.downloadURL { (url, error) in
                        if let error {
                            print("DEBUG Error while fetching url document: \(error.localizedDescription)")
                            return
                        }
                        print("DEBUG downloadURL succesful!")
                        
                        guard let downloadURL = url?.absoluteString else {
                            print("DEBUG Couldn't get downloadURL")
                            return
                        }
                        completion(downloadURL)
                        
                    }
                }
                return
            case .unauthorized:
                // User doesn't have permission to access file
                print("Not enough permissions")
            case .cancelled:
                // User canceled the upload
                print("DEBUG User cancelled the upload")
            case .unknown:
                print("DEBUG User cancelled the upload")
            case .bucketNotFound:
                print("Error")
            case .projectNotFound:
                print("Error")
            case .quotaExceeded:
                print("Error")
            case .unauthenticated:
                print("Error")
            case .retryLimitExceeded:
                print("Error")
            case .nonMatchingChecksum:
                print("Error")
            case .downloadSizeExceeded:
                print("Error")
            case .invalidArgument:
                print("Error")
            @unknown default:
                print("Hello")
            }
            tenantContractRef.putFile(from: docUrl, metadata: nil) { (metadata, err) in
                //TODO: Handle file size
                if let err {
                    print("DEBUG Error while puting file document: \(err.localizedDescription)")
                    return
                }
                print("DEBUG Document successfully put!")

                tenantContractRef.downloadURL { (url, error) in
                    if let error {
                        print("DEBUG Error while fetching url document: \(error.localizedDescription)")
                        return
                    }
                    print("DEBUG downloadURL succesful!")

                    guard let downloadURL = url?.absoluteString else {
                        print("DEBUG Couldn't get downloadURL")
                        return
                    }
                    completion(downloadURL)
                }
            }
        }
//        tenantContractRef.downloadURL { url, err in
//            if let err = err {
//                //Does not exists so createit
//                print("DEBUG Error while retreiving file: \(err.localizedDescription)")
//                return
//            }
//            print("DEBUG Document successfully found!")
//
//            guard let urlString = url?.absoluteString else {
//                return
//            }
//            completion(urlString)
//        }
    }
    
}
