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
    
    func reloadShader() {
        
    }
    
    func render(textures: [CGImage], time: TimeInterval) throws -> CGImage {
        throw InstructionError("Unimplement yet!")
    }
    
}
