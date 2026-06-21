import SwiftUI

@main
struct QuickCaptureApp: App {

    @StateObject private var store = DataStore.shared

    init() {
        // Ask for notification permission at launch
        ReminderManager.shared.requestPermission { _ in }
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
