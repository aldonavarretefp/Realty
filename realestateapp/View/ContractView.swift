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

struct PDFView: UIViewRepresentable {
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    let request: URLRequest?
    let data: Data?
    
    init(request: URLRequest) {
        self.request = request
        self.data = nil
    }
    
    init(data: Data) {
        self.data = data
        self.request = nil
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let req = self.request {
            let request = URLRequest(url: req.url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: .leastNormalMagnitude)
            webView.load(request)
        } else if let data = self.data {
            webView.load(data, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: .init(fileURLWithPath: ""))
        } else {
            // If neither data nor request exists, you might want to handle this case too.
            print("No pdf to display.")
        }
    }
    func makeUIView(context: Context) -> WKWebView {
        print("makeUIView")
        let webView = WKWebView()
        if let req = self.request {
            let request = URLRequest(url: req.url!, cachePolicy: .returnCacheDataElseLoad)
            webView.load(request)
        } else if let data = self.data {
            webView.load(data, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: .init(fileURLWithPath: ""))
        }
        return webView
    }
    
    class Coordinator: NSObject, WKUIDelegate, WKNavigationDelegate {
        let parent: PDFView
        init(_ parent: PDFView) {
            print("initializer")
            self.parent = parent
        }
    }
}



struct Previews_ContractView_Previews: PreviewProvider {
    @Environment(\.colorScheme) var colorScheme
    static var previews: some View {
        let contractURL = Bundle.main.url(forResource: "pr-sample-contract", withExtension: "pdf")!
        Group {
            ContractView(tenant: .init(name: "José", contractUrl: contractURL.absoluteString))
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark mode")
            ContractView(tenant: .init(name: "José", contractUrl: contractURL.absoluteString))
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")
        }
        .previewLayout(.sizeThatFits)
    }
}
