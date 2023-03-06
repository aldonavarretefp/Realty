//
//  ContentView.swift
//  realestateapp
//
//  Created by Aldo Navarrete on 20/12/22.
//

import SwiftUI

struct ContentView: View {
    @State var isPopUpProperty: Bool = false
    @Namespace var namespace
    @EnvironmentObject var authModel: AuthViewModel

    var body: some View {
        Group {
            if authModel.userSession != nil {
                TabView{
                    HomeView(isPopUpProperty: $isPopUpProperty, namespace: _namespace)
                        .tabItem{
                            VStack{
                                Image(systemName: "house")
                                Text("Home")
                            }
                        }
                    FinanzasView()
                        .tabItem{
                            Text("Finanzas")
                            Image(systemName: "chart.bar.fill")
                        }
                    AjustesView()
                        .tabItem {
                            Text("Ajustes")
                            Image(systemName: "gear")
                        }
                }
            }
            else {
                LoginView()
            }
        }
        .animation(.default, value: true)
    }
}

struct CustomPopupView<Content, PopupView>: View where Content: View, PopupView: View {
    
    @Binding var isPresented: Bool
    @ViewBuilder let content: () -> Content
    @ViewBuilder let popupView: () -> PopupView
    let backgroundColor:Color = Color("AccentColor 1")
    var body: some View {
        content()
            .overlay(isPresented ? backgroundColor.ignoresSafeArea() : nil)
            .overlay(isPresented ? popupView() : nil)
    }
}

extension View {
    func customPopupView<PopupView>(
        isPresented: Binding<Bool>,
        popupView: @escaping () -> PopupView) -> some View where PopupView: View {
            return CustomPopupView(isPresented: isPresented, content: { self }, popupView: popupView )
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
