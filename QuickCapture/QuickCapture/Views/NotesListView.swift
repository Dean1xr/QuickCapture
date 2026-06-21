import SwiftUI

struct NotesListView: View {

    @EnvironmentObject var store: DataStore
    @State private var searchText = ""
    @State private var selectedNote: Note?

    var filtered: [Note] {
        if searchText.isEmpty { return store.notes }
        return store.notes.filter {
            $0.content.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        NavigationStack {
            Group {
                if store.notes.isEmpty {
                    ContentUnavailableView(
                        "No Notes Yet",
                        systemImage: "note.text",
                        description: Text("Tap Capture to add your first note.")
                    )
                } else {
                    List {
                        ForEach(filtered) { note in
                            Button {
                                selectedNote = note
                            } label: {
                                NoteRow(note: note)
                            }
                            .tint(.primary)
                            .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                Button(role: .destructive) {
                                    store.delete(note)
                                    ReminderManager.shared.cancel(for: note)
                                } label: {
                                    Label("Delete", systemImage: "trash")
                                }
                            }
                            .swipeActions(edge: .leading) {
                                Button {
                                    store.togglePin(note)
                                } label: {
                                    Label(note.isPinned ? "Unpin" : "Pin",
                                          systemImage: note.isPinned ? "pin.slash" : "pin")
                                }
                                .tint(.orange)
                            }
                        }
                        .onDelete { offsets in
                            let toDelete = offsets.map { filtered[$0] }
                            toDelete.forEach { ReminderManager.shared.cancel(for: $0) }
                            store.delete(at: offsets)
                        }
                    }
                    .listStyle(.insetGrouped)
                    .searchable(text: $searchText, prompt: "Search notes")
                }
            }
            .navigationTitle("Notes")
            .sheet(item: $selectedNote) { note in
                NoteDetailView(note: note)
            }
        }
    }
}

// MARK: - Row

private struct NoteRow: View {
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(alignment: .top) {
                Text(note.shortPreview)
                    .font(.body)
                    .fontWeight(.medium)
                    .lineLimit(2)

                Spacer()

                if note.isPinned {
                    Image(systemName: "pin.fill")
                        .font(.caption)
                        .foregroundStyle(.orange)
                }
            }

            HStack {
                Text(note.timeAgo)
                    .font(.caption)
                    .foregroundStyle(.secondary)

                if note.reminderDate != nil {
                    Image(systemName: "bell.fill")
                        .font(.caption)
                        .foregroundStyle(.indigo)
                }
            }
        }
        .padding(.vertical, 4)
    }
}
