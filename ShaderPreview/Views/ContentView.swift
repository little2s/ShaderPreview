//
//  ContentView.swift
//  ShaderPreview
//
//  Created by yinglun on 2020/12/9.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button("Open resources folder", action: {
                    NSWorkspace.shared.open(ResourcesFolder.folderURL)
                })
            }.padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 20))
            StaticImageRenderingView(renderer: ImageRenderer())
        }.frame(width: 800, height: 600)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
