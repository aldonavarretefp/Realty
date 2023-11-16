//
//  ContentView.swift
//  realestateapp
//
//  Created by Aldo Navarrete on 20/12/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authModel: AuthViewModel

    var body: some View {
        Group {
            if authModel.userSession != nil {
                if let user = authModel.currentLandlord, user.userRole == .landlord {
                    TabView {
                        HomeView()
                            .tabItem{
                                Text("Home")
                                Image(systemName: "house")
                                    
                            }
                        FinanzasView()
                            .tabItem{
                                Text("Finanzas")
                                Image(systemName: "chart.bar")
                            }
                        SettingsView()
                            .tabItem {
                                Text("Ajustes")
                                Image(systemName: "gear")
                            }
                    }
                } else {
                    TenantHomeView()
                }
            } else {
                LoginView()
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .environmentObject(AuthViewModel())
                .preferredColorScheme(.dark)
            ContentView()
                .environmentObject(AuthViewModel())
                .preferredColorScheme(.light)
        }
        
    }
}
