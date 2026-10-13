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
    // the permission texts are translated in de.lproj / en.lproj (InfoPlist.strings); English below is the fallback
    defaultLocalization: "en",
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
            bundleVersion: "23",
            appIcon: .asset("AppIcon"),
            accentColor: .presetColor(.red),
            // iPhone only (an iPad still runs it in iPhone size, as iOS does with every iPhone app)
            supportedDeviceFamilies: [
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait
            ],
            capabilities: [
                // the video import offers "record a video" too; these texts show when that's used
                .camera(purposeString: "So you can record a video right away and add it to your library."),
                .microphone(purposeString: "So the sound is recorded too when you record a video."),
                .photoLibrary(purposeString: "So you can choose videos and cover images from your photo library."),
                // "Video sichern" in the share sheet of the download button in a video's settings
                .photoLibraryAdd(purposeString: "So you can save your stored videos back to your photos.")
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
