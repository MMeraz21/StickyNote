import SwiftUI

struct StickyNoteView: View {
    @ObservedObject var noteStore: NoteStore
    
    var body: some View {
        VStack(spacing: 0) {
            // Header with color picker
            HeaderView(noteStore: noteStore)
            
            // The sticky note
            NoteCardView(noteStore: noteStore)
            
            // Footer
            FooterView()
        }
        .frame(minWidth: 200, minHeight: 150)
        .background(Color(NSColor.windowBackgroundColor))
    }
}

struct HeaderView: View {
    @ObservedObject var noteStore: NoteStore
    
    var body: some View {
        HStack {
            Text("Sticky Note")
                .font(.system(size: 16, weight: .semibold, design: .rounded))
                .foregroundColor(.primary)
            
            Spacer()
            
            // Color picker
            HStack(spacing: 6) {
                ForEach(NoteColor.allCases, id: \.self) { color in
                    ColorDot(
                        color: color,
                        isSelected: noteStore.note.color == color,
                        action: { noteStore.setColor(color) }
                    )
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}

struct ColorDot: View {
    let color: NoteColor
    let isSelected: Bool
    let action: () -> Void
    
    @State private var isHovering = false
    
    var body: some View {
        Button(action: action) {
            Circle()
                .fill(color.color)
                .frame(width: 18, height: 18)
                .overlay(
                    Circle()
                        .stroke(color.darkAccent, lineWidth: isSelected ? 2 : 0)
                )
                .overlay(
                    Circle()
                        .stroke(Color.black.opacity(0.2), lineWidth: 0.5)
                )
                .scaleEffect(isHovering ? 1.15 : 1.0)
        }
        .buttonStyle(.plain)
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.15)) {
                isHovering = hovering
            }
        }
    }
}

struct NoteCardView: View {
    @ObservedObject var noteStore: NoteStore
    @State private var editedContent: String
    @FocusState private var isFocused: Bool
    
    init(noteStore: NoteStore) {
        self.noteStore = noteStore
        self._editedContent = State(initialValue: noteStore.note.content)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Color strip at top
            Rectangle()
                .fill(noteStore.note.color.darkAccent)
                .frame(height: 4)
            
            // Note content
            TextEditor(text: $editedContent)
                .font(.system(size: 14, design: .rounded))
                .foregroundColor(.black)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .focused($isFocused)
                .padding(12)
                .onChange(of: editedContent) { _, newValue in
                    noteStore.setContent(newValue)
                }
                .onChange(of: noteStore.note.content) { _, newValue in
                    if editedContent != newValue {
                        editedContent = newValue
                    }
                }
        }
        .background(noteStore.note.color.color)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        .padding(12)
        .onTapGesture {
            isFocused = true
        }
    }
}

struct FooterView: View {
    var body: some View {
        HStack {
            Text("⌘V to paste • ⌘C to copy")
                .font(.system(size: 10, design: .rounded))
                .foregroundColor(.secondary)
            
            Spacer()
            
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                Text("Quit")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
            .onHover { hovering in
                if hovering {
                    NSCursor.pointingHand.push()
                } else {
                    NSCursor.pop()
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}
