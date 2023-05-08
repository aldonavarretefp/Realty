//
//  ContractView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 23/12/22.
//

import SwiftUI
import WebKit


struct ContractView: View {
    
    let tenant: Tenant
    
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

struct PDFView: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    let request: URLRequest
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: self.request.url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: .leastNormalMagnitude)
        
        webView.load(request)
    }
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView()
        let request = URLRequest(url: self.request.url!, cachePolicy: .returnCacheDataElseLoad)
        webview.load(request)
        return webview
    }
    
    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        
        let parent: PDFView
        
        init(_ parent: PDFView) {
            self.parent = parent
        }
        
        
    }
}



struct Previews_ContractView_Previews: PreviewProvider {
    static var previews: some View {
        ContractView(tenant: .init(name: "José"))
    }
}
