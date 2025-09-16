//
//  GamesView.swift
//  Schul-Coach AI
//
//  Created by Ben Picha on 15.09.25.
//

import SwiftUI

struct GamesView: View {
    let userProfile: UserProfile?
    @State private var selectedCategory: GameCategory = .all
    
    enum GameCategory: String, CaseIterable {
        case all = "Alle Spiele"
        case math = "Rechnen"
        case language = "Sprache"
        case knowledge = "Wissen"
        case memory = "Gedächtnis"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Welcome Header
                welcomeHeader
                
                // Category Filter
                categoryFilter
                
                // Games Grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(filteredGames, id: \.id) { game in
                            GameCard(game: game)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationTitle("Lernspiele")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var welcomeHeader: some View {
        VStack(spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("Spielend lernen! 🎮")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Text("Entdecke spannende Lernspiele für deine Klassenstufe")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                // Fun emoji or icon
                Text("🌟")
                    .font(.system(size: 40))
            }
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
        .padding(.horizontal)
        .padding(.top, 10)
    }
    
    private var categoryFilter: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(GameCategory.allCases, id: \.self) { category in
                    CategoryButton(
                        title: category.rawValue,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
            .padding(.horizontal)
        }
        .padding(.vertical, 15)
    }
    
    private var filteredGames: [LearningGame] {
        let allGames = LearningGame.sampleGames(for: userProfile)
        
        switch selectedCategory {
        case .all:
            return allGames
        case .math:
            return allGames.filter { $0.category == .mathematics }
        case .language:
            return allGames.filter { $0.category == .language }
        case .knowledge:
            return allGames.filter { $0.category == .knowledge }
        case .memory:
            return allGames.filter { $0.category == .memory }
        }
    }
}

struct LearningGame: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let category: Category
    let difficulty: Difficulty
    let estimatedTime: Int // in minutes
    let icon: String
    let color: Color
    let isPremium: Bool
    let minGrade: Int
    let maxGrade: Int
    
    enum Category {
        case mathematics
        case language
        case knowledge
        case memory
    }
    
    enum Difficulty: String {
        case easy = "Leicht"
        case medium = "Mittel"
        case hard = "Schwer"
    }
    
    static func sampleGames(for userProfile: UserProfile?) -> [LearningGame] {
        let grade = userProfile?.klassenstufe ?? 2
        
        return [
            // Mathematik Spiele
            LearningGame(
                title: "Zahlen-Memory",
                description: "Finde die passenden Zahlenpaare!",
                category: .memory,
                difficulty: .easy,
                estimatedTime: 10,
                icon: "number.circle.fill",
                color: .blue,
                isPremium: false,
                minGrade: 1,
                maxGrade: 4
            ),
            
            LearningGame(
                title: "Rechen-Rennen",
                description: "Löse Aufgaben und sammle Punkte!",
                category: .mathematics,
                difficulty: .medium,
                estimatedTime: 15,
                icon: "car.fill",
                color: .red,
                isPremium: false,
                minGrade: 2,
                maxGrade: 6
            ),
            
            LearningGame(
                title: "Einmaleins-Champion",
                description: "Werde zum Einmaleins-Meister!",
                category: .mathematics,
                difficulty: .medium,
                estimatedTime: 12,
                icon: "crown.fill",
                color: .orange,
                isPremium: true,
                minGrade: 2,
                maxGrade: 5
            ),
            
            // Sprach-Spiele
            LearningGame(
                title: "Buchstaben-Suppe",
                description: "Finde Wörter in der Buchstaben-Suppe!",
                category: .language,
                difficulty: .easy,
                estimatedTime: 8,
                icon: "textformat.abc",
                color: .green,
                isPremium: false,
                minGrade: 1,
                maxGrade: 4
            ),
            
            LearningGame(
                title: "Reimzeit",
                description: "Finde Wörter, die sich reimen!",
                category: .language,
                difficulty: .easy,
                estimatedTime: 10,
                icon: "music.note",
                color: .purple,
                isPremium: false,
                minGrade: 1,
                maxGrade: 3
            ),
            
            LearningGame(
                title: "Silben-Puzzle",
                description: "Setze die Silben richtig zusammen!",
                category: .language,
                difficulty: .medium,
                estimatedTime: 12,
                icon: "puzzlepiece.fill",
                color: .mint,
                isPremium: true,
                minGrade: 2,
                maxGrade: 4
            ),
            
            // Wissens-Spiele
            LearningGame(
                title: "Tier-Quiz",
                description: "Wie gut kennst du die Tierwelt?",
                category: .knowledge,
                difficulty: .easy,
                estimatedTime: 15,
                icon: "pawprint.fill",
                color: .brown,
                isPremium: false,
                minGrade: 1,
                maxGrade: 4
            ),
            
            LearningGame(
                title: "Deutschland-Entdecker",
                description: "Entdecke deutsche Städte und Bundesländer!",
                category: .knowledge,
                difficulty: .medium,
                estimatedTime: 20,
                icon: "map.fill",
                color: .indigo,
                isPremium: true,
                minGrade: 3,
                maxGrade: 6
            ),
            
            LearningGame(
                title: "Farben-Memory",
                description: "Lerne Farben mit Spaß!",
                category: .memory,
                difficulty: .easy,
                estimatedTime: 8,
                icon: "paintpalette.fill",
                color: .pink,
                isPremium: false,
                minGrade: 1,
                maxGrade: 2
            )
        ].filter { game in
            grade >= game.minGrade && grade <= game.maxGrade
        }
    }
}

struct GameCard: View {
    let game: LearningGame
    @State private var showGameView = false
    @State private var showPremiumAlert = false
    
    var body: some View {
        Button(action: {
            if game.isPremium {
                showPremiumAlert = true
            } else {
                showGameView = true
            }
        }) {
            VStack(spacing: 12) {
                // Header with premium badge
                HStack {
                    if game.isPremium {
                        Image(systemName: "crown.fill")
                            .font(.caption)
                            .foregroundColor(.yellow)
                    }
                    
                    Spacer()
                    
                    Text(game.difficulty.rawValue)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(game.color)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 6)
                                .fill(game.color.opacity(0.2))
                        )
                }
                .frame(height: 16)
                
                // Game Icon
                Image(systemName: game.icon)
                    .font(.system(size: 35))
                    .foregroundColor(game.color)
                
                // Game Info
                VStack(spacing: 6) {
                    Text(game.title)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                        .foregroundColor(.primary)
                    
                    Text(game.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .lineLimit(2)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "clock")
                            .font(.caption2)
                        Text("\(game.estimatedTime) Min")
                            .font(.caption2)
                    }
                    .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(height: 180)
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(game.isPremium ? Color.yellow.opacity(0.3) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showGameView) {
            GamePlayView(game: game)
        }
        .alert("Premium Feature", isPresented: $showPremiumAlert) {
            Button("Upgrade") {
                // Show premium upgrade
            }
            Button("Abbrechen", role: .cancel) { }
        } message: {
            Text("Dieses Spiel ist nur für Premium-Mitglieder verfügbar. Upgrade jetzt für Zugang zu allen Lernspielen!")
        }
    }
}

struct GamePlayView: View {
    let game: LearningGame
    @Environment(\.dismiss) private var dismiss
    @State private var currentScore = 0
    @State private var gameState: GameState = .ready
    
    enum GameState {
        case ready
        case playing
        case completed
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Game Header
                VStack(spacing: 10) {
                    Image(systemName: game.icon)
                        .font(.system(size: 50))
                        .foregroundColor(game.color)
                    
                    Text(game.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(game.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
                .padding()
                
                Spacer()
                
                // Game Content based on state
                Group {
                    switch gameState {
                    case .ready:
                        readyView
                    case .playing:
                        playingView
                    case .completed:
                        completedView
                    }
                }
                
                Spacer()
                
                // Score Display
                if gameState != .ready {
                    HStack {
                        Text("Punkte: \(currentScore)")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        Spacer()
                        
                        HStack(spacing: 4) {
                            Image(systemName: "clock")
                            Text("5:23")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    .padding(.horizontal)
                }
            }
            .navigationBarItems(
                leading: Button("Schließen") {
                    dismiss()
                }
            )
        }
    }
    
    private var readyView: some View {
        VStack(spacing: 30) {
            VStack(spacing: 15) {
                Text("Bereit zum Spielen?")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                VStack(spacing: 10) {
                    GameInfoRow(icon: "clock", text: "\(game.estimatedTime) Minuten")
                    GameInfoRow(icon: "target", text: game.difficulty.rawValue)
                    GameInfoRow(icon: "star.fill", text: "Sammle Punkte!")
                }
            }
            
            Button("Spiel starten! 🚀") {
                gameState = .playing
            }
            .font(.headline)
            .foregroundColor(.white)
            .padding(.horizontal, 30)
            .padding(.vertical, 15)
            .background(game.color)
            .cornerRadius(25)
        }
    }
    
    private var playingView: some View {
        VStack(spacing: 20) {
            // Beispiel-Spielinhalt (würde je nach Spiel variieren)
            Text("Spiel läuft...")
                .font(.title)
                .fontWeight(.semibold)
            
            // Demo Frage
            VStack(spacing: 15) {
                Text("Was ist 7 + 5?")
                    .font(.title2)
                    .fontWeight(.semibold)
                
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 12) {
                    ForEach([10, 12, 13, 15], id: \.self) { answer in
                        Button("\(answer)") {
                            if answer == 12 {
                                currentScore += 10
                            }
                            // Simulate game completion after a few questions
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                gameState = .completed
                            }
                        }
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.primary)
                        .frame(height: 60)
                        .frame(maxWidth: .infinity)
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
    }
    
    private var completedView: some View {
        VStack(spacing: 30) {
            VStack(spacing: 15) {
                Text("🎉")
                    .font(.system(size: 60))
                
                Text("Fantastisch!")
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("Du hast \(currentScore) Punkte erreicht!")
                    .font(.title2)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 12) {
                Button("Nochmal spielen") {
                    currentScore = 0
                    gameState = .ready
                }
                .buttonStyle(PrimaryGameButtonStyle(color: game.color))
                
                Button("Neues Spiel wählen") {
                    dismiss()
                }
                .buttonStyle(SecondaryGameButtonStyle())
            }
        }
    }
}

struct GameInfoRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundColor(.blue)
                .frame(width: 20)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

struct PrimaryGameButtonStyle: ButtonStyle {
    let color: Color
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 30)
            .background(color)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryGameButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.blue)
            .padding(.vertical, 12)
            .padding(.horizontal, 30)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    GamesView(userProfile: UserProfile(
        name: "Emma Schmidt",
        bundesland: .bayern,
        schulform: .grundschule,
        klassenstufe: 2,
        lieblingsfaecher: [.mathematik, .deutsch],
        schwierigeFaecher: [],
        lernziele: []
    ))
}