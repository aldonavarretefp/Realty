//
//  DocumentPicker.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 03/05/23.
//

import Foundation
import SwiftUI
import MobileCoreServices

struct DocumentPicker: UIViewControllerRepresentable {
    
    @EnvironmentObject var authModel: AuthViewModel
    
    let tenant: Tenant
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf])
        picker.delegate = context.coordinator
        picker.allowsMultipleSelection = false
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

extension DocumentPicker {
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        let parent: DocumentPicker
        
        init(_ parent: DocumentPicker) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.authModel.uploadContract(urls.first, tenant: parent.tenant)
        }
        
        
    }
}

