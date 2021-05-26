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
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        true
    }
}
