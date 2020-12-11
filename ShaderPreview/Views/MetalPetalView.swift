//
//  MetalPetalView.swift
//  MetalPetalDemo
//
//  Created by yinglun on 2020/6/28.
//  Copyright © 2020 meteor. All rights reserved.
//

import SwiftUI
import MetalPetal

#if canImport(UIKit)
struct MetalPetalView: UIViewRepresentable {
    
    var colorPixelFormat: MTLPixelFormat = .bgra8Unorm
    
    var clearColor: MTLClearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    var resizingMode: MTIDrawableRenderingResizingMode = .aspect
    
    let mtiContext: MTIContext
    
    @Binding var mtiImage: MTIImage?

    typealias UIViewType = MTIImageView
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }

    func makeUIView(context: Context) -> MTIImageView {
        let imageView = MTIImageView()
        imageView.colorPixelFormat = colorPixelFormat
        imageView.clearColor = clearColor
        imageView.resizingMode = resizingMode
        imageView.context = mtiContext
        imageView.image = mtiImage
        return imageView
    }
    
    func updateUIView(_ uiView: MTIImageView, context: Context) {
        uiView.colorPixelFormat = colorPixelFormat
        uiView.clearColor = clearColor
        uiView.resizingMode = resizingMode
        uiView.image = mtiImage
    }

    struct Coordinator {
        
    }

}
#endif

#if canImport(AppKit)
struct MetalPetalView: NSViewRepresentable {
    
    var colorPixelFormat: MTLPixelFormat = .bgra8Unorm
    
    var clearColor: MTLClearColor = MTLClearColor(red: 0, green: 0, blue: 0, alpha: 1)
    
    var resizingMode: MTIDrawableRenderingResizingMode = .aspect
    
    let mtiContext: MTIContext
    
    @Binding var mtiImage: MTIImage?
    
    typealias NSViewType = MTKView
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(view: self)
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
        
        init(view: MetalPetalView) {
            self.view = view
            super.init()
        }
        
        func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
            
        }
        
        func draw(in view: MTKView) {
            guard let image = self.view.mtiImage else { return }
            let request = MTIDrawableRenderingRequest(drawableProvider: view, resizingMode: .aspect)
            do {
                try self.view.mtiContext.render(image, toDrawableWithRequest: request)
            } catch {
                print(error)
            }
        }
    }
    
}
#endif
