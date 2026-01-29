import Foundation
import SwiftUI

struct StickyNote: Codable, Equatable {
    var content: String
    var color: NoteColor
    
    init(content: String = "", color: NoteColor = .yellow) {
        self.content = content
        self.color = color
    }
}

enum NoteColor: String, Codable, CaseIterable {
    case yellow
    case pink
    case mint
    case lavender
    case peach
    case sky
    
    var color: Color {
        switch self {
        case .yellow: return Color(red: 1.0, green: 0.95, blue: 0.7)
        case .pink: return Color(red: 1.0, green: 0.85, blue: 0.9)
        case .mint: return Color(red: 0.8, green: 0.95, blue: 0.85)
        case .lavender: return Color(red: 0.9, green: 0.85, blue: 1.0)
        case .peach: return Color(red: 1.0, green: 0.9, blue: 0.8)
        case .sky: return Color(red: 0.85, green: 0.93, blue: 1.0)
        }
    }
    
    var darkAccent: Color {
        switch self {
        case .yellow: return Color(red: 0.7, green: 0.6, blue: 0.2)
        case .pink: return Color(red: 0.8, green: 0.4, blue: 0.5)
        case .mint: return Color(red: 0.3, green: 0.6, blue: 0.4)
        case .lavender: return Color(red: 0.5, green: 0.4, blue: 0.7)
        case .peach: return Color(red: 0.8, green: 0.5, blue: 0.3)
        case .sky: return Color(red: 0.3, green: 0.5, blue: 0.8)
        }
    }
}

@MainActor
class NoteStore: ObservableObject {
    @Published var note: StickyNote
    
    private let saveKey = "StickyNote"
    
    init() {
        if let data = UserDefaults.standard.data(forKey: saveKey),
           let savedNote = try? JSONDecoder().decode(StickyNote.self, from: data) {
            self.note = savedNote
        } else {
            self.note = StickyNote(
                content: "Welcome to StickyNote! 📝\n\nPaste your important strings here.\n\n• Click the menu bar icon to open\n• Use ⌘V to paste\n• Click outside to close",
                color: .yellow
            )
        }
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(note) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }
    
    func setColor(_ color: NoteColor) {
        note.color = color
        save()
    }
    
    func setContent(_ content: String) {
        note.content = content
        save()
    }
}
