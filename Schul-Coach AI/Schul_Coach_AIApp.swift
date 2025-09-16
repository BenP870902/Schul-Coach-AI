//
//  Schul_Coach_AIApp.swift
//  Schul-Coach AI
//
//  Created by Ben Picha on 15.09.25.
//

import SwiftUI

@main
struct Schul_Coach_AIApp: App {
    // App-weite Initialisierung
    init() {
        // Konfiguriere App-Einstellungen
        setupAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    // App-Start Setup
                    print("Schul-Coach AI gestartet")
                }
        }
    }
    
    // MARK: - Private Methods
    private func setupAppearance() {
        // Konfiguriere globale UI-Einstellungen
        
        // Tab Bar Appearance
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = UIColor.systemBackground
        
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        
        // Navigation Bar Appearance
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        navBarAppearance.backgroundColor = UIColor.systemBackground
        navBarAppearance.titleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 18, weight: .semibold)
        ]
        navBarAppearance.largeTitleTextAttributes = [
            .foregroundColor: UIColor.label,
            .font: UIFont.systemFont(ofSize: 32, weight: .bold)
        ]
        
        UINavigationBar.appearance().standardAppearance = navBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
        UINavigationBar.appearance().compactAppearance = navBarAppearance
        
        // Tint Color für die gesamte App
        UIView.appearance().tintColor = UIColor.systemBlue
    }
}