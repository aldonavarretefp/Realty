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
        NavigationStack {
            ScrollView {
                if let properties = authModel.userProperties {
                    ForEach(properties) { prop in
                        NavigationLink(destination: PropertyDetailView(property: prop)) {
                            PropertyView(imgName: prop.imgName ?? "casa2", propertyTitle: prop.title, propertyAddr: prop.address)
                        }
                        .padding(.bottom, 10)
                    }
                }
            }
            .navigationTitle("Tus propiedades")
            .toolbar {
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
                    }
                }
            }
            .sheet(isPresented: $isShowingNewPropertySheet) {
                NewPropertyView()
            }
            .onAppear(perform: loadProperties)
            .refreshable {
                loadProperties()
            }
            .scrollIndicators(.hidden)
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity
            )
            .overlay {
                if let properties = authModel.userProperties {
                    if properties.isEmpty {
                        Text("Oh, parece que no tienes ninguna propiedad ¡toca el botón \(Image(systemName: "plus")) para crear una ahora!")
                            .padding()
                    }
                } else {
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        
    }
    
    func loadProperties() -> Void {
        authModel.fetchProperties()
    }
    
}

struct Previews_HomeView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            HomeView()
                .environmentObject(AuthViewModel())
                .preferredColorScheme(.dark)
                .previewDisplayName("Dark Mode")
            HomeView()
                .environmentObject(AuthViewModel())
                .preferredColorScheme(.light)
                .previewDisplayName("Light Mode")
        }
        
    }
}
