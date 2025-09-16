//
//  MainTabView.swift
//  Schul-Coach AI
//
//  Created by Ben Picha on 15.09.25.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0
    @State private var userProfile: UserProfile?
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(userProfile: userProfile)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Start")
                }
                .tag(0)
            
            SubjectsView(userProfile: userProfile)
                .tabItem {
                    Image(systemName: "books.vertical.fill")
                    Text("Fächer")
                }
                .tag(1)
            
            AITutorView(userProfile: userProfile)
                .tabItem {
                    Image(systemName: "brain.head.profile")
                    Text("KI-Tutor")
                }
                .tag(2)
            
            if userProfile?.klassenstufe ?? 5 <= 4 {
                GamesView(userProfile: userProfile)
                    .tabItem {
                        Image(systemName: "gamecontroller.fill")
                        Text("Spiele")
                    }
                    .tag(3)
            }
            
            LearningProgressView(userProfile: userProfile)
                .tabItem {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                    Text("Fortschritt")
                }
                .tag(4)
            
            ProfileView(userProfile: $userProfile)
                .tabItem {
                    Image(systemName: "person.circle.fill")
                    Text("Profil")
                }
                .tag(5)
        }
        .accentColor(.blue)
        .onAppear {
            loadUserProfile()
        }
    }
    
    private func loadUserProfile() {
        if let data = UserDefaults.standard.data(forKey: "userProfile"),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            userProfile = profile
        }
    }
}

#Preview {
    MainTabView()
}