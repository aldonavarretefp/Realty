//
//  HomeView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 20/12/22.
//
import SwiftUI

struct HomeView: View {
    @Binding var isPopUpProperty: Bool
//    @Binding var properties:[CuadroPropiedadView] = [
//        CuadroPropiedadView(isPopUpProperty: isPopUpProperty, imgName: "casa1", propertyTitle: "Paseo Interlomas", propertyAddr: "ZARAGOZA Y REP DE MEXICO 411 PTE, CIUDAD OBREGON CENTRO, 85000"),
//        CuadroPropiedadView(imgName: "casa3", propertyTitle: "La choza", propertyAddr: "PLAZA PERDIS NO. 12, 1A SECC LOMAS VERDES, 53120"),
//        CuadroPropiedadView(imgName: "casa2", propertyTitle: "Nueva casa", propertyAddr: "HIDALGO NO. 105 Int. NO. 1, CENTRO, 59300"),
//        CuadroPropiedadView(imgName: "casa1", propertyTitle: "Deptos Santa María", propertyAddr: "CARR SAN LUIS RIO COLORADO NO. KM 7, GONZALEZ ORTEGA, 21397"),
//        CuadroPropiedadView(imgName: "casa2", propertyTitle: "Deptos Santa María", propertyAddr: "AGUSTIN YAÑEZ 2889, ARCOS VALLARTA SUR, 44500"),
//        CuadroPropiedadView(imgName: "casa1", propertyTitle: "Deptos Santa María", propertyAddr: "FELIPE CARRILLO PUERTO NO. 402 NO. B, PENSIL SUR, 11490")
//    ]
    @Namespace var namespace: Namespace.ID
    
    var body: some View {
        ZStack(alignment:.leading) {
            NavigationView {
                ScrollView(showsIndicators: false) {
                    VStack {
                        CuadroPropiedadView(isPopUpProperty: $isPopUpProperty, imgName: "casa2", propertyTitle: "Deptos Santa María", propertyAddr: "7A NORTE NO. 197, TUXTLA GUTIERREZ CENTRO, 29000", namespace: _namespace)
                    }
                }
                .navigationTitle("Tus propiedades")
            }
        }
        
    }
}

struct Previews_HomeView_Previews: PreviewProvider {
    @State static var value = false
    static var previews: some View {
        HomeView(isPopUpProperty: $value)
    }
}
