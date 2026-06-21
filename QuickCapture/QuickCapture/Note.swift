import Foundation

struct Note: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var content: String
    var createdAt: Date = Date()
    var reminderDate: Date?
    var isPinned: Bool = false

    var shortPreview: String {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        let firstLine = trimmed.components(separatedBy: "\n").first ?? trimmed
        return firstLine.isEmpty ? "Empty note" : firstLine
    }

    var timeAgo: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: createdAt, relativeTo: Date())
    }
}
