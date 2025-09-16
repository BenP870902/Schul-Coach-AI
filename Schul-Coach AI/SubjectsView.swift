//
//  SubjectsView.swift
//  Schul-Coach AI
//
//  Created by Ben Picha on 15.09.25.
//

import SwiftUI

struct SubjectsView: View {
    let userProfile: UserProfile?
    @State private var searchText = ""
    @State private var selectedCategory: SubjectCategory = .all
    
    enum SubjectCategory: String, CaseIterable {
        case all = "Alle"
        case favorites = "Favoriten"
        case core = "Hauptfächer"
        case languages = "Sprachen"
        case sciences = "Naturwissenschaften"
        case humanities = "Geisteswissenschaften"
        case arts = "Kunst & Musik"
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $searchText)
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                // Category Filter
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(SubjectCategory.allCases, id: \.self) { category in
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
                .padding(.bottom, 20)
                
                // Subjects Grid
                ScrollView {
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        ForEach(filteredSubjects, id: \.self) { subject in
                            SubjectCard(
                                subject: subject,
                                userProfile: userProfile
                            )
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Fächer")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
    private var filteredSubjects: [Schulfach] {
        let availableSubjects = userProfile?.availableSubjects ?? Schulfach.allCases
        
        let categoryFiltered = availableSubjects.filter { subject in
            switch selectedCategory {
            case .all:
                return true
            case .favorites:
                return userProfile?.lieblingsfaecher.contains(subject) ?? false
            case .core:
                return [.deutsch, .mathematik, .englisch].contains(subject)
            case .languages:
                return [.englisch, .franzoesisch, .spanisch, .italienisch, .russisch, .latein, .griechisch].contains(subject)
            case .sciences:
                return [.mathematik, .biologie, .chemie, .physik, .informatik].contains(subject)
            case .humanities:
                return [.geschichte, .erdkunde, .politik, .wirtschaft, .religion].contains(subject)
            case .arts:
                return [.kunst, .musik].contains(subject)
            }
        }
        
        if searchText.isEmpty {
            return categoryFiltered
        } else {
            return categoryFiltered.filter { subject in
                subject.rawValue.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.secondary)
            
            TextField("Fächer durchsuchen...", text: $text)
                .textFieldStyle(PlainTextFieldStyle())
            
            if !text.isEmpty {
                Button(action: {
                    text = ""
                }) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

struct CategoryButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(isSelected ? .white : .primary)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(isSelected ? Color.blue : Color(.systemGray6))
                )
        }
    }
}

struct SubjectCard: View {
    let subject: Schulfach
    let userProfile: UserProfile?
    
    private var isFavorite: Bool {
        userProfile?.lieblingsfaecher.contains(subject) ?? false
    }
    
    private var isDifficult: Bool {
        userProfile?.schwierigeFaecher.contains(subject) ?? false
    }
    
    var body: some View {
        NavigationLink(destination: SubjectDetailView(subject: subject, userProfile: userProfile)) {
            VStack(spacing: 12) {
                // Header with favorite indicator
                HStack {
                    if isFavorite {
                        Image(systemName: "heart.fill")
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    
                    Spacer()
                    
                    if isDifficult {
                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                }
                .frame(height: 16)
                
                // Subject Icon
                Image(systemName: subject.icon)
                    .font(.system(size: 40))
                    .foregroundColor(.blue)
                
                // Subject Name
                Text(subject.rawValue)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .foregroundColor(.primary)
                
                // Progress indicator (placeholder)
                SwiftUI.ProgressView(value: 0.65)
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .scaleEffect(x: 1, y: 0.5)
                
                Text("65% abgeschlossen")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .frame(height: 180)
            .background(Color(.systemGray6))
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isFavorite ? Color.red.opacity(0.3) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct SubjectDetailView: View {
    let subject: Schulfach
    let userProfile: UserProfile?
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 15) {
                    Image(systemName: subject.icon)
                        .font(.system(size: 60))
                        .foregroundColor(.blue)
                    
                    Text(subject.rawValue)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    if let profile = userProfile {
                        Text("\(profile.klassenstufe == 0 ? "Vorschule" : "\(profile.klassenstufe). Klasse") • \(profile.schulform.rawValue)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding()
                
                // Quick Actions
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 15) {
                    QuickActionCard(
                        title: "Lernen",
                        subtitle: "Neue Themen",
                        icon: "book.fill",
                        color: .blue
                    )
                    
                    QuickActionCard(
                        title: "Üben",
                        subtitle: "Aufgaben lösen",
                        icon: "pencil.and.outline",
                        color: .green
                    )
                    
                    QuickActionCard(
                        title: "Testen",
                        subtitle: "Wissen prüfen",
                        icon: "checkmark.circle.fill",
                        color: .orange
                    )
                    
                    QuickActionCard(
                        title: "KI-Hilfe",
                        subtitle: "Fragen stellen",
                        icon: "brain.head.profile",
                        color: .purple
                    )
                }
                .padding(.horizontal)
                
                // Recent Topics
                VStack(alignment: .leading, spacing: 15) {
                    Text("Aktuelle Themen")
                        .font(.headline)
                        .fontWeight(.semibold)
                        .padding(.horizontal)
                    
                    VStack(spacing: 10) {
                        TopicCard(
                            title: getRecentTopics().first ?? "Grundlagen",
                            progress: 0.8,
                            difficulty: "Mittel"
                        )
                        
                        TopicCard(
                            title: getRecentTopics().dropFirst().first ?? "Vertiefung",
                            progress: 0.3,
                            difficulty: "Schwer"
                        )
                    }
                    .padding(.horizontal)
                }
            }
        }
        .navigationTitle(subject.rawValue)
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func getRecentTopics() -> [String] {
        switch subject {
        case .mathematik:
            return ["Bruchrechnung", "Geometrie", "Algebra"]
        case .deutsch:
            return ["Satzglieder", "Rechtschreibung", "Textanalyse"]
        case .englisch:
            return ["Simple Past", "Vocabulary", "Grammar"]
        case .biologie:
            return ["Zellbiologie", "Ökosystem", "Genetik"]
        case .geschichte:
            return ["Mittelalter", "Neuzeit", "20. Jahrhundert"]
        default:
            return ["Grundlagen", "Vertiefung", "Anwendung"]
        }
    }
}

struct QuickActionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        Button(action: {
            // Action implementation
        }) {
            VStack(spacing: 10) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct TopicCard: View {
    let title: String
    let progress: Double
    let difficulty: String
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(difficulty)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 6)
                            .fill(Color(.systemGray5))
                    )
                
                    SwiftUI.ProgressView(value: progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .scaleEffect(x: 1, y: 0.5)
                
                Text("\(Int(progress * 100))% abgeschlossen")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: {
                // Continue learning
            }) {
                Image(systemName: "play.circle.fill")
                    .font(.title)
                    .foregroundColor(.blue)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

#Preview {
    SubjectsView(userProfile: UserProfile(
        name: "Max Mustermann",
        bundesland: .bayern,
        schulform: .gymnasium,
        klassenstufe: 8,
        lieblingsfaecher: [.mathematik, .englisch, .biologie],
        schwierigeFaecher: [.deutsch],
        lernziele: []
    ))
}