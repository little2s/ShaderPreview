//
//  OpenGLRenderEngine.swift
//  ShaderPreview
//
//  Created by yinglun on 2020/12/19.
//

import Foundation
import GPUImage

class OpenGLRenderEngine: RenderEngine {
    let name = "OpenGL"

    let shaderURL = ResourcesFolder.glShaderURL
    
    private let vertexShaderString = "attribute vec4 position;\nattribute vec4 inputTextureCoordinate;\n\nvarying vec2 textureCoordinate;\n\nvoid main()\n{\n\tgl_Position = position;\n\ttextureCoordinate = inputTextureCoordinate.xy;\n}\n"
    private var fragmentShaderString: String?
    private var complieLog: String?
    func reloadShader() throws -> String {
        let shaderString = try String(contentsOfFile: shaderURL.path, encoding: .utf8)
        var compilationFailed = false
        runSynchronouslyOnVideoProcessingQueue {
            GPUImageContext.useImageProcessingContext()
            if let filterProgram = GLProgram(vertexShaderString: self.vertexShaderString, fragmentShaderString: shaderString) {
                if !filterProgram.initialized {
                    if !filterProgram.link() {
                        compilationFailed = true
                        self.complieLog = filterProgram.fragmentShaderLog
                    }
                }
            } else {
                compilationFailed = true
            }
        }
        self.fragmentShaderString = compilationFailed ? nil : shaderString
        return shaderString
    }
    
    func render(textures: [CGImage], time: TimeInterval) throws -> CGImage {
        guard let fragmentShaderString = self.fragmentShaderString else {
            throw InstructionError(complieLog ?? "Compile GL shader failed!")
        }
        
        let textures = textures.prefix(6)
        guard !textures.isEmpty else {
            throw InstructionError("No Textures!")
        }
        
        let filter = try makeFilter(count: textures.count, fragmentShaderString: fragmentShaderString)

        var inputImages: [GPUImagePicture] = []
        for (index, texture) in textures.enumerated() {
            if let image = GPUImagePicture(cgImage: texture) {
                inputImages.append(image)
                image.addTarget(filter, atTextureLocation: index)
            } else {
                throw InstructionError("Read texture \(index) failed!")
            }
        }
        
        runSynchronouslyOnVideoProcessingQueue {
            let program = filter.shaderProgram()!
            let timeUniform = program.iUniformIndex("time")
            filter.setFloat(GLfloat(time), forUniform: GLint(timeUniform), program: program)
        }
        
        filter.useNextFrameForImageCapture()
        inputImages.forEach { $0.processImage() }
        
        guard let outputImage = filter.newCGImageFromCurrentlyProcessedOutput()?.takeRetainedValue() else {
            throw InstructionError("Failed to get image!")
        }
        
        let _ = inputImages//keep capture images
        
        return outputImage
    }
    
    private func makeFilter(count: Int, fragmentShaderString: String) throws -> GPUImageFilter {
        guard count <= 6 else {
            throw InstructionError("Support six textures at most!")
        }
        switch count {
        case 1: return GPUImageFilter(vertexShaderFrom: vertexShaderString, fragmentShaderFrom: fragmentShaderString)
        case 2: return GPUImageTwoInputFilter(vertexShaderFrom: vertexShaderString, fragmentShaderFrom: fragmentShaderString)
        case 3: return GPUImageThreeInputFilter(vertexShaderFrom: vertexShaderString, fragmentShaderFrom: fragmentShaderString)
        case 4: return GPUImageFourInputFilter(vertexShaderFrom: vertexShaderString, fragmentShaderFrom: fragmentShaderString)
        case 5: return GPUImageFiveInputFilter(vertexShaderFrom: vertexShaderString, fragmentShaderFrom: fragmentShaderString)
        case 6: return GPUImageSixInputFilter(vertexShaderFrom: vertexShaderString, fragmentShaderFrom: fragmentShaderString)
        default: throw InstructionError("Unknown error!")
        }
    }
    
}
