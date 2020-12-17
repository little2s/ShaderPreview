//
//  ContentView.swift
//  ShaderPreview
//
//  Created by yinglun on 2020/12/9.
//

import SwiftUI

struct ContentView: View {
    @State private var fullText: String = ""

    var body: some View {
        VStack {
            HStack {
                TextEditor(text: $fullText)
                    .frame(height: 44)
                Spacer()
                Button("Open resources folder", action: {
                    NSWorkspace.shared.open(ResourcesFolder.folderURL)
                })
            }
                .padding(EdgeInsets(top: 8, leading: 20, bottom: 0, trailing: 20))
            StaticImageRenderingView(renderer: ImageRenderer(), errorHandler: { error in
                self.fullText = error?.localizedDescription ?? ""
            })
        }
            .frame(minWidth: 0,
                   idealWidth: 800,
                   maxWidth: .greatestFiniteMagnitude,
                   minHeight: 0,
                   idealHeight: 600,
                   maxHeight: .greatestFiniteMagnitude
            )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
