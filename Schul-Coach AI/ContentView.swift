//
//  ContentView.swift
//  Schul-Coach AI
//
//  Created by Ben Picha on 15.09.25.
//

import SwiftUI

struct ContentView: View {
    @State private var hasCompletedOnboarding = false
    
    var body: some View {
        Group {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
        .onAppear {
            hasCompletedOnboarding = UserDefaults.standard.bool(forKey: "hasCompletedOnboarding")
        }
    }
}

#Preview {
    ContentView()
}
