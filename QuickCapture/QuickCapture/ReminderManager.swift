import Foundation
import UserNotifications

final class ReminderManager {

    static let shared = ReminderManager()
    private init() {}

    // MARK: - Permission

    func requestPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, _ in
            DispatchQueue.main.async { completion(granted) }
        }
    }

    func checkPermission(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }

    // MARK: - Schedule / Cancel

    /// Schedule or reschedule a notification for a note.
    func schedule(for note: Note) {
        guard let date = note.reminderDate, date > Date() else { return }

        let content = UNMutableNotificationContent()
        content.title = "QuickCapture Reminder"
        content.body  = note.shortPreview
        content.sound = .default

        let components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        let trigger    = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request    = UNNotificationRequest(identifier: note.id.uuidString, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request)
    }

    /// Remove any pending notification for a note.
    func cancel(for note: Note) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [note.id.uuidString])
    }

    /// Remove then re-add (use after editing a note).
    func reschedule(for note: Note) {
        cancel(for: note)
        schedule(for: note)
    }
}
