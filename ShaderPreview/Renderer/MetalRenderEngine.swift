//
//  MetalRenderEngine.swift
//  ShaderPreview
//
//  Created by yinglun on 2020/12/19.
//

import Foundation
import MetalPetal

class MetalRenderEngine: RenderEngine {
    let name = "Metal"
    
    let shaderURL = ResourcesFolder.shaderURL
    
    private let context = try! MTIContext(device: MTLCreateSystemDefaultDevice()!)
    private var kernel: MTIRenderPipelineKernel?
    
    private var requiredTexturesCount: Int?
    func reloadShader() {
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
        
        guard let shaderString = try? String(contentsOfFile: shaderURL.path, encoding: .utf8) else { return }
        self.requiredTexturesCount = getTexturesCount(shaderString: shaderString)
        let libraryURL = MTILibrarySourceRegistration.shared.registerLibrary(source: shaderString, compileOptions: nil)
        self.kernel = MTIRenderPipelineKernel(vertexFunctionDescriptor: MTIFunctionDescriptor.passthroughVertex, fragmentFunctionDescriptor: MTIFunctionDescriptor(name: "playFragment", libraryURL: libraryURL))
    }
    
    func render(textures: [CGImage], time: TimeInterval) throws -> CGImage {
        let inputImages = textures.map { MTIImage(cgImage: $0) }
        guard let image = inputImages.first else {
            throw InstructionError("No Textures!")
        }
        if let count = self.requiredTexturesCount {
            if inputImages.count < count {
                throw InstructionError("Textures Inconsistency!")
            }
        }
        guard let outputImage = kernel?.apply(toInputImages: inputImages, parameters: ["time": Float(time)], outputDescriptors: [MTIRenderPassOutputDescriptor(dimensions: image.dimensions, pixelFormat: .unspecified)]).first else {
            throw InstructionError("Apply kernel failed!")
        }
        
        let cgImage = try context.makeCGImage(from: outputImage)
        return cgImage
    }
    
}
