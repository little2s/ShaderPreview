//
//  PreviewView.swift
//  ShaderPreview
//
//  Created by yinglun on 2020/12/19.
//

import SwiftUI

struct PreviewView: View {
    
    @Binding var nsImage: NSImage?
    
    var body: some View {
        Group {
            if let nsImage = self.nsImage {
                Image(nsImage: nsImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
        }
        .frame(minWidth: 100)
    }
}
