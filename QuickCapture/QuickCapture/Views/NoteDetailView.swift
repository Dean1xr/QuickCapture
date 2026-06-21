import SwiftUI

struct NoteDetailView: View {

    @EnvironmentObject var store: DataStore
    @Environment(\.dismiss) private var dismiss

    @State private var note: Note
    @State private var showReminderPicker = false
    @State private var notificationsAllowed = false

    init(note: Note) {
        _note = State(initialValue: note)
    }

    var body: some View {
        NavigationStack {
            Form {
                // ── Content editor ──────────────────────────
                Section("Note") {
                    TextEditor(text: $note.content)
                        .frame(minHeight: 120)
                }

                // ── Reminder ────────────────────────────────
                Section("Reminder") {
                    if notificationsAllowed {
                        Toggle("Set Reminder", isOn: Binding(
                            get: { note.reminderDate != nil },
                            set: { on in
                                if on {
                                    note.reminderDate = Calendar.current.date(
                                        byAdding: .hour, value: 1, to: Date())
                                } else {
                                    note.reminderDate = nil
                                }
                            }
                        ))

                        if note.reminderDate != nil {
                            DatePicker(
                                "Date & Time",
                                selection: Binding(
                                    get: { note.reminderDate ?? Date() },
                                    set: { note.reminderDate = $0 }
                                ),
                                in: Date()...,
                                displayedComponents: [.date, .hourAndMinute]
                            )
                        }
                    } else {
                        Text("Enable notifications in Settings → QuickCapture to set reminders.")
                            .font(.footnote)
                            .foregroundStyle(.secondary)

                        Button("Open Settings") {
                            if let url = URL(string: UIApplication.openSettingsURLString) {
                                UIApplication.shared.open(url)
                            }
                        }
                    }
                }

                // ── Metadata ─────────────────────────────────
                Section {
                    LabeledContent("Created", value: note.createdAt.formatted(date: .abbreviated, time: .shortened))
                }
            }
            .navigationTitle("Edit Note")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") { saveAndDismiss() }
                        .fontWeight(.semibold)
                }
            }
            .onAppear {
                ReminderManager.shared.checkPermission { allowed in
                    notificationsAllowed = allowed
                }
            }
        }
    }

    private func saveAndDismiss() {
        store.update(note)
        ReminderManager.shared.reschedule(for: note)
        dismiss()
    }
}
