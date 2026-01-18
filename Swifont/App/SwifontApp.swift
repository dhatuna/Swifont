//
//  SwifontApp.swift
//  Swifont
//
//  Created by JK on 12/1/26.
//

import SwiftUI
import UniformTypeIdentifiers

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

@main
struct SwifontApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            MainView(viewModel: DependencyContainer.shared.makeFontAnalyzerViewModel())
        }
        .windowStyle(.automatic)
        .windowResizability(.contentMinSize)
        .commands {
            CommandGroup(replacing: .newItem) {
                Button(LocalisedString.Menu.open) {
                    openFontFiles()
                }
                .keyboardShortcut("o", modifiers: .command)
            }

            CommandGroup(replacing: .help) {
                Button(LocalisedString.Menu.about) {
                    showAbout()
                }
            }
        }
    }

    private func openFontFiles() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.canChooseDirectories = false
        panel.canChooseFiles = true
        panel.allowedContentTypes = [.font]
        panel.message = LocalisedString.Dialog.selectFonts

        panel.begin { response in
            if response == .OK {
                NotificationCenter.default.post(
                    name: .fontFilesSelected,
                    object: panel.urls
                )
            }
        }
    }

    private func showAbout() {
        let alert = NSAlert()
        alert.messageText = LocalisedString.About.title
        alert.informativeText = """
        \(LocalisedString.About.description)

        \(LocalisedString.App.version)

        \(LocalisedString.About.features)

        \(LocalisedString.App.copyright)
        """
        alert.alertStyle = .informational
        alert.addButton(withTitle: LocalisedString.About.ok)
        alert.runModal()
    }
}

// MARK: - Notification Names
extension Notification.Name {
    static let fontFilesSelected = Notification.Name("fontFilesSelected")
}
