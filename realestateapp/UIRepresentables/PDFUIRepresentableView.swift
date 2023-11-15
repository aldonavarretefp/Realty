//
//  PDFUIRepresentableView.swift
//  RealEstate
//
//  Created by Aldo Yael Navarrete Zamora on 15/11/23.
//

import SwiftUI
import WebKit

struct PDFView: UIViewRepresentable {
    
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
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        if let req = self.request {
            let request = URLRequest(url: req.url!, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: .leastNormalMagnitude)
            webView.load(request)
        } else  if let data = self.data, context.coordinator.lastLoadedData != data {
            webView.load(data, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: .init(fileURLWithPath: ""))
            context.coordinator.lastLoadedData = data
        } else {
            // If neither data nor request exists, you might want to handle this case too.
        }
        
       
    }
    func makeUIView(context: Context) -> WKWebView {
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
        var lastLoadedData: Data?
        init(_ parent: PDFView) {
            self.parent = parent
        }
    }
}
