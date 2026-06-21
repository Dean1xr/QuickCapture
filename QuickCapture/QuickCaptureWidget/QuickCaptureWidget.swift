import WidgetKit
import SwiftUI

// MARK: - Shared model (duplicated here to avoid cross-target dependency)

private struct WidgetNote: Codable {
    var id: UUID
    var content: String
    var createdAt: Date
    var reminderDate: Date?

    var shortPreview: String {
        let trimmed = content.trimmingCharacters(in: .whitespacesAndNewlines)
        return trimmed.components(separatedBy: "\n").first ?? trimmed
    }
}

// MARK: - Data loader

private func loadNotes() -> [WidgetNote] {
    guard
        let defaults = UserDefaults(suiteName: "group.com.dean.quickcapture"),
        let data     = defaults.data(forKey: "qc_notes"),
        let notes    = try? JSONDecoder().decode([WidgetNote].self, from: data)
    else { return [] }
    return notes
}

// MARK: - Timeline entry

struct QuickCaptureEntry: TimelineEntry {
    let date: Date
    let latestNote: String
    let noteCount: Int
    let hasReminder: Bool
}

// MARK: - Provider

struct QuickCaptureProvider: TimelineProvider {

    func placeholder(in context: Context) -> QuickCaptureEntry {
        QuickCaptureEntry(date: Date(), latestNote: "Tap to capture a note", noteCount: 0, hasReminder: false)
    }

    func getSnapshot(in context: Context, completion: @escaping (QuickCaptureEntry) -> Void) {
        completion(entry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<QuickCaptureEntry>) -> Void) {
        let e = entry()
        // Refresh every 15 minutes
        let next = Calendar.current.date(byAdding: .minute, value: 15, to: Date()) ?? Date()
        completion(Timeline(entries: [e], policy: .after(next)))
    }

    private func entry() -> QuickCaptureEntry {
        let notes = loadNotes()
        let latest = notes.first
        return QuickCaptureEntry(
            date: Date(),
            latestNote: latest?.shortPreview ?? "Nothing captured yet",
            noteCount: notes.count,
            hasReminder: latest?.reminderDate != nil
        )
    }
}

// MARK: - Deep-link URL

private let captureURL = URL(string: "quickcapture://capture")!

// MARK: - Lock screen rectangular widget

struct LockScreenRectangularView: View {
    let entry: QuickCaptureEntry

    var body: some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: "bolt.fill")
                .font(.caption)
            VStack(alignment: .leading, spacing: 2) {
                Text(entry.latestNote)
                    .font(.caption2)
                    .lineLimit(2)
                    .widgetAccentable()
                Text("\(entry.noteCount) note\(entry.noteCount == 1 ? "" : "s")")
                    .font(.system(size: 9))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
    }
}

// MARK: - Lock screen circular widget

struct LockScreenCircularView: View {
    let entry: QuickCaptureEntry

    var body: some View {
        ZStack {
            AccessoryWidgetBackground()
            VStack(spacing: 2) {
                Image(systemName: "bolt.fill")
                    .font(.title3)
                    .widgetAccentable()
                Text("\(entry.noteCount)")
                    .font(.caption2)
                    .fontWeight(.bold)
            }
        }
    }
}

// MARK: - Home screen small widget

struct HomeScreenSmallView: View {
    let entry: QuickCaptureEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Image(systemName: "bolt.fill")
                    .foregroundStyle(.indigo)
                Text("QuickCapture")
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                Spacer()
                if entry.hasReminder {
                    Image(systemName: "bell.fill")
                        .font(.caption2)
                        .foregroundStyle(.indigo)
                }
            }

            Spacer()

            Text(entry.latestNote)
                .font(.caption)
                .fontWeight(.medium)
                .lineLimit(4)

            Spacer()

            Text("\(entry.noteCount) note\(entry.noteCount == 1 ? "" : "s")")
                .font(.system(size: 10))
                .foregroundStyle(.secondary)
        }
        .padding(12)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
    }
}

// MARK: - Widget definition

struct QuickCaptureWidget: Widget {

    let kind = "QuickCaptureWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: QuickCaptureProvider()) { entry in
            widgetView(entry: entry)
                .widgetURL(captureURL)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .configurationDisplayName("QuickCapture")
        .description("Latest note & quick launcher")
        .supportedFamilies([
            .systemSmall,
            .accessoryRectangular,
            .accessoryCircular
        ])
    }

    @ViewBuilder
    private func widgetView(entry: QuickCaptureEntry) -> some View {
        // WidgetKit automatically picks the right view per family
        // via the @Environment(\.widgetFamily)
        WidgetFamilyAdaptiveView(entry: entry)
    }
}

private struct WidgetFamilyAdaptiveView: View {
    @Environment(\.widgetFamily) var family
    let entry: QuickCaptureEntry

    var body: some View {
        switch family {
        case .accessoryRectangular:
            LockScreenRectangularView(entry: entry)
        case .accessoryCircular:
            LockScreenCircularView(entry: entry)
        default:
            HomeScreenSmallView(entry: entry)
        }
    }
}

// MARK: - Bundle

@main
struct QuickCaptureWidgetBundle: WidgetBundle {
    var body: some Widget {
        QuickCaptureWidget()
    }
}
