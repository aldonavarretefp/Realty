//
//  ContractView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 23/12/22.
//

import SwiftUI

struct ContractView: View {
    
    let tenant: Tenant
    
    
    init(tenant: Tenant) {
        self.tenant = tenant
    }
    
    var body: some View {
        NavigationView {
            if let contractUrlString = tenant.contractUrl {
                let contractUrl: URL = URL(string: contractUrlString)!
                PDFView(request: openPDF(withUrl: contractUrlString) )
                    .navigationTitle("Contrato de \(tenant.name)")
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            ShareLink(item: contractUrl)
                                .foregroundColor(.blue)
                        }
                    }
            } else {
                Text("Oh, parece que \(tenant.name) no tiene un contrato aún, prueba subiendo uno.")
                    .padding()
            }
            
        }
    }
    
    func openPDF(withUrl url: String) -> URLRequest {
        let url = URL(string: url)
        return URLRequest(url: url!)
    }
    
}

struct Previews_ContractView_Previews: PreviewProvider {
    @Environment(\.colorScheme) var colorScheme
    static var previews: some View {
        let contractURL = Bundle.main.url(forResource: "pr-sample-contract", withExtension: "pdf")!
        Group {
            Text("Hello")
        }
        .previewLayout(.sizeThatFits)
    }
}
