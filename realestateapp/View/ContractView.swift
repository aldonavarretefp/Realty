//
//  ContractView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 23/12/22.
//

import SwiftUI
import WebKit


struct ContractView: View {
    
    private var url: URL = URL(fileURLWithPath: Bundle.main.path(forResource: "pr-sample-contract", ofType: "pdf")!)
    var guestName: String? = "Alejandro"
    
    
    
    var body: some View {
        VStack{
            HStack(){
                Spacer()
                VStack {
                    ShareLink("Compartir", item: url, subject: Text("Contrato"), message: Text("Contrato"))
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical,20)
            PDFView(request: openPDF(name: "pr-sample-contract"))
        }
        .frame(maxWidth: 400)
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
        ContractView()
    }
}
extension UIApplication {
    
    var keyWindow: UIWindow? {
        // Get connected scenes
        return UIApplication.shared.connectedScenes
            // Keep only active scenes, onscreen and visible to the user
            .filter { $0.activationState == .foregroundActive }
            // Keep only the first `UIWindowScene`
            .first(where: { $0 is UIWindowScene })
            // Get its associated windows
            .flatMap({ $0 as? UIWindowScene })?.windows
            // Finally, keep only the key window
            .first(where: \.isKeyWindow)
    }
    
}
extension UIApplication {

    var keyWindowPresentedController: UIViewController? {
        var viewController = self.keyWindow?.rootViewController

        // If root `UIViewController` is a `UITabBarController`
        if let presentedController = viewController as? UITabBarController {
            // Move to selected `UIViewController`
            viewController = presentedController.selectedViewController
        }

        // Go deeper to find the last presented `UIViewController`
        while let presentedController = viewController?.presentedViewController {
            // If root `UIViewController` is a `UITabBarController`
            if let presentedController = presentedController as? UITabBarController {
                // Move to selected `UIViewController`
                viewController = presentedController.selectedViewController
            } else {
                // Otherwise, go deeper
                viewController = presentedController
            }
        }

        return viewController
    }

}

extension UIViewController {
    
    func presentInKeyWindow(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?
                .present(self, animated: animated, completion: completion)
        }
    }
    
    func presentInKeyWindowPresentedController(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            UIApplication.shared.keyWindowPresentedController?
                .present(self, animated: animated, completion: completion)
        }
    }
    
}
