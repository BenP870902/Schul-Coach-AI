//
//  ProgressView.swift
//  Schul-Coach AI
//
//  Created by Ben Picha on 15.09.25.
//

import SwiftUI
import Charts

struct ProgressView: View {
    let userProfile: UserProfile?
    @State private var selectedTimeframe: Timeframe = .week
    @State private var showDetailView = false
    @State private var selectedSubject: Schulfach?
    
    enum Timeframe: String, CaseIterable {
        case week = "Woche"
        case month = "Monat"
        case year = "Jahr"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Stats Overview
                    statsOverview
                    
                    // Timeframe Selector
                    timeframeSelector
                    
                    // Learning Streak
                    learningStreak
                    
                    // Subject Progress
                    subjectProgress
                    
                    // Activity Chart
                    activityChart
                    
                    // Achievements
                    achievements
                }
                .padding(.horizontal)
            }
            .navigationTitle("Lernfortschritt")
            .navigationBarTitleDisplayMode(.large)
        }
        .sheet(isPresented: $showDetailView) {
            if let subject = selectedSubject {
                SubjectProgressDetailView(subject: subject, userProfile: userProfile)
            }
        }
    }
    
    private var statsOverview: some View {
        LazyVGrid(columns: [
            GridItem(.flexible()),
            GridItem(.flexible()),
            GridItem(.flexible())
        ], spacing: 15) {
            StatCard(
                title: "Gesamtpunkte",
                value: "2,847",
                subtitle: "+150 heute",
                icon: "star.fill",
                color: .yellow
            )
            
            StatCard(
                title: "Lernstreak",
                value: "12",
                subtitle: "Tage",
                icon: "flame.fill",
                color: .orange
            )
            
            StatCard(
                title: "Abzeichen",
                value: "8",
                subtitle: "Erreicht",
                icon: "trophy.fill",
                color: .purple
            )
        }
    }
    
    private var timeframeSelector: some View {
        HStack {
            Text("Zeitraum:")
                .font(.headline)
                .fontWeight(.semibold)
            
            Spacer()
            
            Picker("Zeitraum", selection: $selectedTimeframe) {
                ForEach(Timeframe.allCases, id: \.self) { timeframe in
                    Text(timeframe.rawValue).tag(timeframe)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .frame(width: 200)
        }
    }
    
    private var learningStreak: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Lernstreak")
                .font(.headline)
                .fontWeight(.semibold)
            
            HStack {
                VStack(alignment: .leading, spacing: 5) {
                    Text("12 Tage in Folge! 🔥")
                        .font(.title3)
                        .fontWeight(.semibold)
                    
                    Text("Du warst in den letzten 12 Tagen aktiv")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                
                Spacer()
                
                CircularProgressView(
                    progress: 12.0 / 14.0,
                    goal: "14 Tage",
                    color: .orange
                )
            }
            
            // Streak Calendar
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
                ForEach(0..<14, id: \.self) { day in
                    StreakDayView(
                        isActive: day < 12,
                        isToday: day == 11
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private var subjectProgress: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Fächer-Fortschritt")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Alle anzeigen") {
                    // Show all subjects
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            VStack(spacing: 12) {
                ForEach(userProfile?.lieblingsfaecher ?? [.mathematik, .deutsch, .englisch], id: \.self) { subject in
                    SubjectProgressRow(
                        subject: subject,
                        progress: sampleProgress(for: subject),
                        onTap: {
                            selectedSubject = subject
                            showDetailView = true
                        }
                    )
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private var activityChart: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("Lernaktivität")
                .font(.headline)
                .fontWeight(.semibold)
            
            // Simplified chart representation
            VStack(spacing: 10) {
                HStack {
                    Text("Diese Woche")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text("2.5h Lernzeit")
                        .font(.subheadline)
                        .fontWeight(.medium)
                }
                
                // Weekly activity bars
                HStack(alignment: .bottom, spacing: 8) {
                    ForEach(weeklyActivity, id: \.day) { activity in
                        VStack(spacing: 4) {
                            RoundedRectangle(cornerRadius: 4)
                                .fill(activity.minutes > 0 ? Color.blue : Color.gray.opacity(0.3))
                                .frame(width: 30, height: max(4, CGFloat(activity.minutes) * 2))
                            
                            Text(activity.day)
                                .font(.caption2)
                                .foregroundColor(.secondary)
                        }
                    }
                }
                .frame(height: 80)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    private var achievements: some View {
        VStack(alignment: .leading, spacing: 15) {
            HStack {
                Text("Abzeichen")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Alle anzeigen") {
                    // Show all achievements
                }
                .font(.subheadline)
                .foregroundColor(.blue)
            }
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 15) {
                    ForEach(sampleAchievements, id: \.id) { achievement in
                        AchievementBadge(achievement: achievement)
                    }
                }
                .padding(.horizontal, 1)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(16)
    }
    
    // Sample data
    private var weeklyActivity: [DailyActivity] {
        [
            DailyActivity(day: "Mo", minutes: 25),
            DailyActivity(day: "Di", minutes: 35),
            DailyActivity(day: "Mi", minutes: 0),
            DailyActivity(day: "Do", minutes: 45),
            DailyActivity(day: "Fr", minutes: 30),
            DailyActivity(day: "Sa", minutes: 20),
            DailyActivity(day: "So", minutes: 15)
        ]
    }
    
    private var sampleAchievements: [Achievement] {
        [
            Achievement(
                title: "Erste Schritte",
                description: "Erstes Mal angemeldet",
                icon: "star.fill",
                color: .yellow,
                isUnlocked: true
            ),
            Achievement(
                title: "Mathe-Genie",
                description: "100 Mathe-Aufgaben gelöst",
                icon: "function",
                color: .red,
                isUnlocked: true
            ),
            Achievement(
                title: "Lernstreak",
                description: "7 Tage am Stück gelernt",
                icon: "flame.fill",
                color: .orange,
                isUnlocked: true
            ),
            Achievement(
                title: "Spielmeister",
                description: "10 Lernspiele abgeschlossen",
                icon: "gamecontroller.fill",
                color: .blue,
                isUnlocked: false
            )
        ]
    }
    
    private func sampleProgress(for subject: Schulfach) -> Double {
        switch subject {
        case .mathematik: return 0.75
        case .deutsch: return 0.60
        case .englisch: return 0.85
        case .biologie: return 0.40
        default: return 0.50
        }
    }
}

struct DailyActivity {
    let day: String
    let minutes: Int
}

struct Achievement: Identifiable {
    let id = UUID()
    let title: String
    let description: String
    let icon: String
    let color: Color
    let isUnlocked: Bool
}

struct CircularProgressView: View {
    let progress: Double
    let goal: String
    let color: Color
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(color.opacity(0.2), lineWidth: 8)
                .frame(width: 60, height: 60)
            
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                .frame(width: 60, height: 60)
                .rotationEffect(.degrees(-90))
                .animation(.easeInOut(duration: 1), value: progress)
            
            VStack(spacing: 2) {
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.bold)
                
                Text(goal)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

struct StreakDayView: View {
    let isActive: Bool
    let isToday: Bool
    
    var body: some View {
        Circle()
            .fill(isActive ? Color.orange : Color.gray.opacity(0.3))
            .frame(width: 20, height: 20)
            .overlay(
                Circle()
                    .stroke(isToday ? Color.blue : Color.clear, lineWidth: 2)
            )
    }
}

struct SubjectProgressRow: View {
    let subject: Schulfach
    let progress: Double
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: subject.icon)
                    .font(.title3)
                    .foregroundColor(.blue)
                    .frame(width: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(subject.rawValue)
                        .font(.headline)
                        .fontWeight(.medium)
                        .foregroundColor(.primary)
                    
                    HStack {
                        ProgressView(value: progress)
                            .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                            .scaleEffect(x: 1, y: 0.8)
                        
                        Text("\(Int(progress * 100))%")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.secondary)
                            .frame(width: 40, alignment: .trailing)
                    }
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding(.vertical, 8)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct AchievementBadge: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? achievement.color : Color.gray)
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.icon)
                    .font(.title3)
                    .foregroundColor(.white)
            }
            .opacity(achievement.isUnlocked ? 1.0 : 0.5)
            
            VStack(spacing: 2) {
                Text(achievement.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(achievement.description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .frame(width: 80)
    }
}

struct SubjectProgressDetailView: View {
    let subject: Schulfach
    let userProfile: UserProfile?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Subject Header
                    VStack(spacing: 15) {
                        Image(systemName: subject.icon)
                            .font(.system(size: 60))
                            .foregroundColor(.blue)
                        
                        Text(subject.rawValue)
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        Text("Detaillierter Fortschritt")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                    
                    // Progress Stats
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 15) {
                        DetailStatCard(title: "Abgeschlossen", value: "75%", icon: "checkmark.circle.fill", color: .green)
                        DetailStatCard(title: "Zeit investiert", value: "12h", icon: "clock.fill", color: .blue)
                        DetailStatCard(title: "Aufgaben gelöst", value: "156", icon: "pencil.circle.fill", color: .orange)
                        DetailStatCard(title: "Punkte", value: "890", icon: "star.fill", color: .yellow)
                    }
                    
                    // Topics Progress
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Themen-Fortschritt")
                            .font(.headline)
                            .fontWeight(.semibold)
                        
                        VStack(spacing: 12) {
                            ForEach(sampleTopics(for: subject), id: \.name) { topic in
                                TopicProgressRow(topic: topic)
                            }
                        }
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                }
                .padding(.horizontal)
            }
            .navigationTitle(subject.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Fertig") {
                    dismiss()
                }
            )
        }
    }
    
    private func sampleTopics(for subject: Schulfach) -> [TopicProgress] {
        switch subject {
        case .mathematik:
            return [
                TopicProgress(name: "Grundrechenarten", progress: 1.0, isCompleted: true),
                TopicProgress(name: "Bruchrechnung", progress: 0.8, isCompleted: false),
                TopicProgress(name: "Geometrie", progress: 0.6, isCompleted: false),
                TopicProgress(name: "Algebra", progress: 0.2, isCompleted: false)
            ]
        case .deutsch:
            return [
                TopicProgress(name: "Rechtschreibung", progress: 0.9, isCompleted: false),
                TopicProgress(name: "Satzglieder", progress: 0.7, isCompleted: false),
                TopicProgress(name: "Textverständnis", progress: 0.5, isCompleted: false),
                TopicProgress(name: "Aufsatz schreiben", progress: 0.3, isCompleted: false)
            ]
        case .englisch:
            return [
                TopicProgress(name: "Vocabulary", progress: 0.95, isCompleted: false),
                TopicProgress(name: "Simple Past", progress: 0.8, isCompleted: false),
                TopicProgress(name: "Present Perfect", progress: 0.6, isCompleted: false),
                TopicProgress(name: "Irregular Verbs", progress: 0.4, isCompleted: false)
            ]
        default:
            return [
                TopicProgress(name: "Grundlagen", progress: 0.8, isCompleted: false),
                TopicProgress(name: "Vertiefung", progress: 0.5, isCompleted: false),
                TopicProgress(name: "Anwendung", progress: 0.2, isCompleted: false)
            ]
        }
    }
}

struct TopicProgress {
    let name: String
    let progress: Double
    let isCompleted: Bool
}

struct DetailStatCard: View {
    let title: String
    let value: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct TopicProgressRow: View {
    let topic: TopicProgress
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(topic.name)
                        .font(.headline)
                        .fontWeight(.medium)
                    
                    if topic.isCompleted {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
                
                HStack {
                    ProgressView(value: topic.progress)
                        .progressViewStyle(LinearProgressViewStyle(tint: .blue))
                        .scaleEffect(x: 1, y: 0.8)
                    
                    Text("\(Int(topic.progress * 100))%")
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(.secondary)
                        .frame(width: 40, alignment: .trailing)
                }
            }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ProgressView(userProfile: UserProfile(
        name: "Max Mustermann",
        bundesland: .bayern,
        schulform: .gymnasium,
        klassenstufe: 8,
        lieblingsfaecher: [.mathematik, .deutsch, .englisch],
        schwierigeFaecher: [.biologie],
        lernziele: []
    ))
}