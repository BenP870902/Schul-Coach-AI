//
//  OnboardingView.swift
//  Schul-Coach AI
//
//  Created by Ben Picha on 15.09.25.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentStep = 0
    @State private var name = ""
    @State private var selectedBundesland: Bundesland = .bayern
    @State private var selectedSchulform: Schulform = .grundschule
    @State private var selectedKlassenstufe = 1
    @State private var selectedLieblingsfaecher: Set<Schulfach> = []
    @State private var selectedSchwierigeFaecher: Set<Schulfach> = []
    @State private var showMainApp = false
    
    private let totalSteps = 5
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress Bar
                ProgressView(value: Double(currentStep), total: Double(totalSteps))
                    .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                    .scaleEffect(x: 1, y: 4, anchor: .center)
                    .padding(.horizontal)
                
                ScrollView {
                    VStack(spacing: 30) {
                        // Header
                        VStack(spacing: 10) {
                            Image(systemName: "graduationcap.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.blue)
                                .padding(.top, 20)
                            
                            Text("Willkommen bei Schul-Coach AI")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .multilineTextAlignment(.center)
                            
                            Text("Dein persönlicher KI-Lernbegleiter für alle Schulfächer")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        // Step Content
                        Group {
                            switch currentStep {
                            case 0:
                                welcomeStep
                            case 1:
                                nameStep
                            case 2:
                                locationStep
                            case 3:
                                schoolStep
                            case 4:
                                subjectsStep
                            default:
                                EmptyView()
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                }
                
                // Navigation Buttons
                HStack {
                    if currentStep > 0 {
                        Button("Zurück") {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep -= 1
                            }
                        }
                        .buttonStyle(SecondaryButtonStyle())
                    }
                    
                    Spacer()
                    
                    Button(currentStep == totalSteps - 1 ? "Los geht's!" : "Weiter") {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            if currentStep == totalSteps - 1 {
                                completeOnboarding()
                            } else {
                                currentStep += 1
                            }
                        }
                    }
                    .buttonStyle(PrimaryButtonStyle())
                    .disabled(!canProceed)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .navigationBarHidden(true)
        }
        .fullScreenCover(isPresented: $showMainApp) {
            MainTabView()
        }
    }
    
    private var welcomeStep: some View {
        VStack(spacing: 20) {
            VStack(spacing: 15) {
                FeatureCard(
                    icon: "brain.head.profile",
                    title: "KI-Powered Learning",
                    description: "Personalisierte Lernunterstützung mit modernster KI-Technologie"
                )
                
                FeatureCard(
                    icon: "map.fill",
                    title: "Deutscher Lehrplan",
                    description: "Angepasst an alle Bundesländer und Schulformen"
                )
                
                FeatureCard(
                    icon: "gamecontroller.fill",
                    title: "Interaktive Spiele",
                    description: "Lernspiele und Rätsel für mehr Spaß beim Lernen"
                )
            }
        }
    }
    
    private var nameStep: some View {
        VStack(spacing: 20) {
            Text("Wie heißt du?")
                .font(.title2)
                .fontWeight(.semibold)
            
            TextField("Dein Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .font(.title3)
                .padding(.horizontal, 10)
        }
    }
    
    private var locationStep: some View {
        VStack(spacing: 20) {
            Text("In welchem Bundesland gehst du zur Schule?")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 10) {
                ForEach(Bundesland.allCases) { bundesland in
                    Button(action: {
                        selectedBundesland = bundesland
                    }) {
                        Text(bundesland.rawValue)
                            .font(.footnote)
                            .fontWeight(.medium)
                            .foregroundColor(selectedBundesland == bundesland ? .white : .primary)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(selectedBundesland == bundesland ? Color.blue : Color(.systemGray6))
                            )
                    }
                }
            }
        }
    }
    
    private var schoolStep: some View {
        VStack(spacing: 20) {
            Text("Welche Schule besuchst du?")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 15) {
                ForEach(Schulform.allCases) { schulform in
                    Button(action: {
                        selectedSchulform = schulform
                        if let firstGrade = schulform.availableGrades.first {
                            selectedKlassenstufe = firstGrade
                        }
                    }) {
                        VStack(spacing: 8) {
                            Image(systemName: schulform.icon)
                                .font(.title2)
                                .foregroundColor(selectedSchulform == schulform ? .white : .blue)
                            
                            Text(schulform.rawValue)
                                .font(.caption)
                                .fontWeight(.medium)
                                .foregroundColor(selectedSchulform == schulform ? .white : .primary)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(selectedSchulform == schulform ? Color.blue : Color(.systemGray6))
                        )
                    }
                }
            }
            
            if !selectedSchulform.availableGrades.isEmpty {
                VStack(spacing: 10) {
                    Text("Klassenstufe:")
                        .font(.headline)
                    
                    Picker("Klassenstufe", selection: $selectedKlassenstufe) {
                        ForEach(selectedSchulform.availableGrades, id: \.self) { grade in
                            Text(grade == 0 ? "Vorschule" : "\(grade). Klasse")
                                .tag(grade)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
        }
    }
    
    private var subjectsStep: some View {
        VStack(spacing: 20) {
            Text("Welche Fächer magst du besonders?")
                .font(.title2)
                .fontWeight(.semibold)
                .multilineTextAlignment(.center)
            
            Text("Wähle bis zu 3 Lieblingsfächer aus:")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 10) {
                ForEach(availableSubjects) { fach in
                    Button(action: {
                        toggleSubject(fach, in: &selectedLieblingsfaecher)
                    }) {
                        VStack(spacing: 5) {
                            Image(systemName: fach.icon)
                                .font(.title3)
                                .foregroundColor(selectedLieblingsfaecher.contains(fach) ? .white : .blue)
                            
                            Text(fach.rawValue)
                                .font(.caption2)
                                .fontWeight(.medium)
                                .foregroundColor(selectedLieblingsfaecher.contains(fach) ? .white : .primary)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedLieblingsfaecher.contains(fach) ? Color.blue : Color(.systemGray6))
                        )
                    }
                    .disabled(selectedLieblingsfaecher.count >= 3 && !selectedLieblingsfaecher.contains(fach))
                }
            }
        }
    }
    
    private var availableSubjects: [Schulfach] {
        Schulfach.allCases.filter { subject in
            subject.isAvailableFor(schulform: selectedSchulform, grade: selectedKlassenstufe)
        }
    }
    
    private var canProceed: Bool {
        switch currentStep {
        case 0: return true
        case 1: return !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        case 2: return true
        case 3: return true
        case 4: return !selectedLieblingsfaecher.isEmpty
        default: return false
        }
    }
    
    private func toggleSubject(_ subject: Schulfach, in set: inout Set<Schulfach>) {
        if set.contains(subject) {
            set.remove(subject)
        } else if set.count < 3 {
            set.insert(subject)
        }
    }
    
    private func completeOnboarding() {
        let userProfile = UserProfile(
            name: name,
            bundesland: selectedBundesland,
            schulform: selectedSchulform,
            klassenstufe: selectedKlassenstufe,
            lieblingsfaecher: Array(selectedLieblingsfaecher),
            schwierigeFaecher: Array(selectedSchwierigeFaecher),
            lernziele: []
        )
        
        UserDefaults.standard.set(try? JSONEncoder().encode(userProfile), forKey: "userProfile")
        UserDefaults.standard.set(true, forKey: "hasCompletedOnboarding")
        
        showMainApp = true
    }
}

struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 40)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.leading)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct PrimaryButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.headline)
            .foregroundColor(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 30)
            .background(Color.blue)
            .cornerRadius(10)
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

struct SecondaryButtonStyle: ButtonStyle {
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
    OnboardingView()
}