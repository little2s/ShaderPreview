//
//  ShaderPreviewApp.swift
//  Shared
//
//  Created by yinglun on 2020/12/9.
//

import SwiftUI

@main
struct ShaderPreviewApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(renderer: ImageRenderer())
        }
    }
}
