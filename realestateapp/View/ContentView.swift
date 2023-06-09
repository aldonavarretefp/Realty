//
//  ContentView.swift
//  realestateapp
//
//  Created by Aldo Navarrete on 20/12/22.
//

import SwiftUI

struct ContentView: View {
    
    @EnvironmentObject var authModel: AuthViewModel
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager

    var body: some View {
        Group {
            if authModel.userSession != nil {
                TabView{
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
                .accentColor(Color.pink)
            } else {
                LoginView()
            }
        }
    }

}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
            .environmentObject(LaunchScreenStateManager())
    }
}
