//
//  ShaderPreviewApp.swift
//  Shared
//
//  Created by yinglun on 2020/12/9.
//

import SwiftUI

@main
struct ShaderPreviewApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: ImageRenderer())
        }
        .commands {
            CommandGroup(after: .saveItem) {
                Button("Save") {
                    NotificationCenter.default.post(name: Notification.Name("ShaderPreview.Save"), object: nil)
                }.keyboardShortcut("s")
            }
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
