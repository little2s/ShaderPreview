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
    
    var body: some View {
        MetalPetalView(mtiContext: renderer.context, mtiImage: $renderer.image)
            .edgesIgnoringSafeArea(.all)
    }
}

struct StaticImageRenderingView_Previews: PreviewProvider {
    static var previews: some View {
        StaticImageRenderingView(renderer: ImageRenderer())
    }
}
