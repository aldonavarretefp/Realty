//
//  PropertyDetailView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 21/12/22.
//

import SwiftUI

struct PropertyDetailView: View {
    
    @State var property: Property
    @EnvironmentObject var router: Router
    
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
    func calculateHeight(_ geometry: GeometryProxy) -> CGFloat {
        let offset = geometry.frame(in: .global).minY
        return offset > 0 ? 300 + offset : 300
    }
    var body: some View {
        ScrollView {
            propertyImgView
            VStack {
                propertyImageWithInfoView
                propertyInfoGridView
                TenantCard()
            }
            .padding()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    router.navigateBack()
                }, label: {
                    Image(systemName: "arrow.left")
                })
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                NavigationLink("Editar", destination: EditPropertyView(property: $property))
                    .isDetailLink(false)
            }
        }
        .toolbar(.hidden)
        .frame(minHeight: 0, maxHeight: .infinity,alignment: .top)
        .ignoresSafeArea()
        
        
    }
    
    @ViewBuilder
    private func TenantCard() -> some View {
        VStack(alignment: .leading) {
            Text("Tenants")
                .font(.system(.largeTitle, design: .serif))
                .font(.largeTitle)
                .fontWeight(.bold)
            
            VStack(alignment: .leading) {
                HStack {
                    Image("avatar 1")
                        .resizable()
                        .frame(width: 120, height: 120)
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    VStack(alignment: .leading) {
                        Text(tenant.name)
                            .fontWeight(.bold)
                        
                        ProgressView(value: 0.8)
                            .frame(width: 190)
                            .progressViewStyle(.linear)
                        Text("Leasing since: May 2023")
                        Text("Lease Duration: 1 year")
                        Button("Renew") {
                            // Handle contract renewal
                        }
                        .buttonStyle(.bordered)
                        .background(.green.opacity(0.1))
                        .foregroundStyle(.green)
                    }
                }
            }
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 140, alignment: .leading)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(.white.shadow(.drop(radius: 2)))
            )
        }
        .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
    }
    
}

extension PropertyDetailView {
    var propertyImageWithInfoView: some View {
        VStack(alignment: .leading) {
            Text(property.title.localizedCapitalized)
                .font(.largeTitle)
                .bold()
                .lineLimit(2)
            Text(property.address.localizedCapitalized)
                .font(.callout)
                .lineLimit(2)
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity,
            alignment: .bottomLeading
        )
    }
    
    var propertyImgView: some View {
        GeometryReader { geometry in
                TabView {
                    ForEach(1...3, id: \.self) { _ in
                        Image(property.imgName ?? "casa 1")
                            .resizable()
                            .scaledToFill()
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
                }
                .tabViewStyle(PageTabViewStyle())
                .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
                .frame(width: geometry.size.width, height: max(300, 300 + geometry.frame(in: .global).minY))
                .offset(y: geometry.frame(in: .global).minY > 0 ? -geometry.frame(in: .global).minY : 0)
                
        }
        .frame(height: 300) // Initial height of the image
        
    }
    
    var propertyInfoGridView: some View {
        LazyVGrid(columns: adaptiveCol, spacing: 20) {
            VStack {
                Text("Número de habitaciones")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.bottom, 1)
                Text("\(noRooms)")
                    .font(.headline)
                    .foregroundColor(Color(.systemBlue))
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
            }
            VStack {
                Text("Área")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.bottom, 1)
                Text("\(String(format: "%.1f", area)) m\u{b2}")
                    .font(.headline)
                    .foregroundColor(Color(.systemBlue))
                    .lineLimit(1)
                    .minimumScaleFactor(0.4)
            }
            VStack {
                Text("Dirección")
                    .font(.caption)
                    .fontWeight(.bold)
                    .padding(.bottom, 1)
                Text(property.address)
                    .font(.headline)
                    .foregroundColor(Color(.systemBlue))
                    .lineLimit(2)
                    .minimumScaleFactor(0.4)
            }
            VStack {
                Text("Inquilino")
                    .font(.caption)
                    .fontWeight(.bold)
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
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white.shadow(.drop(radius: 2)))
        )
    }
}
struct Previews_PropertyDetailView_Previews: PreviewProvider {
    static var previews: some View {
        PropertyDetailView(property: Property(title: "Nueva", address: "Propiedad"))
    }
}
