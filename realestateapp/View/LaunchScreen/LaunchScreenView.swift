//
//  LaunchScreenView.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 11/04/23.
//

import SwiftUI

struct LaunchScreenView: View {
    
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager
    
    @State private var isAnimating: Bool = false
    @State private var secondIsAnimating: Bool = false
    
    private let timer = Timer.publish(every: 0.65, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            background
            logo
        }
        .onReceive(timer) { input in
            switch launchScreenState.state {
            case .firstStep:
                withAnimation(.spring()) {
                    isAnimating.toggle()
                }
            case .secondStep:
                withAnimation(.easeInOut(duration: 1.0)) {
                    secondIsAnimating.toggle()
                }
            case .finished:
                isAnimating = false
            }
        }
        .onAppear {
            launchScreenState.dismiss()
        }
        
    }
}

private extension LaunchScreenView {
    
    var background: some View {
        Color("launch-screen-bg")
            .edgesIgnoringSafeArea(.all)
    }
    
    var logo: some View {
        Image("launch-screen-logo")
            .resizable()
            .frame(width: 120, height: 120)
            .scaleEffect(isAnimating ? 0.75 : 1.2)
//            .scaleEffect(secondIsAnimating ? UIScreen.main.bounds.size.height / 4 : 1)
            .opacity(secondIsAnimating ? 0 : 1)
            .foregroundColor(.white)
    }
}

struct LaunchScreenView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
            .environmentObject(LaunchScreenStateManager())
        
    }
}
