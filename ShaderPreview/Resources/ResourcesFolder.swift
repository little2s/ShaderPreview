//
//  ResourcesFolder.swift
//  ShaderPreview
//
//  Created by yinglun on 2020/12/18.
//

import Foundation

struct ResourcesFolder {
    static let folderURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent("com.meteor.shader-preview.resources")
    
    static let shaderURL = folderURL.appendingPathComponent("play.shader")
    static let glShaderURL = folderURL.appendingPathComponent("playgl.shader")
    
    static let texturesFolderURL = folderURL.appendingPathComponent("textures")
    static let texturePrefix = "texture-"
    static let textureExtensions = ["jpg", "png"]
    
    static func prepare() {
        try? createFolderIfNeeded()
        if !FileManager.default.fileExists(atPath: shaderURL.path) {
            try? FileManager.default.copyItem(at: Bundle.main.url(forResource: shaderURL.lastPathComponent, withExtension: nil)!, to: shaderURL)
        }
        let placeholderTextureName = "texture-0.jpg"
        if !FileManager.default.fileExists(atPath: texturesFolderURL.appendingPathComponent(placeholderTextureName).path) {
            try? FileManager.default.copyItem(at: Bundle.main.url(forResource: placeholderTextureName, withExtension: nil)!, to: texturesFolderURL.appendingPathComponent(placeholderTextureName))
        }
    }
    
    static func clear() {
        DispatchQueue.global(qos: .background).async {
            try? FileManager.default.removeItem(at: folderURL)
        }
    }
    
    private static func createFolderIfNeeded() throws {
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        }
        if !FileManager.default.fileExists(atPath: texturesFolderURL.path) {
            try FileManager.default.createDirectory(at: texturesFolderURL, withIntermediateDirectories: true, attributes: nil)
        }
    }

}
