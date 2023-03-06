//
//  CuadroPropiedadView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 20/12/22.
//

import SwiftUI

struct CuadroPropiedadView: View {
    @Binding var isPopUpProperty: Bool
    var imgName:String
    var propertyTitle: String
    var propertyAddr: String
    @Namespace var namespace: Namespace.ID
    
    var body: some View {
        ZStack(alignment: .leading) {
            ZStack(alignment: .leading) {
                Image(imgName)
                    .resizable()
                    .matchedGeometryEffect(id: "img", in: namespace)
                    .scaledToFill()
                    .overlay {
                        Rectangle()
                            .fill(LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)), location: 0),
                                    .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)), location: 0.8489583134651184)]),
                                startPoint: UnitPoint(x: 0.5, y: -3.0616171314629196e-17),
                                endPoint: UnitPoint(x: 0.5, y: 0.9999999999999999)))
                    }
                VStack(alignment: .leading) {
                    Spacer()
                    Text(propertyTitle)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .matchedGeometryEffect(id: "title", in: namespace)
                    Text(propertyAddr.localizedCapitalized)
                        .font(.callout)
                        .foregroundColor(.white)
                        .lineLimit(2)
                        .minimumScaleFactor(0.5)
                        .matchedGeometryEffect(id: "address", in: namespace)
                }
                .padding(.bottom, 20)
                .padding(.horizontal, 60)
                .frame(
                    minWidth: 0,
                    maxWidth: .infinity,
                    minHeight: 0,
                    maxHeight: .infinity,
                    alignment: .topLeading
                )
            }
            .frame(width: 370, height: 311)
            .cornerRadius(14)
            .shadow(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25)), radius:4, x:0, y:4)
            .padding(.bottom)
            .onTapGesture {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.8)) {
                    isPopUpProperty.toggle()
                }
            }
        }
    }
}

