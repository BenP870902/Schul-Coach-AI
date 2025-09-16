//
//  ProfileView.swift
//  Schul-Coach AI
//
//  Created by Ben Picha on 15.09.25.
//

import SwiftUI

struct ProfileView: View {
    @Binding var userProfile: UserProfile?
    @State private var showEditProfile = false
    @State private var showPremiumSheet = false
    @State private var showSettingsSheet = false
    @State private var showParentDashboard = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Profile Header
                    profileHeader
                    
                    // Premium Status
                    if !(userProfile?.isPremium ?? false) {
                        premiumSection
                    }
                    
                    // Quick Stats
                    quickStats
                    
                    // Menu Sections
                    menuSections
                    
                    // App Info
                    appInfo
                }
                .padding(.horizontal)
            }
            .navigationTitle("Profil")
            .navigationBarTitleDisplayMode(.large)
            .sheet(isPresented: $showEditProfile) {
                EditProfileView(userProfile: $userProfile)
            }
            .sheet(isPresented: $showPremiumSheet) {
                PremiumView()
            }
            .sheet(isPresented: $showSettingsSheet) {
                SettingsView()
            }
            .sheet(isPresented: $showParentDashboard) {
                ParentDashboardView()
            }
        }
    }
    
    private var profileHeader: some View {
        VStack(spacing: 15) {
            // Avatar
            ZStack {
                Circle()
                    .fill(LinearGradient(
                        colors: [.blue, .purple],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(width: 80, height: 80)
                
                Text(userProfile?.name.prefix(1).uppercased() ?? "S")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundColor(.white)
            }
            
            // User Info
            VStack(spacing: 8) {
                Text(userProfile?.name ?? "Schüler")
                    .font(.title2)
                    .fontWeight(.bold)
                
                if let profile = userProfile {
                    VStack(spacing: 4) {
                        Text("\(profile.schulform.rawValue)")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        Text("\(profile.klassenstufe == 0 ? "Vorschule" : "\(profile.klassenstufe). Klasse") • \(profile.bundesland.rawValue)")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                // Premium Badge
                if userProfile?.isPremium ?? false {
                    HStack(spacing: 4) {
                        Image(systemName: "crown.fill")
                            .font(.caption)
                        Text("Premium Mitglied")
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(.yellow)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.yellow.opacity(0.2))
                    )
                }
            }
            
            // Edit Button
            Button("Profil bearbeiten") {
                showEditProfile = true
            }
            .font(.subheadline)
            .foregroundColor(.blue)
            .padding(.horizontal, 20)
            .padding(.vertical, 8)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(20)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
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
                        
                        Text("Upgrade zu Premium")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.primary)
                    }
                    
                    Text("Unbegrenzter Zugang zu allen Funktionen und Inhalten")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
                
                VStack(spacing: 2) {
                    Text("Ab")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text("10€")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    Text("/Monat")
                        .font(.caption)
                        .foregroundColor(.secondary)
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
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(LinearGradient(
                        colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ), lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private var quickStats: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 15) {
            QuickStatCard(
                title: "Lernstreak",
                value: "12",
                subtitle: "Tage",
                icon: "flame.fill",
                color: .orange
            )
            
            QuickStatCard(
                title: "Punkte",
                value: "2,847",
                subtitle: "Gesamt",
                icon: "star.fill",
                color: .yellow
            )
            
            QuickStatCard(
                title: "Abzeichen",
                value: "8",
                subtitle: "Erreicht",
                icon: "trophy.fill",
                color: .purple
            )
        }
    }
    
    private var menuSections: some View {
        VStack(spacing: 20) {
            // Learning Section
            MenuSection(title: "Lernen") {
                MenuRow(
                    title: "Lieblingsfächer",
                    subtitle: (userProfile?.lieblingsfaecher.map { $0.rawValue }.joined(separator: ", ")) ?? "Keine ausgewählt",
                    icon: "heart.fill",
                    color: .red
                ) {
                    showEditProfile = true
                }
                
                MenuRow(
                    title: "Lernziele",
                    subtitle: "Deine persönlichen Ziele",
                    icon: "target",
                    color: .green
                ) {
                    // Show learning goals
                }
                
                MenuRow(
                    title: "Schwierige Fächer",
                    subtitle: "Hier brauchst du mehr Übung",
                    icon: "exclamationmark.triangle.fill",
                    color: .orange
                ) {
                    showEditProfile = true
                }
            }
            
            // Family Section
            MenuSection(title: "Familie") {
                MenuRow(
                    title: "Eltern-Dashboard",
                    subtitle: "Fortschritt für Eltern",
                    icon: "person.2.fill",
                    color: .blue
                ) {
                    showParentDashboard = true
                }
                
                MenuRow(
                    title: "Familienaccount",
                    subtitle: "Mehrere Kinder verwalten",
                    icon: "house.fill",
                    color: .indigo
                ) {
                    // Show family account setup
                }
            }
            
            // App Section
            MenuSection(title: "App") {
                MenuRow(
                    title: "Einstellungen",
                    subtitle: "App-Einstellungen anpassen",
                    icon: "gear",
                    color: .gray
                ) {
                    showSettingsSheet = true
                }
                
                MenuRow(
                    title: "Hilfe & Support",
                    subtitle: "Fragen und Antworten",
                    icon: "questionmark.circle.fill",
                    color: .blue
                ) {
                    // Show help
                }
                
                MenuRow(
                    title: "Feedback",
                    subtitle: "Teile deine Meinung mit uns",
                    icon: "envelope.fill",
                    color: .green
                ) {
                    // Show feedback form
                }
            }
        }
    }
    
    private var appInfo: some View {
        VStack(spacing: 10) {
            Text("Schul-Coach AI")
                .font(.headline)
                .fontWeight(.semibold)
            
            Text("Version 1.0.0")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Text("© 2025 Schul-Coach AI. Alle Rechte vorbehalten.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.top, 5)
        }
        .padding()
    }
}

struct QuickStatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
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
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct MenuSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
                .padding(.horizontal, 4)
            
            VStack(spacing: 0) {
                content
            }
            .background(Color(.systemGray6))
            .cornerRadius(12)
        }
    }
}

struct MenuRow: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(color)
                    .frame(width: 25)
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    Text(subtitle)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EditProfileView: View {
    @Binding var userProfile: UserProfile?
    @Environment(\.dismiss) private var dismiss
    
    @State private var name: String
    @State private var selectedBundesland: Bundesland
    @State private var selectedSchulform: Schulform
    @State private var selectedKlassenstufe: Int
    @State private var selectedLieblingsfaecher: Set<Schulfach>
    @State private var selectedSchwierigeFaecher: Set<Schulfach>
    
    init(userProfile: Binding<UserProfile?>) {
        self._userProfile = userProfile
        
        let profile = userProfile.wrappedValue
        self._name = State(initialValue: profile?.name ?? "")
        self._selectedBundesland = State(initialValue: profile?.bundesland ?? .bayern)
        self._selectedSchulform = State(initialValue: profile?.schulform ?? .grundschule)
        self._selectedKlassenstufe = State(initialValue: profile?.klassenstufe ?? 1)
        self._selectedLieblingsfaecher = State(initialValue: Set(profile?.lieblingsfaecher ?? []))
        self._selectedSchwierigeFaecher = State(initialValue: Set(profile?.schwierigeFaecher ?? []))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section("Persönliche Daten") {
                    TextField("Name", text: $name)
                    
                    Picker("Bundesland", selection: $selectedBundesland) {
                        ForEach(Bundesland.allCases) { bundesland in
                            Text(bundesland.rawValue).tag(bundesland)
                        }
                    }
                    
                    Picker("Schulform", selection: $selectedSchulform) {
                        ForEach(Schulform.allCases) { schulform in
                            Text(schulform.rawValue).tag(schulform)
                        }
                    }
                    
                    Picker("Klassenstufe", selection: $selectedKlassenstufe) {
                        ForEach(selectedSchulform.availableGrades, id: \.self) { grade in
                            Text(grade == 0 ? "Vorschule" : "\(grade). Klasse").tag(grade)
                        }
                    }
                }
                
                Section("Lieblingsfächer") {
                    ForEach(availableSubjects, id: \.self) { subject in
                        HStack {
                            Image(systemName: subject.icon)
                                .foregroundColor(.blue)
                                .frame(width: 25)
                            
                            Text(subject.rawValue)
                            
                            Spacer()
                            
                            if selectedLieblingsfaecher.contains(subject) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.blue)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            toggleSubject(subject, in: &selectedLieblingsfaecher, maxCount: 5)
                        }
                    }
                }
                
                Section("Schwierige Fächer") {
                    ForEach(availableSubjects, id: \.self) { subject in
                        HStack {
                            Image(systemName: subject.icon)
                                .foregroundColor(.orange)
                                .frame(width: 25)
                            
                            Text(subject.rawValue)
                            
                            Spacer()
                            
                            if selectedSchwierigeFaecher.contains(subject) {
                                Image(systemName: "checkmark")
                                    .foregroundColor(.orange)
                            }
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            toggleSubject(subject, in: &selectedSchwierigeFaecher, maxCount: 3)
                        }
                    }
                }
            }
            .navigationTitle("Profil bearbeiten")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button("Abbrechen") {
                    dismiss()
                },
                trailing: Button("Speichern") {
                    saveProfile()
                }
                .disabled(name.isEmpty)
            )
        }
    }
    
    private var availableSubjects: [Schulfach] {
        Schulfach.allCases.filter { subject in
            subject.isAvailableFor(schulform: selectedSchulform, grade: selectedKlassenstufe)
        }
    }
    
    private func toggleSubject(_ subject: Schulfach, in set: inout Set<Schulfach>, maxCount: Int) {
        if set.contains(subject) {
            set.remove(subject)
        } else if set.count < maxCount {
            set.insert(subject)
        }
    }
    
    private func saveProfile() {
        let updatedProfile = UserProfile(
            name: name,
            bundesland: selectedBundesland,
            schulform: selectedSchulform,
            klassenstufe: selectedKlassenstufe,
            lieblingsfaecher: Array(selectedLieblingsfaecher),
            schwierigeFaecher: Array(selectedSchwierigeFaecher),
            lernziele: userProfile?.lernziele ?? [],
            isPremium: userProfile?.isPremium ?? false
        )
        
        userProfile = updatedProfile
        
        // Save to UserDefaults
        if let encoded = try? JSONEncoder().encode(updatedProfile) {
            UserDefaults.standard.set(encoded, forKey: "userProfile")
        }
        
        dismiss()
    }
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var notificationsEnabled = true
    @State private var soundEnabled = true
    @State private var parentalControlsEnabled = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Benachrichtigungen") {
                    Toggle("Push-Benachrichtigungen", isOn: $notificationsEnabled)
                    Toggle("Sounds", isOn: $soundEnabled)
                }
                
                Section("Datenschutz") {
                    Toggle("Kinderschutz aktiviert", isOn: $parentalControlsEnabled)
                    
                    Button("Datenschutzerklärung") {
                        // Show privacy policy
                    }
                    .foregroundColor(.blue)
                    
                    Button("Nutzungsbedingungen") {
                        // Show terms of service
                    }
                    .foregroundColor(.blue)
                }
                
                Section("Account") {
                    Button("Daten exportieren") {
                        // Export user data
                    }
                    .foregroundColor(.blue)
                    
                    Button("Account löschen") {
                        // Delete account
                    }
                    .foregroundColor(.red)
                }
            }
            .navigationTitle("Einstellungen")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Fertig") {
                    dismiss()
                }
            )
        }
    }
}

struct ParentDashboardView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Parent Dashboard Content
                    Text("Eltern-Dashboard")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding()
                    
                    Text("Hier können Eltern den Lernfortschritt ihrer Kinder verfolgen.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    // Placeholder content
                    VStack(spacing: 15) {
                        DashboardCard(
                            title: "Wöchentliche Lernzeit",
                            value: "2.5 Stunden",
                            icon: "clock.fill",
                            color: .blue
                        )
                        
                        DashboardCard(
                            title: "Abgeschlossene Aufgaben",
                            value: "23 von 30",
                            icon: "checkmark.circle.fill",
                            color: .green
                        )
                        
                        DashboardCard(
                            title: "Schwierigste Fächer",
                            value: "Mathematik, Deutsch",
                            icon: "exclamationmark.triangle.fill",
                            color: .orange
                        )
                    }
                    .padding(.horizontal)
                }
            }
            .navigationTitle("Eltern-Dashboard")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Fertig") {
                    dismiss()
                }
            )
        }
    }
}

struct DashboardCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.medium)
                
                Text(value)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct PremiumView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 30) {
                    // Header
                    VStack(spacing: 15) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)
                        
                        Text("Schul-Coach AI Premium")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .multilineTextAlignment(.center)
                        
                        Text("Unbegrenztes Lernen für maximalen Erfolg")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                    }
                    .padding()
                    
                    // Features
                    VStack(spacing: 15) {
                        PremiumFeature(
                            icon: "infinity",
                            title: "Unbegrenzter Zugang",
                            description: "Alle Fächer, Themen und Übungen ohne Limits"
                        )
                        
                        PremiumFeature(
                            icon: "brain.head.profile",
                            title: "Erweiterte KI-Funktionen",
                            description: "Personalisierte Lernpläne und intelligente Empfehlungen"
                        )
                        
                        PremiumFeature(
                            icon: "gamecontroller.fill",
                            title: "Premium-Lernspiele",
                            description: "Exklusive Spiele und interaktive Inhalte"
                        )
                        
                        PremiumFeature(
                            icon: "chart.line.uptrend.xyaxis",
                            title: "Detaillierte Berichte",
                            description: "Ausführliche Fortschrittsanalysen für Eltern"
                        )
                        
                        PremiumFeature(
                            icon: "person.2.fill",
                            title: "Familienaccount",
                            description: "Bis zu 4 Kinder in einem Account verwalten"
                        )
                    }
                    .padding(.horizontal)
                    
                    // Pricing
                    VStack(spacing: 20) {
                        Text("Wähle deinen Plan")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 15) {
                            PricingCard(
                                title: "Monatlich",
                                price: "12,99€",
                                period: "pro Monat",
                                isRecommended: false
                            )
                            
                            PricingCard(
                                title: "Jährlich",
                                price: "99,99€",
                                period: "pro Jahr",
                                savings: "35% sparen",
                                isRecommended: true
                            )
                        }
                    }
                    .padding(.horizontal)
                    
                    // CTA Button
                    Button("Premium starten") {
                        // Handle premium purchase
                    }
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.vertical, 15)
                    .padding(.horizontal, 40)
                    .background(
                        LinearGradient(
                            colors: [.blue, .purple],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .cornerRadius(25)
                    
                    Text("7 Tage kostenlos testen, danach automatische Verlängerung")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
            }
            .navigationBarItems(
                trailing: Button("Schließen") {
                    dismiss()
                }
            )
        }
    }
}

struct PremiumFeature: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct PricingCard: View {
    let title: String
    let price: String
    let period: String
    let savings: String?
    let isRecommended: Bool
    
    init(title: String, price: String, period: String, savings: String? = nil, isRecommended: Bool = false) {
        self.title = title
        self.price = price
        self.period = period
        self.savings = savings
        self.isRecommended = isRecommended
    }
    
    var body: some View {
        VStack(spacing: 12) {
            if isRecommended {
                Text("EMPFOHLEN")
                    .font(.caption)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 4)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
            
            Text(title)
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack(alignment: .bottom, spacing: 4) {
                Text(price)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text(period)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            if let savings = savings {
                Text(savings)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.green)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(isRecommended ? Color.blue : Color.gray.opacity(0.3), lineWidth: isRecommended ? 2 : 1)
                .background(Color(.systemGray6))
        )
        .cornerRadius(12)
    }
}

#Preview {
    ProfileView(userProfile: .constant(UserProfile(
        name: "Max Mustermann",
        bundesland: .bayern,
        schulform: .gymnasium,
        klassenstufe: 8,
        lieblingsfaecher: [.mathematik, .englisch, .biologie],
        schwierigeFaecher: [.deutsch],
        lernziele: []
    )))
}