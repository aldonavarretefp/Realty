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
        Task {
            self.state = .secondStep
            try? await Task.sleep(for: Duration.seconds(1))
            self.state = .finished
        }
    }
}
