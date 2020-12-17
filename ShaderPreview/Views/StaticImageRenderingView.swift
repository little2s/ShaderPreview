//
//  ContentView.swift
//  MetalPetalDemo
//
//  Created by yinglun on 2020/6/28.
//  Copyright © 2020 meteor. All rights reserved.
//

import SwiftUI

struct StaticImageRenderingView: View {
    @ObservedObject var renderer: ImageRenderer
    
    let errorHandler: ((Error?) -> Void)?
    
    var body: some View {
        MetalPetalView(mtiContext: renderer.context, mtiImage: $renderer.image, errorHandler: errorHandler)
            .edgesIgnoringSafeArea(.all)
    }
}

struct StaticImageRenderingView_Previews: PreviewProvider {
    static var previews: some View {
        StaticImageRenderingView(renderer: ImageRenderer(), errorHandler: nil)
    }
}
