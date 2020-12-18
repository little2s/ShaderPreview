//
//  CGImageExtension.swift
//  MetalPetalDemo
//
//  Created by yinglun on 2020/7/10.
//  Copyright © 2020 meteor. All rights reserved.
//

import CoreGraphics

#if canImport(UIKit)
import UIKit
#endif

#if canImport(AppKit)
import AppKit
extension NSImage {
    var cgImage: CGImage? {
        var rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        return cgImage(forProposedRect: &rect, context: nil, hints: nil)
    }
}
#endif

extension CGImage {
    static func makeImage(data: Data) -> CGImage? {
        #if canImport(UIKit)
        return UIImage(data: data)?.cgImage
        #endif
        
        #if canImport(AppKit)
        return NSImage(data: data)?.cgImage
        #endif
    }
}
