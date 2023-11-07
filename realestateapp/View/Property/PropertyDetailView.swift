//
//  PropertyDetailView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 21/12/22.
//

import SwiftUI

struct PropertyDetailView: View {
    
    @State var property: Property
    
    @Binding var isHomeActive: Bool
    
    var tenant: Tenant {
        guard let tenant = property.tenant else {
            return Tenant(name: "Desconocido")
        }
        return tenant
    }
    var noRooms:Int {
        return property.noRooms
    }
    var area: Double {
        return property.area
    }
    private let adaptiveCol = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]
    
    var body: some View {
        ScrollView {
            propertyImageWithInfoView
            propertyInfoGridView
            propertyTenantsView
            
        }
        .edgesIgnoringSafeArea(.top)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("Editar", destination: EditPropertyView(property: $property, isHomeActive: $isHomeActive))
                    .isDetailLink(false)
            }
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.light, for: .navigationBar)

              .preferredColorScheme(.dark)
        
    }
    
}

extension PropertyDetailView {
    
    var propertyImageWithInfoView: some View {
        ZStack {
            propertyImgView
            
            VStack(alignment: .leading) {
                Text(property.title.localizedCapitalized)
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.white)
                    .lineLimit(2)
                Text(property.address.localizedCapitalized)
                    .font(.callout)
                    .foregroundColor(.white)
                    .lineLimit(2)
                
            }
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: .infinity,
                alignment: .bottomLeading
            )
            .padding()
            
        }
        
    }
    
    var propertyImgView: some View {
        Image(property.imgName ?? "casa 1")
            .resizable()
            .scaledToFill()
            .frame(
                minWidth: 0,
                maxWidth: .infinity,
                minHeight: 0,
                maxHeight: 300
            )
            .overlay(
                LinearGradient(gradient: Gradient(colors: [
                    .black.opacity(0.7),
                    .black.opacity(0.5),
                    .clear,
                    .black.opacity(0.6)
                ]),
                    startPoint: .top,
                    endPoint: .bottom)
            )
            .clipped()
    }
    
    var propertyTenantsView: some View {
        VStack {
            if let tenant = property.tenant {
                Text("Inquilino")
                    .frame(
                        minWidth: 0,
                        maxWidth: .infinity,
                        alignment: .leading
                    )
                    .padding(.leading, 20)
                    .padding(.top, 10)
                    .font(.largeTitle)
                    .bold()
                TenantRowView(tenant: tenant)
            }
        }
    }
    
    var propertyInfoGridView: some View {
        LazyVGrid(columns: adaptiveCol, spacing: 20) {
            VStack {
                Text("Número de habitaciones")
                    .font(.caption)
                    .padding(.bottom, 1)
                Text("\(noRooms)")
                    .font(.headline)
                    .foregroundColor(Color(.systemBlue))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
            }
            VStack {
                Text("Área [m\u{b2}]")
                    .font(.caption)
                    .padding(.bottom, 1)
                Text("\(String(format: "%.1f", area))")
                    .font(.headline)
                    .foregroundColor(Color(.systemBlue))
                    .fontWeight(.bold)
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
            }
            VStack {
                Text("Dirección")
                    .font(.caption)
                    .padding(.bottom, 1)
                    .foregroundColor(Color("primaryInvert"))
                Text(property.address)
                    .font(.headline)
                    .foregroundColor(Color(.systemBlue))
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .minimumScaleFactor(0.4)
            }
            VStack {
                Text("Inquilino")
                    .font(.caption)
                    .padding(.bottom, 1)
                Text(tenant.name)
                    .font(.headline)
                    .foregroundColor(Color(.systemBlue))
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .minimumScaleFactor(0.4)
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 100,
            maxHeight: 200
        )
        .padding(.top, 20)
    }
}
struct Previews_PropertyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PropertyDetailView(property: Property(title: "Nueva", address: "Propiedad"), isHomeActive: .constant(false))
    }
}
