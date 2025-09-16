//
//  HomeView.swift
//  Schul-Coach AI
//
//  Created by Ben Picha on 15.09.25.
//

import SwiftUI

struct HomeView: View {
    let userProfile: UserProfile?
    @State private var currentTime = Date()
    @State private var dailyStreak = 7
    @State private var todayPoints = 150
    @State private var showPremiumSheet = false
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header mit Begrüßung
                    headerSection
                    
                    // Quick Stats
                    statsSection
                    
                    // Heute empfohlen
                    recommendedSection
                    
                    // Lieblingsfächer
                    favoriteSubjectsSection
                    
                    // Hausaufgaben Reminder
                    homeworkSection
                    
                    // Premium Features
                    if !(userProfile?.isPremium ?? false) {
                        premiumSection
                    }
                }
                .padding(.horizontal)
            }
            .navigationTitle("Schul-Coach AI")
            .navigationBarTitleDisplayMode(.large)
            .onReceive(timer) { _ in
                currentTime = Date()
            }
        }
        .sheet(isPresented: $showPremiumSheet) {
            PremiumView()
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text(greetingText)
                        .font(.title2)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                    
                    Text(userProfile?.name ?? "Schüler")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                }
                
                Spacer()
                
                // Streak Badge
                VStack(spacing: 2) {
                    Image(systemName: "flame.fill")
                        .font(.title2)
                        .foregroundColor(.orange)
                    
                    Text("\(dailyStreak)")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Text("Tage")
                        .font(.caption2)
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.orange.opacity(0.1))
                )
            }
            
            if let profile = userProfile {
                Text("\(profile.schulform.rawValue) • \(profile.klassenstufe == 0 ? "Vorschule" : "\(profile.klassenstufe). Klasse") • \(profile.bundesland.rawValue)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(.systemGray6))
        )
    }
    
    private var statsSection: some View {
        HStack(spacing: 15) {
            StatCard(
                title: "Heute",
                value: "\(todayPoints)",
                subtitle: "Punkte",
                icon: "star.fill",
                color: .yellow
            )
            
            StatCard(
                title: "Diese Woche",
                value: "4/7",
                subtitle: "Tage aktiv",
                icon: "calendar.badge.checkmark",
                color: .green
            )
            
            StatCard(
                title: "Level",
                value: "12",
                subtitle: "Fortschritt",
                icon: "trophy.fill",
                color: .purple
            )
        }
    }
    
    private var recommendedSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Heute empfohlen")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Alle anzeigen") {
                    // Navigation zu allen Empfehlungen
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    RecommendationCard(
                        title: "Bruchrechnung",
                        subject: "Mathematik",
                        duration: "15 Min",
                        difficulty: "Mittel",
                        icon: "function",
                        color: .red
                    )
                    
                    RecommendationCard(
                        title: "Satzglieder",
                        subject: "Deutsch",
                        duration: "20 Min",
                        difficulty: "Leicht",
                        icon: "textformat.abc",
                        color: .blue
                    )
                    
                    RecommendationCard(
                        title: "Simple Past",
                        subject: "Englisch",
                        duration: "10 Min",
                        difficulty: "Mittel",
                        icon: "globe",
                        color: .green
                    )
                }
                .padding(.horizontal, 1)
            }
        }
    }
    
    private var favoriteSubjectsSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Deine Lieblingsfächer")
                .font(.headline)
                .fontWeight(.semibold)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ForEach(userProfile?.lieblingsfaecher ?? [], id: \.self) { fach in
                    SubjectQuickAccessCard(subject: fach)
                }
            }
        }
    }
    
    private var homeworkSection: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Hausaufgaben")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Hinzufügen") {
                    // Hausaufgabe hinzufügen
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            VStack(spacing: 10) {
                HomeworkCard(
                    subject: "Mathematik",
                    title: "Aufgaben S. 45, Nr. 1-10",
                    dueDate: "Morgen",
                    isCompleted: false
                )
                
                HomeworkCard(
                    subject: "Deutsch",
                    title: "Aufsatz: Meine Ferien",
                    dueDate: "Freitag",
                    isCompleted: true
                )
            }
        }
    }
    
    private var premiumSection: some View {
        Button(action: {
            showPremiumSheet = true
        }) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Image(systemName: "crown.fill")
                            .foregroundColor(.yellow)
                        
                        Text("Schul-Coach AI Premium")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    
                    Text("Unbegrenzter Zugang zu allen Funktionen, personalisierte Lernpläne und vieles mehr!")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(
                LinearGradient(
                    colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(LinearGradient(
                        colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ), lineWidth: 1)
            )
        }
    }
    
    private var greetingText: String {
        let hour = Calendar.current.component(.hour, from: currentTime)
        
        switch hour {
        case 5..<12:
            return "Guten Morgen,"
        case 12..<17:
            return "Guten Tag,"
        case 17..<22:
            return "Guten Abend,"
        default:
            return "Gute Nacht,"
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            VStack(spacing: 2) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(color.opacity(0.1))
        )
    }
}

struct RecommendationCard: View {
    let title: String
    let subject: String
    let duration: String
    let difficulty: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Spacer()
                
                Text(difficulty)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(color)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(color.opacity(0.2))
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
                
                Text(subject)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Text(duration)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding()
        .frame(width: 180, height: 140)
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
}

struct SubjectQuickAccessCard: View {
    let subject: Schulfach
    
    var body: some View {
        Button(action: {
            // Navigation zum Fach
        }) {
            VStack(spacing: 8) {
                Image(systemName: subject.icon)
                    .font(.title2)
                    .foregroundColor(.blue)
                
                Text(subject.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.primary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct HomeworkCard: View {
    let subject: String
    let title: String
    let dueDate: String
    @State var isCompleted: Bool
    
    var body: some View {
        HStack {
            Button(action: {
                isCompleted.toggle()
            }) {
                Image(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
                    .font(.title3)
                    .foregroundColor(isCompleted ? .green : .secondary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(subject)
                    .font(.caption)
                    .fontWeight(.medium)
                    .foregroundColor(.blue)
                
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .strikethrough(isCompleted)
                    .foregroundColor(isCompleted ? .secondary : .primary)
                
                Text("Fällig: \(dueDate)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    HomeView(userProfile: UserProfile(
        name: "Max Mustermann",
        bundesland: .bayern,
        schulform: .gymnasium,
        klassenstufe: 8,
        lieblingsfaecher: [.mathematik, .englisch, .biologie],
        schwierigeFaecher: [.deutsch],
        lernziele: []
    ))
}