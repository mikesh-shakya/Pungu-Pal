import SwiftUI
import SwiftData

@main
struct PunguPalApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: FoodEntry.self)
    }
}
