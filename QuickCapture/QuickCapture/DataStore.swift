import Foundation
import WidgetKit

/// Shared storage between the app and widget via App Group.
final class DataStore: ObservableObject {

    static let shared = DataStore()

    // Must match the entitlements file.
    static let appGroupID = "group.com.dean.quickcapture"
    static let notesKey   = "qc_notes"

    @Published var notes: [Note] = []

    private var defaults: UserDefaults? {
        UserDefaults(suiteName: Self.appGroupID)
    }

    private init() {
        load()
    }

    // MARK: - CRUD

    func addNote(content: String) {
        guard !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        let note = Note(content: content)
        notes.insert(note, at: 0)
        save()
    }

    func update(_ note: Note) {
        if let idx = notes.firstIndex(where: { $0.id == note.id }) {
            notes[idx] = note
            save()
        }
    }

    func delete(_ note: Note) {
        notes.removeAll { $0.id == note.id }
        save()
    }

    func delete(at offsets: IndexSet) {
        notes.remove(atOffsets: offsets)
        save()
    }

    func togglePin(_ note: Note) {
        var updated = note
        updated.isPinned.toggle()
        update(updated)
        // Re-sort: pinned notes first
        notes.sort { $0.isPinned && !$1.isPinned }
        save()
    }

    // MARK: - Persistence

    private func save() {
        guard let data = try? JSONEncoder().encode(notes) else { return }
        defaults?.set(data, forKey: Self.notesKey)
        WidgetCenter.shared.reloadAllTimelines()
    }

    func load() {
        guard
            let data = defaults?.data(forKey: Self.notesKey),
            let decoded = try? JSONDecoder().decode([Note].self, from: data)
        else { return }
        notes = decoded
    }
}
