import SwiftUI

struct RemindersListView: View {

    @EnvironmentObject var store: DataStore
    @State private var selectedNote: Note?

    var notesWithReminders: [Note] {
        store.notes
            .filter { $0.reminderDate != nil }
            .sorted { ($0.reminderDate ?? .distantFuture) < ($1.reminderDate ?? .distantFuture) }
    }

    var body: some View {
        NavigationStack {
            Group {
                if notesWithReminders.isEmpty {
                    ContentUnavailableView(
                        "No Reminders",
                        systemImage: "bell.slash",
                        description: Text("Open a note and set a reminder.")
                    )
                } else {
                    List {
                        ForEach(notesWithReminders) { note in
                            Button {
                                selectedNote = note
                            } label: {
                                VStack(alignment: .leading, spacing: 5) {
                                    Text(note.shortPreview)
                                        .font(.body)
                                        .fontWeight(.medium)
                                        .lineLimit(2)

                                    if let date = note.reminderDate {
                                        Label(
                                            date.formatted(date: .abbreviated, time: .shortened),
                                            systemImage: "bell.fill"
                                        )
                                        .font(.caption)
                                        .foregroundStyle(date < Date() ? .red : .indigo)
                                    }
                                }
                                .padding(.vertical, 4)
                            }
                            .tint(.primary)
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("Reminders")
            .sheet(item: $selectedNote) { note in
                NoteDetailView(note: note)
            }
        }
    }
}
