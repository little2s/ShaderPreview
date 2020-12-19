//
//  ImageRenderer.swift
//  MetalPetalDemo
//
//  Created by yinglun on 2020/6/28.
//  Copyright © 2020 meteor. All rights reserved.
//

import SwiftUI
import Combine
import MetalPetal

protocol RenderEngine: class {
    var name: String { get }
    var shaderURL: URL { get }
    
    func reloadShader()
    func render(textures: [CGImage], time: TimeInterval) throws -> CGImage
}

class ImageRenderer: ObservableObject {
    
    @Published var engineName: String = ""
    private(set) var engine: RenderEngine {
        didSet {
            engineName = engine.name
            clock.pause()
            resetFileMonitor()
            reload()
        }
    }
    
    @Published var errorDescription: String = ""
    @Published var errorLog: String = ""
    private(set) var error: Error? {
        didSet {
            errorLog = error?.localizedDescription ?? ""
            errorDescription = errorLog.isEmpty ? "0" : errorLog.replacingOccurrences(of: "\n", with: "")
            if error != nil {
                clock.pause()
            }
        }
    }
    
    @Published var image: NSImage?
                
    private let fileMonitor = FileMonitor()
    
    var clock = Clock()
    private var clockObserver: AnyCancellable?
    
    init() {
        self.engine = MetalRenderEngine()
        self.engineName = engine.name
        
        ResourcesFolder.prepare()
        
        clockObserver = clock.$timeString.sink { [weak self] _ in
            self?.render()
        }
        
        resetFileMonitor()
        reload()
    }
    
    func toggleEngine() {
        if engine is MetalRenderEngine {
            engine = OpenGLRenderEngine()
        } else {
            engine = MetalRenderEngine()
        }
    }
    
    private func resetFileMonitor() {
        fileMonitor.start(URLs: [engine.shaderURL, ResourcesFolder.texturesFolderURL]) { [weak self] in
            self?.reload()
        }
    }
    
    private func reload() {
        reloadTextures(folderURL: ResourcesFolder.texturesFolderURL, prefix: ResourcesFolder.texturePrefix, extensions: ResourcesFolder.textureExtensions)
        engine.reloadShader()
        render()
    }
    
    private var textures: [CGImage] = []
    private func reloadTextures(folderURL: URL, prefix: String, extensions: [String]) {
        func appendTexure(names: [String]) {
            for name in names {
                let url = folderURL.appendingPathComponent(name)
                if FileManager.default.fileExists(atPath: url.path),
                   let data = try? Data(contentsOf: url),
                   let cgImage = CGImage.makeImage(data: data) {
                    textures.append(cgImage)
                    return
                }
            }
        }
        
        textures.removeAll()
        for i in 0 ..< 10 {
            let names = extensions.map { prefix + "\(i).\($0)" }
            appendTexure(names: names)
        }
    }
    
    private func render() {
        do {
            let cgImage = try engine.render(textures: textures, time: clock.time)
            self.image = NSImage(cgImage: cgImage, size: NSSize(width: cgImage.width, height: cgImage.height))
            self.error = nil
        } catch {
            self.error = error
        }
    }
    
}
