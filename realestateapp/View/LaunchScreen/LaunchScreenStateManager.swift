//
//  LaunchScreenStateManager.swift
//  RealEstate
//
//  Created by Aldo Navarrete on 11/04/23.
//

import Foundation


enum LaunchScreenStep {
    case firstStep
    case secondStep
    case finished
}

final class LaunchScreenStateManager: ObservableObject {
    
    @MainActor
    @Published private(set) var state: LaunchScreenStep = .firstStep
    
    @MainActor
    func dismiss() {
        self.state = .secondStep
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.state = .finished
        }
    }
}
