//
//  realestateappApp.swift
//  realestateapp
//
//  Created by Aldo Navarrete on 20/12/22.
//

import SwiftUI
import FirebaseCore

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct realestate: App  {
    
    @StateObject var authModel: AuthViewModel = AuthViewModel()
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @StateObject var launchScreenState = LaunchScreenStateManager()
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                LaunchScreenView()
                NavigationView {
                    ContentView()
                }
                .environmentObject(authModel)
                .navigationViewStyle(StackNavigationViewStyle())
            }
            .environmentObject(launchScreenState)
        }
    }
}
