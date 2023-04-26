//
//  ContractView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 23/12/22.
//

import SwiftUI
import WebKit


struct ContractView: View {
    
    private var tenantName: String
    
    private var url: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "pr-sample-contract", ofType: "pdf")!)
    var guestName: String? = "Alejandro"
    
    var body: some View {
        NavigationView {
            PDFView(request: openPDF(name: "pr-sample-contract"))
                .navigationTitle("Contrato de \(tenantName)")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        ShareLink("Compartir", item: url, subject: Text("Contrato"), message: Text("Contrato"))
                            .foregroundColor(.blue)
                    }
                }
        }
    }
    
    init(withTenantName name:String) {
        self.tenantName = name
    }
    
    func openPDF(name: String) -> URLRequest {
        let path = Bundle.main.path(forResource: name, ofType: "pdf")
        let url = URL(fileURLWithPath: path!)
        return URLRequest(url: url)
    }

}

struct PDFView: UIViewRepresentable {
    
    let request: URLRequest
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.load(request)
    }
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
}

struct Previews_ContractView_Previews: PreviewProvider {
    static var previews: some View {
        ContractView(withTenantName: "Aldo")
    }
}
