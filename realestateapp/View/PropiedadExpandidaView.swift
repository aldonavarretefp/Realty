//
//  PropiedadExpandidaView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 21/12/22.
//

import SwiftUI

struct PropiedadExpandidaView: View {
    
    @Binding var isPopUpProperty: Bool
    var imgName: String
    var propertyTitle: String
    var propertyAddr: String
    @Namespace var namespace: Namespace.ID
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    ZStack(alignment: .leading) {
                        Image(imgName)
                            .resizable()
                            .scaledToFill()
                            .overlay {
                                ZStack(alignment: .topTrailing) {
                                    Rectangle()
                                        .fill(LinearGradient(
                                            gradient: Gradient(stops: [
                                                .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)), location: 0),
                                                .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.10303441435098648)), location: 0.02083333395421505),
                                                .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.2957063298)), location: 0.0572916679084301),
                                                .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.3471898673)), location: 0.2604166567325592),
                                                .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.02827048537)), location: 0.9947916865348816)]),
                                            startPoint: UnitPoint(x: 0, y: -2.0616171314629196e-17),
                                        endPoint: UnitPoint(x: 0, y: 0.9999999999999999)))
                                    Image(systemName: "x.circle.fill")
                                        .resizable()
                                        .frame(width: 35, height: 35)
                                        .foregroundColor(.white)
                                        .opacity(0.95)
                                        .padding(.trailing, 20)
                                        .padding(.top, 50)
                                        .onTapGesture {
                                            withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                                                isPopUpProperty.toggle()
                                            }
                                        }
                                }
                                
                                
                                
                            }
                            .matchedGeometryEffect(id: "img", in: namespace)
                        VStack(alignment: .leading) {
                            Spacer()
                            Text(propertyTitle)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .padding(.bottom, 10)
                                .matchedGeometryEffect(id: "title", in: namespace)
                            Text(propertyAddr.localizedCapitalized)
                                .font(.callout)
                                .foregroundColor(.white)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                                .matchedGeometryEffect(id: "address", in: namespace)
                        }
                        .padding(.bottom, 24)
                        .padding(.leading,20)
                        
                    }
                    Text("Tus arrendatarios")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.vertical, 24)
                        .padding(.horizontal, 16)
                    HStack {
                        Spacer()
                        TransactionView()
                        Spacer()
                    }
                    
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
        
        
    }
}

struct Previews_PropiedadExpandidaView_Previews: PreviewProvider {
    @State static var value = true
    static var previews: some View {
        PropiedadExpandidaView(isPopUpProperty: $value, imgName: "casa1", propertyTitle: "DeptosSantaMaria", propertyAddr: "GNEARO NUNEZ 18 0")
    }
}
