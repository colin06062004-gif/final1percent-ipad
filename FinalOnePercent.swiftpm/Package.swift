// swift-tools-version: 5.9

// Swift Playgrounds app project for the App Store version of Final 1%.
// Prepared by hand in the layout Swift Playgrounds generates, with two additions its settings
// screen can't make: AppInfo.plist (background audio and the home-screen name — see that file)
// and the Web folder, which holds the actual app (copied from the repo root by
// tools/sync_playgrounds.py). Playgrounds may rewrite this file when settings change in its UI.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "Final1Percent",
    platforms: [
        .iOS("17.0")
    ],
    products: [
        .iOSApplication(
            name: "Final1Percent",
            targets: ["AppModule"],
            bundleIdentifier: "de.colingross.final1percent",   // never change after the first upload
            teamIdentifier: "W78U46ZRF4",
            displayVersion: "1.0",
            bundleVersion: "7",
            appIcon: .asset("AppIcon"),
            accentColor: .presetColor(.red),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight(.when(deviceFamilies: [.pad])),
                .landscapeLeft(.when(deviceFamilies: [.pad])),
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ],
            capabilities: [
                // the video import offers "record a video" too; these texts show when that's used
                .camera(purposeString: "Damit du ein Video direkt aufnehmen und in deine Bibliothek laden kannst."),
                .microphone(purposeString: "Damit beim Aufnehmen eines Videos auch der Ton mit aufgenommen wird."),
                .photoLibrary(purposeString: "Damit du Videos und Cover-Bilder aus deiner Mediathek auswählen kannst.")
            ],
            additionalInfoPlistContentFilePath: "AppInfo.plist"
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: ".",
            exclude: ["AppInfo.plist"],
            resources: [
                .copy("Web")
            ]
        )
    ]
)
