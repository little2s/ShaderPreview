//
//  MetalPetalView.swift
//  MetalPetalDemo
//
//  Created by yinglun on 2020/6/28.
//  Copyright © 2020 meteor. All rights reserved.
//

import SwiftUI
import MetalPetal

struct MetalPetalView: NSViewRepresentable {
    
    var colorPixelFormat: MTLPixelFormat = .bgra8Unorm
    
    var clearColor: MTLClearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    var resizingMode: MTIDrawableRenderingResizingMode = .aspect
    
    let mtiContext: MTIContext
    
    @Binding var mtiImage: MTIImage?
    
    let errorHandler: ((Error?) -> Void)?
    
    typealias NSViewType = MTKView
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(view: self, errorHandler: errorHandler)
    }

    func makeNSView(context: Context) -> MTKView {
        let mtkView = MTKView()
        mtkView.device = mtiContext.device
        mtkView.delegate = context.coordinator
        return mtkView
    }
    
    func updateNSView(_ nsView: MTKView, context: Context) {
        
    }
    
    class Coordinator: NSObject, MTKViewDelegate {
        let view: MetalPetalView
        let errorHandler: ((Error?) -> Void)?
        
        init(view: MetalPetalView, errorHandler: ((Error?) -> Void)?) {
            self.view = view
            self.errorHandler = errorHandler
            super.init()
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            
        }
        
        func draw(in view: MTKView) {
            guard let image = self.view.mtiImage else { return }
            let request = MTIDrawableRenderingRequest(drawableProvider: view, resizingMode: .aspect)
            do {
                try self.view.mtiContext.render(image, toDrawableWithRequest: request)
                self.errorHandler?(nil)
            } catch {
                self.errorHandler?(error)
            }
        }
    }
    
}
