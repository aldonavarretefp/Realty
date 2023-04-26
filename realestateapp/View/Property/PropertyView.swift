//
//  PropertyView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 20/12/22.
//

import SwiftUI

struct PropertyView: View {
    var imgName:String
    var propertyTitle: String
    var propertyAddr: String
    
    private let shadowColor = Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.25))
    
    var body: some View {
        ZStack {
            image
            vstacktext
        }
        .frame(width: 340, height: 311)
        .cornerRadius(14)
        .shadow(color: shadowColor, radius:4, x:0, y:4)
        
    }
}

extension PropertyView {
    
    
    var image: some View {
        Image(imgName)
            .resizable()
            .frame(width: 340, height: 311)
            .scaledToFill()
            .overlay {
                Rectangle()
                    .fill(LinearGradient(
                        gradient: Gradient(stops: [
                            .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)), location: 0),
                            .init(color: Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6014590232)), location: 0.8489583134651184)]),
                        startPoint: UnitPoint(x: 0, y: -3.0616171314629196e-17),
                        endPoint: UnitPoint(x: 0, y: 0.9999999999999999)
                        )
                    )
                    
            }
    }
    
    var vstacktext: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(propertyTitle)
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .lineLimit(4)
                .multilineTextAlignment(.leading)
            Text(propertyAddr.localizedCapitalized)
                .font(.callout)
                .foregroundColor(.white)
                .lineLimit(5)
                .multilineTextAlignment(.leading)
        }
        .padding(15)
        .frame(
            maxWidth: .infinity,
            maxHeight: .infinity,
            alignment: .topLeading
        )
    }
}


struct Previews_PropertyView_Previews: PreviewProvider {
    static var previews: some View {
        PropertyView(imgName: "casa3", propertyTitle: "u", propertyAddr: "Irure amet id commodo duis amet anim adipisicing id consectetur.Irure amet id commodo duis amet anim adipisicing id consectetur.Irure amet id commodo duis amet anim adipisicing id consectetur.")
    }
}
