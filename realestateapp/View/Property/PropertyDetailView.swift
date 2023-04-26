//
//  PropertyDetailView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 21/12/22.
//

import SwiftUI

struct PropertyDetailView: View {
    
    @State private var iOS16colorScheme: ColorScheme = .dark
    
    @State var property: Property
    
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
                .padding(.top, 20)
            propertyTenantsView
        }
        .edgesIgnoringSafeArea(.top)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("Editar", destination: EditPropertyView(property: $property))
            }
        }
        .navigationBarTitleDisplayMode(.inline)
//        .toolbarBackground(.visible, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
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
                    
            }.frame(
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
            .overlay {
                Rectangle()
                    .fill(LinearGradient(
                            gradient: Gradient(stops: [
                                .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.99)), location: 0),
                                .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.8449141142)), location: 0.02083333395421505),
                                .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.7708247103)), location:  0.0572916679084301),
                                .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.5)), location: 0.2604166567325592),
                                .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.1820157285)), location: 1)
                            ]),
                            startPoint: UnitPoint(x: 0, y: 0),
                            endPoint: UnitPoint(x: 0, y: 1)
                        )
                    )
            }
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
}

extension PropertyDetailView {
   
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
    }
}
struct Previews_PropertyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PropertyDetailView(property: Property(title: "Nueva", address: "Propiedad"))
    }
}
