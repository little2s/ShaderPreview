//
//  ErrorLogView.swift
//  ShaderPreview
//
//  Created by yinglun on 2020/12/19.
//

import SwiftUI

struct ErrorLogView: View {

    @Binding var text: String
    
    let cancelHandler: () -> Void
    
    var body: some View {
        return VStack {
            topLine()
            topBar()
            TextEditor(text: $text)
                .frame(height: 186)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
            .background(Color(NSColor.controlBackgroundColor))
    }
    
    private func topLine() -> some View {
        Rectangle()
            .fill(Color(NSColor.windowBackgroundColor))
            .frame(height: 1)
    }
    
    private func topBar() -> some View {
        HStack() {
            Spacer()
            Button(action: {
                cancelHandler()
            }, label: {
                Image(systemName: "xmark")
                    .imageScale(.medium)
            })
                .buttonStyle(PlainButtonStyle())
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
            .frame(height: 30)
    }
    

}
