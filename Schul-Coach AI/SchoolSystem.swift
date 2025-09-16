//
//  SchoolSystem.swift
//  Schul-Coach AI
//
//  Created by Ben Picha on 15.09.25.
//

import Foundation

// MARK: - Bundesländer
enum Bundesland: String, CaseIterable, Identifiable {
    case badenWuerttemberg = "Baden-Württemberg"
    case bayern = "Bayern"
    case berlin = "Berlin"
    case brandenburg = "Brandenburg"
    case bremen = "Bremen"
    case hamburg = "Hamburg"
    case hessen = "Hessen"
    case mecklenburgVorpommern = "Mecklenburg-Vorpommern"
    case niedersachsen = "Niedersachsen"
    case nordrheinWestfalen = "Nordrhein-Westfalen"
    case rheinlandPfalz = "Rheinland-Pfalz"
    case saarland = "Saarland"
    case sachsen = "Sachsen"
    case sachsenAnhalt = "Sachsen-Anhalt"
    case schleswigHolstein = "Schleswig-Holstein"
    case thueringen = "Thüringen"
    
    var id: String { rawValue }
}

// MARK: - Schulformen
enum Schulform: String, CaseIterable, Identifiable {
    case vorschule = "Vorschule"
    case grundschule = "Grundschule"
    case hauptschule = "Hauptschule"
    case realschule = "Realschule"
    case gesamtschule = "Gesamtschule"
    case gymnasium = "Gymnasium"
    case internatsschule = "Internatsschule"
    
    var id: String { rawValue }
    
    var availableGrades: [Int] {
        switch self {
        case .vorschule:
            return [0] // Vorschulklasse
        case .grundschule:
            return [1, 2, 3, 4]
        case .hauptschule:
            return [5, 6, 7, 8, 9, 10]
        case .realschule:
            return [5, 6, 7, 8, 9, 10]
        case .gesamtschule:
            return [5, 6, 7, 8, 9, 10, 11, 12, 13]
        case .gymnasium:
            return [5, 6, 7, 8, 9, 10, 11, 12, 13]
        case .internatsschule:
            return [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13]
        }
    }
    
    var icon: String {
        switch self {
        case .vorschule: return "teddybear.fill"
        case .grundschule: return "abc"
        case .hauptschule: return "hammer.fill"
        case .realschule: return "building.2.fill"
        case .gesamtschule: return "building.columns.fill"
        case .gymnasium: return "graduationcap.fill"
        case .internatsschule: return "house.lodge.fill"
        }
    }
}

// MARK: - Schulfächer
enum Schulfach: String, CaseIterable, Identifiable {
    // Kernfächer
    case deutsch = "Deutsch"
    case mathematik = "Mathematik"
    case englisch = "Englisch"
    
    // Fremdsprachen
    case franzoesisch = "Französisch"
    case spanisch = "Spanisch"
    case italienisch = "Italienisch"
    case russisch = "Russisch"
    case latein = "Latein"
    case griechisch = "Griechisch"
    
    // Gesellschaftswissenschaften
    case geschichte = "Geschichte"
    case erdkunde = "Erdkunde/Geografie"
    case politik = "Politik/Sozialwissenschaften"
    case wirtschaft = "Wirtschaft"
    
    // Naturwissenschaften
    case biologie = "Biologie"
    case chemie = "Chemie"
    case physik = "Physik"
    case informatik = "Informatik"
    
    // Weitere Fächer
    case religion = "Religion/Ethik"
    case kunst = "Kunst"
    case musik = "Musik"
    case sport = "Sport"
    case sachunterricht = "Sachunterricht"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .deutsch: return "textformat.abc"
        case .mathematik: return "function"
        case .englisch: return "globe"
        case .franzoesisch, .spanisch, .italienisch, .russisch: return "globe.europe.africa"
        case .latein, .griechisch: return "scroll"
        case .geschichte: return "clock.arrow.circlepath"
        case .erdkunde: return "map"
        case .politik: return "building.columns"
        case .wirtschaft: return "chart.line.uptrend.xyaxis"
        case .biologie: return "leaf"
        case .chemie: return "testtube.2"
        case .physik: return "atom"
        case .informatik: return "laptopcomputer"
        case .religion: return "book.closed"
        case .kunst: return "paintbrush"
        case .musik: return "music.note"
        case .sport: return "figure.run"
        case .sachunterricht: return "lightbulb"
        }
    }
    
    var color: String {
        switch self {
        case .deutsch: return "blue"
        case .mathematik: return "red"
        case .englisch: return "green"
        case .franzoesisch, .spanisch, .italienisch, .russisch: return "purple"
        case .latein, .griechisch: return "brown"
        case .geschichte: return "orange"
        case .erdkunde: return "teal"
        case .politik: return "indigo"
        case .wirtschaft: return "yellow"
        case .biologie: return "mint"
        case .chemie: return "cyan"
        case .physik: return "pink"
        case .informatik: return "gray"
        case .religion: return "secondary"
        case .kunst: return "primary"
        case .musik: return "purple"
        case .sport: return "orange"
        case .sachunterricht: return "yellow"
        }
    }
    
    func isAvailableFor(schulform: Schulform, grade: Int) -> Bool {
        switch self {
        case .sachunterricht:
            return schulform == .grundschule || schulform == .vorschule
        case .latein, .griechisch:
            return (schulform == .gymnasium || schulform == .gesamtschule) && grade >= 6
        case .franzoesisch, .spanisch, .italienisch, .russisch:
            return grade >= 6 || (schulform == .grundschule && grade >= 3)
        case .physik, .chemie:
            return grade >= 7
        case .biologie:
            return grade >= 5
        case .informatik:
            return grade >= 7
        case .politik, .wirtschaft:
            return grade >= 8
        default:
            return true
        }
    }
}

// MARK: - Benutzermodell
struct UserProfile: Codable, Identifiable {
    let id = UUID()
    var name: String
    var bundesland: Bundesland
    var schulform: Schulform
    var klassenstufe: Int
    var lieblingsfaecher: [Schulfach]
    var schwierigeFaecher: [Schulfach]
    var lernziele: [String]
    var isPremium: Bool = false
    var createdAt: Date = Date()
    
    var availableSubjects: [Schulfach] {
        return Schulfach.allCases.filter { subject in
            subject.isAvailableFor(schulform: schulform, grade: klassenstufe)
        }
    }
}

// MARK: - Lerninhalt
struct LernInhalt: Identifiable, Codable {
    let id = UUID()
    let titel: String
    let beschreibung: String
    let fach: Schulfach
    let klassenstufe: Int
    let schwierigkeit: Schwierigkeit
    let typ: InhaltTyp
    let bundesland: Bundesland?
    let inhalt: String
    let beispiele: [String]
    let uebungen: [Uebung]
    
    enum Schwierigkeit: String, CaseIterable, Codable {
        case leicht = "Leicht"
        case mittel = "Mittel"
        case schwer = "Schwer"
    }
    
    enum InhaltTyp: String, CaseIterable, Codable {
        case erklaerung = "Erklärung"
        case uebung = "Übung"
        case spiel = "Spiel"
        case quiz = "Quiz"
        case hausaufgabe = "Hausaufgabe"
    }
}

// MARK: - Übungen
struct Uebung: Identifiable, Codable {
    let id = UUID()
    let frage: String
    let antwortmoeglichkeiten: [String]?
    let richtigeAntwort: String
    let erklaerung: String
    let punkte: Int
}

// MARK: - Lernfortschritt
struct LernFortschritt: Identifiable, Codable {
    let id = UUID()
    let userId: UUID
    let fach: Schulfach
    let thema: String
    var fortschritt: Double // 0.0 - 1.0
    var punkte: Int
    var abgeschlosseneUebungen: [UUID]
    var lastUpdated: Date
}