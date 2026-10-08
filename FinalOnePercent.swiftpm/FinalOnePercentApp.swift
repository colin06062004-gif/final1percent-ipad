import SwiftUI
import AVFoundation

@main
struct FinalOnePercentApp: App {
    init() {
        // "Playback" is the music-app audio category: sound keeps going with the screen locked
        // (together with UIBackgroundModes = audio in AppInfo.plist) and ignores the mute switch.
        // Only the category is set here — WebKit activates the session once a video plays, so
        // opening the app doesn't stop other music that's already running.
        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
    }

    var body: some Scene {
        WindowGroup {
            WebAppView()
                .ignoresSafeArea()           // the page lays itself out around the notch (viewport-fit=cover)
                .preferredColorScheme(.dark) // light status bar text over the dark app
        }
    }
}
