import SwiftUI

/// The application entry point.  Creates the `GameViewModel` once and injects
/// it into the environment for all child views to consume.
@main
struct ImpostorGameApp: App {
    @StateObject private var viewModel = GameViewModel()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}