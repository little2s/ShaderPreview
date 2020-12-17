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
import SKQueue

struct ResourcesFolder {
    static let folderURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!.appendingPathComponent("com.meteor.shader-preview.resources")
    
    static let shaderURL: URL = folderURL.appendingPathComponent("demo.shader")
    static let textureURL = folderURL.appendingPathComponent("texture.jpg")
    
    static func createFolderIfNeeded() throws {
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            try FileManager.default.createDirectory(at: folderURL, withIntermediateDirectories: true, attributes: nil)
        }
    }
    
    static func clear() {
        DispatchQueue.global(qos: .background).async {
            try? FileManager.default.removeItem(at: folderURL)
        }
    }
}

class ImageRenderer: ObservableObject {
    
    @Published var image: MTIImage?
    
    let context = try! MTIContext(device: MTLCreateSystemDefaultDevice()!)
    
    private var inputImage: MTIImage?

    private var kernel: MTIRenderPipelineKernel?
    
    private var libraryURL: URL?
    
    class FileMonitor: SKQueueDelegate {
        var pathDidChange: ((String) -> Void)?
        func receivedNotification(_ notification: SKQueueNotification, path: String, queue: SKQueue) {
//            print("note: \(notification.toStrings()), path: \(path)")
            DispatchQueue.main.async {
                self.pathDidChange?(path)
            }
        }
    }
    
    private let fileMonitor = FileMonitor()
    private var queue: SKQueue?
    
    init() {
        try? ResourcesFolder.createFolderIfNeeded()
        
        try? FileManager.default.copyItem(at: Bundle.main.url(forResource: ResourcesFolder.shaderURL.lastPathComponent, withExtension: nil)!, to: ResourcesFolder.shaderURL)
        self.reload(shaderURL: ResourcesFolder.shaderURL)

        try? FileManager.default.copyItem(at: Bundle.main.url(forResource: ResourcesFolder.textureURL.lastPathComponent, withExtension: nil)!, to: ResourcesFolder.textureURL)
        self.replace(inputImage: CGImage.makeImage(data: try! Data(contentsOf: ResourcesFolder.textureURL))!)
        
        self.fileMonitor.pathDidChange = { path in
            if path.hasSuffix(ResourcesFolder.shaderURL.lastPathComponent) {
                self.reload(fileURL: ResourcesFolder.textureURL) {
                    self.reload(shaderURL: ResourcesFolder.shaderURL)
                }
            } else if path.hasSuffix(ResourcesFolder.textureURL.lastPathComponent) {
                self.reload(fileURL: ResourcesFolder.textureURL) {
                    if let data = try? Data(contentsOf: ResourcesFolder.textureURL) {
                        self.replace(inputImage: CGImage.makeImage(data: data)!)
                    }
                }
            }
        }
        
        let queue = SKQueue(delegate: fileMonitor)
        queue?.addPath(ResourcesFolder.shaderURL.path)
        queue?.addPath(ResourcesFolder.textureURL.path)
        self.queue = queue
    }
    
    private var timerTable: [URL: Timer] = [:]
    private func reload(fileURL: URL, action: @escaping () -> Void) {
        if FileManager.default.fileExists(atPath: fileURL.path) {
            action()
        } else {
            func stop() {
                timerTable[fileURL]?.invalidate()
                timerTable.removeValue(forKey: fileURL)
            }
            stop()
            let timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { (timer) in
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    stop()
                    self.queue?.removePath(fileURL.path)
                    self.queue?.addPath(fileURL.path)
                    action()
                }
            }
            timerTable[fileURL] = timer
        }
    }
    
    private func replace(inputImage: CGImage) {
        self.inputImage = MTIImage(cgImage: inputImage)
        self.reload(libraryURL: self.libraryURL)
    }
    
    private func reload(shaderURL: URL) {
        let libraryURL = MTILibrarySourceRegistration.shared.registerLibrary(source: try! String(contentsOfFile: shaderURL.path, encoding: .utf8), compileOptions: nil)
        self.reload(libraryURL: libraryURL)
    }
    
    private func reload(libraryURL: URL?) {
        self.libraryURL = libraryURL
        self.kernel = MTIRenderPipelineKernel(vertexFunctionDescriptor: MTIFunctionDescriptor.passthroughVertex, fragmentFunctionDescriptor: MTIFunctionDescriptor(name: "demoFragment", libraryURL: libraryURL))
        self.apply()
    }
    
    private func apply() {
        guard let inputImage = self.inputImage else {
            self.image = nil
            return
        }
        self.image = self.kernel?.apply(toInputImages: [inputImage], parameters: [:], outputDescriptors: [MTIRenderPassOutputDescriptor(dimensions: inputImage.dimensions, pixelFormat: .unspecified)]).first
    }
    
}
