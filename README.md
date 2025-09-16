# 🎓 Schul-Coach AI

Eine umfassende iOS-App für personalisierte Lernunterstützung im deutschen Bildungssystem.

## 📱 Überblick

Schul-Coach AI ist eine innovative Lern-App, die KI-gestützte Nachhilfe für alle deutschen Schulformen und Klassenstufen bietet. Von der Vorschule bis zum Abitur - die App passt sich an den jeweiligen Lehrplan und die individuellen Bedürfnisse der Schüler an.

## ✨ Hauptfunktionen

### 🤖 KI-Tutor
- **Personalisierte Lernhilfe**: Intelligente Unterstützung für alle Schulfächer
- **Interaktiver Chat**: Fragen stellen und sofortige Antworten erhalten
- **Fachspezifische Hilfe**: Angepasst an Klassenstufe und Bundesland

### 🎮 Interaktive Lernspiele
- **Altersgerechte Spiele**: Besonders für Grundschüler entwickelt
- **Verschiedene Kategorien**: Mathematik, Sprache, Wissen und Gedächtnis
- **Motivationssystem**: Punkte, Abzeichen und Erfolge

### 📚 Fächervielfalt
- **Kernfächer**: Deutsch, Mathematik, Englisch
- **Fremdsprachen**: Französisch, Spanisch, Latein, etc.
- **Naturwissenschaften**: Biologie, Chemie, Physik
- **Geisteswissenschaften**: Geschichte, Erdkunde, Politik
- **Weitere Fächer**: Religion, Kunst, Musik, Sport

### 📊 Fortschritts-Tracking
- **Detaillierte Statistiken**: Lernzeit, gelöste Aufgaben, Punkte
- **Lernstreak**: Motivation durch tägliche Aktivität
- **Eltern-Dashboard**: Übersicht für Eltern über den Lernfortschritt

### 🏫 Deutsches Schulsystem
- **Alle Schulformen**: Grundschule, Gymnasium, Realschule, etc.
- **Bundeslandspezifisch**: Angepasst an regionale Lehrpläne
- **Klassenstufen**: Von Klasse 1 bis Abitur

## 🎯 Zielgruppen

### Schüler (Primärzielgruppe)
- Vorschule bis Abitur
- Alle Schulformen
- Individuelle Lernunterstützung

### Eltern
- Fortschritts-Monitoring
- Hausaufgaben-Unterstützung
- Familienaccounts

### Schulen
- Klassenlizenzen
- Lehrertools
- Curriculum-Integration

## 💰 Monetarisierung

### Freemium-Modell
- **Kostenlos**: Grundfunktionen, begrenzte Nutzung
- **Premium**: 10-15€/Monat oder 90€/Jahr
- **Schul-Accounts**: Spezielle Tarife für Bildungseinrichtungen

### Premium-Features
- Unbegrenzter Zugang zu allen Inhalten
- Erweiterte KI-Funktionen
- Premium-Lernspiele
- Detaillierte Berichte
- Familienaccounts (bis zu 4 Kinder)

## 🏗️ Technische Architektur

### Frontend
- **SwiftUI**: Moderne iOS-Entwicklung
- **MVVM-Architektur**: Saubere Code-Struktur
- **Responsive Design**: Optimiert für iPhone und iPad

### Datenmodelle
- **UserProfile**: Benutzer-spezifische Daten
- **SchoolSystem**: Deutsche Schulformen und Bundesländer
- **LearningContent**: Strukturierte Lerninhalte
- **Progress Tracking**: Fortschritts-Verfolgung

### Features
- **Offline-Fähigkeit**: Grundfunktionen ohne Internet
- **Datenschutz**: DSGVO-konform
- **Barrierefreiheit**: Unterstützung für alle Benutzer

## 🎨 Design-Prinzipien

### Benutzerfreundlichkeit
- **Intuitive Navigation**: Einfache Bedienung für alle Altersgruppen
- **Kinderfreundlich**: Bunte, ansprechende Gestaltung
- **Accessibility**: Unterstützung für verschiedene Bedürfnisse

### Motivation
- **Gamification**: Punkte, Abzeichen, Streaks
- **Positive Verstärkung**: Ermutigendes Feedback
- **Personalisierung**: Angepasst an individuelle Vorlieben

## 🌍 Lokalisierung

### Vollständig deutsche App
- **Sprache**: Komplett auf Deutsch
- **Kultur**: Angepasst an deutsche Bildungskultur
- **Lehrpläne**: Bundeslandspezifische Inhalte

## 🚀 Installation & Entwicklung

### Voraussetzungen
- Xcode 15.0+
- iOS 17.0+
- Swift 5.9+

### Setup
```bash
git clone https://github.com/BenP870902/Schul-Coach-AI.git
cd Schul-Coach-AI
open "Schul-Coach AI.xcodeproj"
```

### Projektstruktur
```
Schul-Coach AI/
├── Models/
│   └── SchoolSystem.swift          # Datenmodelle
├── Views/
│   ├── OnboardingView.swift        # Benutzer-Onboarding
│   ├── MainTabView.swift           # Hauptnavigation
│   ├── HomeView.swift              # Startbildschirm
│   ├── SubjectsView.swift          # Fächer-Übersicht
│   ├── AITutorView.swift           # KI-Chat
│   ├── GamesView.swift             # Lernspiele
│   ├── ProgressView.swift          # Fortschritt
│   └── ProfileView.swift           # Benutzerprofil
├── Assets.xcassets/                # App-Icons und Bilder
├── de.lproj/
│   └── Localizable.strings         # Deutsche Übersetzungen
└── Info.plist                     # App-Konfiguration
```

## 📈 Roadmap

### Phase 1 (MVP) ✅
- [x] Grundlegende App-Struktur
- [x] Benutzer-Onboarding
- [x] KI-Chat Interface
- [x] Lernspiele für Grundschüler
- [x] Fortschritts-Tracking
- [x] Premium-Features

### Phase 2 (Erweiterung)
- [ ] Echte KI-Integration (OpenAI/Claude API)
- [ ] Erweiterte Lernspiele
- [ ] Offline-Inhalte
- [ ] Eltern-App
- [ ] Apple Watch Integration

### Phase 3 (Skalierung)
- [ ] Android-Version
- [ ] Web-Dashboard
- [ ] Schulpartner-Programm
- [ ] Internationale Expansion

## 🤝 Beitragen

Wir freuen uns über Beiträge! Bitte lesen Sie unsere Beitragsrichtlinien und öffnen Sie Issues oder Pull Requests.

## 📄 Lizenz

Dieses Projekt ist unter der MIT-Lizenz lizenziert - siehe [LICENSE](LICENSE) für Details.

## 📞 Kontakt

- **Entwickler**: Ben Picha
- **GitHub**: [@BenP870902](https://github.com/BenP870902)
- **Projekt**: [Schul-Coach AI](https://github.com/BenP870902/Schul-Coach-AI)

---

**Schul-Coach AI** - Intelligentes Lernen für das deutsche Bildungssystem 🇩🇪