//
//  AITutorView.swift
//  Schul-Coach AI
//
//  Created by Ben Picha on 15.09.25.
//

import SwiftUI

struct AITutorView: View {
    let userProfile: UserProfile?
    @State private var messages: [ChatMessage] = []
    @State private var inputText = ""
    @State private var isTyping = false
    @State private var selectedSubject: Schulfach?
    @State private var showSubjectPicker = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Subject Selection Header
                if let subject = selectedSubject {
                    SubjectHeader(subject: subject) {
                        showSubjectPicker = true
                    }
                } else {
                    EmptySubjectHeader {
                        showSubjectPicker = true
                    }
                }
                
                // Chat Messages
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 12) {
                            if messages.isEmpty {
                                WelcomeMessage(userProfile: userProfile)
                                    .padding(.top, 20)
                            } else {
                                ForEach(messages) { message in
                                    MessageBubble(message: message)
                                        .id(message.id)
                                }
                            }
                            
                            if isTyping {
                                TypingIndicator()
                            }
                        }
                        .padding(.horizontal)
                        .padding(.bottom, 20)
                    }
                    .onChange(of: messages.count) { _ in
                        if let lastMessage = messages.last {
                            withAnimation(.easeInOut(duration: 0.5)) {
                                proxy.scrollTo(lastMessage.id, anchor: .bottom)
                            }
                        }
                    }
                }
                
                // Input Area
                ChatInputView(
                    text: $inputText,
                    isEnabled: !isTyping,
                    onSend: sendMessage
                )
            }
            .navigationTitle("KI-Tutor")
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showSubjectPicker) {
                SubjectPickerView(
                    selectedSubject: $selectedSubject,
                    availableSubjects: userProfile?.availableSubjects ?? Schulfach.allCases
                )
            }
            .onAppear {
                if messages.isEmpty {
                    addWelcomeMessage()
                }
            }
        }
    }
    
    private func sendMessage() {
        guard !inputText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let userMessage = ChatMessage(
            content: inputText,
            isFromUser: true,
            subject: selectedSubject
        )
        
        messages.append(userMessage)
        let messageToSend = inputText
        inputText = ""
        
        // Simulate AI response
        isTyping = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            let aiResponse = generateAIResponse(for: messageToSend, subject: selectedSubject, userProfile: userProfile)
            let aiMessage = ChatMessage(
                content: aiResponse,
                isFromUser: false,
                subject: selectedSubject
            )
            
            messages.append(aiMessage)
            isTyping = false
        }
    }
    
    private func addWelcomeMessage() {
        let welcomeText = generateWelcomeMessage(for: userProfile)
        let welcomeMessage = ChatMessage(
            content: welcomeText,
            isFromUser: false,
            subject: nil
        )
        messages.append(welcomeMessage)
    }
}

struct ChatMessage: Identifiable, Codable {
    let id = UUID()
    let content: String
    let isFromUser: Bool
    let timestamp = Date()
    let subject: Schulfach?
}

struct SubjectHeader: View {
    let subject: Schulfach
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: subject.icon)
                    .font(.title3)
                    .foregroundColor(.blue)
                
                Text(subject.rawValue)
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Image(systemName: "chevron.down")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemGray6))
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct EmptySubjectHeader: View {
    let onTap: () -> Void
    
    var body: some View {
        Button(action: onTap) {
            HStack {
                Image(systemName: "plus.circle.fill")
                    .font(.title3)
                    .foregroundColor(.blue)
                
                Text("Fach auswählen")
                    .font(.headline)
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                
                Spacer()
            }
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                    .background(Color.blue.opacity(0.05))
            )
            .padding(.horizontal)
            .padding(.vertical, 10)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct WelcomeMessage: View {
    let userProfile: UserProfile?
    
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "brain.head.profile")
                .font(.system(size: 50))
                .foregroundColor(.blue)
            
            VStack(spacing: 10) {
                Text("Hallo \(userProfile?.name ?? "")! 👋")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text("Ich bin dein persönlicher KI-Tutor und helfe dir bei allen Schulfächern. Du kannst mir Fragen stellen, Aufgaben erklären lassen oder um Hilfe bei den Hausaufgaben bitten.")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 20)
            }
            
            VStack(spacing: 10) {
                Text("Beispielfragen:")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                VStack(alignment: .leading, spacing: 8) {
                    ExampleQuestion(text: "Erkläre mir Bruchrechnung")
                    ExampleQuestion(text: "Wie konjugiere ich englische Verben?")
                    ExampleQuestion(text: "Was passierte im Mittelalter?")
                    ExampleQuestion(text: "Hilf mir bei meinen Hausaufgaben")
                }
            }
        }
        .padding()
    }
}

struct ExampleQuestion: View {
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: "questionmark.circle.fill")
                .font(.caption)
                .foregroundColor(.blue)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Spacer()
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.isFromUser {
                Spacer(minLength: 50)
            }
            
            VStack(alignment: message.isFromUser ? .trailing : .leading, spacing: 8) {
                if let subject = message.subject {
                    HStack(spacing: 6) {
                        Image(systemName: subject.icon)
                            .font(.caption)
                        Text(subject.rawValue)
                            .font(.caption)
                            .fontWeight(.medium)
                    }
                    .foregroundColor(message.isFromUser ? .white.opacity(0.8) : .secondary)
                }
                
                Text(message.content)
                    .font(.body)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 18)
                            .fill(message.isFromUser ? Color.blue : Color(.systemGray5))
                    )
                    .foregroundColor(message.isFromUser ? .white : .primary)
                
                Text(formatTime(message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if !message.isFromUser {
                Spacer(minLength: 50)
            }
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

struct TypingIndicator: View {
    @State private var animationPhase = 0
    
    var body: some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(0..<3) { index in
                    Circle()
                        .fill(Color.secondary)
                        .frame(width: 8, height: 8)
                        .scaleEffect(animationPhase == index ? 1.2 : 0.8)
                        .animation(
                            Animation.easeInOut(duration: 0.6)
                                .repeatForever()
                                .delay(Double(index) * 0.2),
                            value: animationPhase
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 18)
                    .fill(Color(.systemGray5))
            )
            
            Spacer(minLength: 50)
        }
        .onAppear {
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: true) { _ in
                animationPhase = (animationPhase + 1) % 3
            }
        }
    }
}

struct ChatInputView: View {
    @Binding var text: String
    let isEnabled: Bool
    let onSend: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                TextField("Stelle deine Frage...", text: $text, axis: .vertical)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding(.horizontal, 16)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(.systemGray6))
                    )
                    .lineLimit(1...4)
                    .disabled(!isEnabled)
                
                Button(action: onSend) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.title2)
                        .foregroundColor(canSend ? .blue : .secondary)
                }
                .disabled(!canSend || !isEnabled)
            }
            .padding(.horizontal)
            .padding(.vertical, 12)
        }
        .background(Color(.systemBackground))
    }
    
    private var canSend: Bool {
        !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
}

struct SubjectPickerView: View {
    @Binding var selectedSubject: Schulfach?
    let availableSubjects: [Schulfach]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    Button("Kein Fach (Allgemeine Fragen)") {
                        selectedSubject = nil
                        dismiss()
                    }
                    .foregroundColor(.primary)
                }
                
                Section("Verfügbare Fächer") {
                    ForEach(availableSubjects, id: \.self) { subject in
                        Button(action: {
                            selectedSubject = subject
                            dismiss()
                        }) {
                            HStack {
                                Image(systemName: subject.icon)
                                    .foregroundColor(.blue)
                                    .frame(width: 25)
                                
                                Text(subject.rawValue)
                                    .foregroundColor(.primary)
                                
                                Spacer()
                                
                                if selectedSubject == subject {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Fach auswählen")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                trailing: Button("Fertig") {
                    dismiss()
                }
            )
        }
    }
}

// MARK: - Helper Functions

private func generateWelcomeMessage(for userProfile: UserProfile?) -> String {
    guard let profile = userProfile else {
        return "Willkommen! Ich bin dein KI-Tutor und helfe dir gerne bei allen Schulfächern. Stelle mir einfach deine Fragen!"
    }
    
    let greeting = "Hallo \(profile.name)! Schön, dass du da bist. "
    let schoolInfo = "Ich weiß, dass du die \(profile.klassenstufe == 0 ? "Vorschule" : "\(profile.klassenstufe). Klasse") an einer \(profile.schulform.rawValue) in \(profile.bundesland.rawValue) besuchst. "
    let subjects = profile.lieblingsfaecher.isEmpty ? "" : "Deine Lieblingsfächer sind \(profile.lieblingsfaecher.map { $0.rawValue }.joined(separator: ", ")). "
    let help = "Ich helfe dir gerne bei allen Fragen zu deinen Schulfächern. Wähle einfach ein Fach aus oder stelle mir direkt deine Frage!"
    
    return greeting + schoolInfo + subjects + help
}

private func generateAIResponse(for message: String, subject: Schulfach?, userProfile: UserProfile?) -> String {
    // Hier würde normalerweise eine echte KI-API aufgerufen werden
    // Für die Demo verwenden wir vordefinierte Antworten
    
    let lowercaseMessage = message.lowercased()
    
    // Begrüßungen
    if lowercaseMessage.contains("hallo") || lowercaseMessage.contains("hi") {
        return "Hallo! Wie kann ich dir heute beim Lernen helfen? 😊"
    }
    
    // Mathematik-spezifische Antworten
    if let subject = subject, subject == .mathematik || lowercaseMessage.contains("mathe") || lowercaseMessage.contains("rechnen") {
        if lowercaseMessage.contains("bruch") {
            return "Bruchrechnung kann am Anfang verwirrend sein, aber ich erkläre es dir gerne! 📊\n\nEin Bruch besteht aus zwei Teilen:\n• Zähler (oben): Wie viele Teile du hast\n• Nenner (unten): In wie viele Teile das Ganze geteilt ist\n\nBeispiel: Bei 3/4 hast du 3 von 4 gleichen Teilen.\n\nMöchtest du eine bestimmte Rechenart mit Brüchen üben?"
        }
        return "Mathematik ist ein faszinierendes Fach! Bei welchem Thema kann ich dir helfen? Algebra, Geometrie, Bruchrechnung oder etwas anderes? 🔢"
    }
    
    // Deutsch-spezifische Antworten
    if let subject = subject, subject == .deutsch || lowercaseMessage.contains("deutsch") || lowercaseMessage.contains("satz") {
        if lowercaseMessage.contains("satzglieder") {
            return "Satzglieder sind die Bausteine eines Satzes! 📝\n\nDie wichtigsten sind:\n• Subjekt (Wer oder was?)\n• Prädikat (Was wird getan?)\n• Objekt (Wen oder was?)\n\nBeispiel: 'Der Hund (Subjekt) beißt (Prädikat) den Ball (Objekt).'\n\nSoll ich dir mehr über ein bestimmtes Satzglied erklären?"
        }
        return "Deutsch bietet so viele spannende Themen! Brauchst du Hilfe bei Grammatik, Rechtschreibung, Textanalyse oder beim Schreiben? ✏️"
    }
    
    // Englisch-spezifische Antworten
    if let subject = subject, subject == .englisch || lowercaseMessage.contains("englisch") || lowercaseMessage.contains("english") {
        if lowercaseMessage.contains("past") || lowercaseMessage.contains("vergangenheit") {
            return "Das Simple Past ist eine wichtige Zeitform! ⏰\n\nRegelmäßige Verben: Grundform + -ed\n• play → played\n• work → worked\n\nUnregelmäßige Verben musst du auswendig lernen:\n• go → went\n• see → saw\n• have → had\n\nMöchtest du ein paar Beispielsätze sehen?"
        }
        return "English is fun! How can I help you today? Grammar, vocabulary, or maybe you want to practice conversation? 🇬🇧"
    }
    
    // Hausaufgaben-Hilfe
    if lowercaseMessage.contains("hausaufgabe") || lowercaseMessage.contains("aufgabe") {
        return "Gerne helfe ich dir bei deinen Hausaufgaben! 📚\n\nSchicke mir einfach:\n• Das Fach\n• Die konkrete Aufgabe oder Frage\n• Was du nicht verstehst\n\nIch erkläre es dir Schritt für Schritt, damit du es selbst lösen kannst!"
    }
    
    // Allgemeine Hilfe
    if lowercaseMessage.contains("hilfe") || lowercaseMessage.contains("help") {
        return "Natürlich helfe ich dir gerne! 🤝\n\nIch kann dir bei folgenden Dingen helfen:\n• Erklärungen zu Schulthemen\n• Hausaufgaben besprechen\n• Übungen erstellen\n• Lernstrategien entwickeln\n• Prüfungsvorbereitung\n\nWas brauchst du?"
    }
    
    // Standard-Antwort
    return "Das ist eine interessante Frage! Lass mich dir dabei helfen. Könntest du mir etwas mehr Details geben, damit ich dir eine bessere Antwort geben kann? 🤔"
}

#Preview {
    AITutorView(userProfile: UserProfile(
        name: "Max Mustermann",
        bundesland: .bayern,
        schulform: .gymnasium,
        klassenstufe: 8,
        lieblingsfaecher: [.mathematik, .englisch, .biologie],
        schwierigeFaecher: [.deutsch],
        lernziele: []
    ))
}