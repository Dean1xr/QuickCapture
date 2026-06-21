import SwiftUI

struct ContentView: View {

    @EnvironmentObject var store: DataStore
    @State private var selectedTab = 0
    @State private var showCapture = false

    var body: some View {
        TabView(selection: $selectedTab) {
            CaptureView()
                .tabItem {
                    Label("Capture", systemImage: "plus.circle.fill")
                }
                .tag(0)

            NotesListView()
                .tabItem {
                    Label("Notes", systemImage: "note.text")
                }
                .tag(1)

            RemindersListView()
                .tabItem {
                    Label("Reminders", systemImage: "bell.fill")
                }
                .tag(2)
        }
        .tint(.indigo)
        // Support deep-link from widget: quickcapture://capture
        .onOpenURL { url in
            if url.host == "capture" {
                selectedTab = 0
            }
        }
    }
}
