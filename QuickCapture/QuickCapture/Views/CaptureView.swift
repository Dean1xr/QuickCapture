import SwiftUI

struct CaptureView: View {

    @EnvironmentObject var store: DataStore
    @State private var text: String = ""
    @State private var isFocused: Bool = false
    @State private var savedFlash: Bool = false

    @FocusState private var fieldFocused: Bool

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {

                // ── Input area ────────────────────────────────
                ZStack(alignment: .topLeading) {
                    if text.isEmpty {
                        Text("What's on your mind?")
                            .foregroundStyle(.secondary)
                            .padding(.horizontal, 20)
                            .padding(.top, 20)
                    }

                    TextEditor(text: $text)
                        .focused($fieldFocused)
                        .padding(.horizontal, 16)
                        .padding(.top, 14)
                        .scrollContentBackground(.hidden)
                        .font(.body)
                        .frame(maxWidth: .infinity, maxHeight: 240)
                }
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color(.secondarySystemBackground))
                )
                .padding(.horizontal, 20)
                .padding(.top, 20)

                // ── Save button ───────────────────────────────
                Button(action: save) {
                    HStack {
                        Image(systemName: savedFlash ? "checkmark" : "arrow.down.circle.fill")
                        Text(savedFlash ? "Saved!" : "Save Note")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                        ? Color.secondary.opacity(0.3)
                        : Color.indigo)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
                .disabled(text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.horizontal, 20)
                .padding(.top, 14)

                Spacer()
            }
            .navigationTitle("Quick Capture")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                // Auto-focus keyboard when this tab is shown
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    fieldFocused = true
                }
            }
        }
    }

    private func save() {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        store.addNote(content: trimmed)
        text = ""
        withAnimation {
            savedFlash = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation { savedFlash = false }
        }
        fieldFocused = true   // keep keyboard up for rapid capture
    }
}
