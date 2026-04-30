import SwiftUI
import SwiftData

@main
struct TickSnapApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: TimerPreset.self)
    }
}
