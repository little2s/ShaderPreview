//
//  EditorView.swift
//  ShaderPreview
//
//  Created by yinglun on 2021/11/29.
//

import SwiftUI

struct EditorView: View {
    
    @Binding var text: String
    
    var body: some View {
        TextEditor(text: $text)
            .font(Font(NSFont.monospacedSystemFont(ofSize: 14, weight: .regular)))
            .frame(minWidth: 100)
    }
}
