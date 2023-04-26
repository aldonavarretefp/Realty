//
//  HomeView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 20/12/22.
//
import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject private var authModel: AuthViewModel
    
    @State private var isShowingNewPropertySheet: Bool = false
    
    @State private var isHomeActive: Bool = false
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                if let properties = authModel.userProperties {
                    
                    if properties.isEmpty {
                        VStack(alignment: .center) {
                            HStack(alignment: .center) {
                                Text("Oh, it seems that you do not have any property yet, tap on the \(Image(systemName: "plus")) button to create one!")
                            }
                        }
                        .frame(
                            minHeight: 0,
                            maxHeight: .infinity
                        )
                    } else {
                        ForEach(properties) { prop in
                            NavigationLink(destination: PropertyDetailView(property: prop)) {
                                PropertyView(imgName: prop.imgName ?? "casa2", propertyTitle: prop.title, propertyAddr: prop.address)
                            }
                            .padding(.bottom, 10)
                        }
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
            }
            .navigationTitle("Tus propiedades")
            .toolbar{
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            isShowingNewPropertySheet.toggle()
                        }, label: {
                            Label("Propiedad", systemImage: "house.lodge")
                        })
                        .foregroundColor(Color(.systemBlue))
                    } label: {
                        Image(systemName: "plus")
                            .rotationEffect(.init(degrees: 90))
                            .scaleEffect(0.8)
                            .tint(.accentColor)
                    }
                }
            }
            .sheet(isPresented: $isShowingNewPropertySheet) {
                NewPropertyView()
            }
            .onAppear(perform: loadProperties)
        }
        .navigationViewStyle(StackNavigationViewStyle())

        
    }
    
    func loadProperties() -> Void {
        authModel.fetchProperties()
    }
    
}
