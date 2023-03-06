//
//  realestateappApp.swift
//  realestateapp
//
//  Created by Aldo Navarrete on 20/12/22.
//

import SwiftUI
import FirebaseCore

@main
struct realestateappApp: App {
    
    @StateObject var authModel: AuthViewModel = AuthViewModel()
    
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .environmentObject(authModel)
            .accentColor(.red)
        }
    }
}
