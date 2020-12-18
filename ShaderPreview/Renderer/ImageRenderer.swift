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

class ImageRenderer: ObservableObject {
    
    struct InstructionError: LocalizedError {
        private let instruction: String
        var errorDescription: String? { instruction }
        init(_ instruction: String) { self.instruction = instruction }
    }
    @Published var error: Error?
    @Published var image: MTIImage?
    
    let context = try! MTIContext(device: MTLCreateSystemDefaultDevice()!)
    
    private var inputImages: [MTIImage] = []
    private var kernel: MTIRenderPipelineKernel?
        
    private let fileMonitor = FileMonitor()
    
    var clock = Clock()
    private var clockObserver: AnyCancellable?
    
    init() {
        ResourcesFolder.prepare()
        fileMonitor.start { [weak self] in
            self?.reload()
        }
        clockObserver = clock.$timeString.sink { [weak self] _ in
            self?.render()
        }
        reload()
    }
    
    private func reload() {
        reloadTextures(folderURL: ResourcesFolder.texturesFolderURL, prefix: ResourcesFolder.texturePrefix, extensions: ResourcesFolder.textureExtensions)
        reloadShader(url: ResourcesFolder.shaderURL)
        render()
    }
    
    private func reloadTextures(folderURL: URL, prefix: String, extensions: [String]) {
        func appendTexure(names: [String]) {
            for name in names {
                let url = folderURL.appendingPathComponent(name)
                if FileManager.default.fileExists(atPath: url.path),
                   let data = try? Data(contentsOf: url),
                   let cgImage = CGImage.makeImage(data: data) {
                    let mtiImage = MTIImage(cgImage: cgImage)
                    inputImages.append(mtiImage)
                    return
                }
            }
        }
        
        inputImages.removeAll()
        for i in 0 ..< 10 {
            let names = extensions.map { prefix + "\(i).\($0)" }
            appendTexure(names: names)
        }
    }
    
    private var textures: Int?
    private func reloadShader(url: URL) {
        func getTexturesCount(shaderString: String) -> Int? {
            guard let line = shaderString.components(separatedBy: "\n").first?.replacingOccurrences(of: "///", with: "") else {
                return nil
            }
            let pairs = line.components(separatedBy: ";")
            for pair in pairs {
                let item = pair.components(separatedBy: "=")
                if item.first == "textures", let s = item.last, let v = Int(s) {
                    return v
                }
            }
            return nil
        }
        
        guard let shaderString = try? String(contentsOfFile: url.path, encoding: .utf8) else { return }
        self.textures = getTexturesCount(shaderString: shaderString)
        let libraryURL = MTILibrarySourceRegistration.shared.registerLibrary(source: shaderString, compileOptions: nil)
        self.kernel = MTIRenderPipelineKernel(vertexFunctionDescriptor: MTIFunctionDescriptor.passthroughVertex, fragmentFunctionDescriptor: MTIFunctionDescriptor(name: "playFragment", libraryURL: libraryURL))
    }
    
    private func render() {
        guard let image = self.inputImages.first else {
            self.image = nil
            self.error = InstructionError("No Textures!")
            return
        }
        if let count = self.textures {
            if self.inputImages.count < count {
                self.image = nil
                self.error = InstructionError("Textures Inconsistency!")
                return
            }
        }
        self.image = kernel?.apply(toInputImages: inputImages, parameters: ["time": Float(clock.time)], outputDescriptors: [MTIRenderPassOutputDescriptor(dimensions: image.dimensions, pixelFormat: .unspecified)]).first
    }
    
}
