//
//  TopBar.swift
//  ShaderPreview
//
//  Created by yinglun on 2020/12/19.
//

import SwiftUI

struct TopBar: View {
    @Binding var engineName: String
    @Binding var isEditorOn: Bool
    
    let engineActionHandler: () -> Void
    let editorActionHandler: () -> Void
    
    var body: some View {
        HStack() {
            Button(isEditorOn ? "Editor On" : "Editor Off") {
                editorActionHandler()
            }
                .buttonStyle(PlainButtonStyle())
            
            Spacer()
            
            Button(engineName, action: engineActionHandler)
                .buttonStyle(PlainButtonStyle())
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 20))

            Button(action: {
                NSWorkspace.shared.open(ResourcesFolder.folderURL)
            }, label: {
                Image(systemName: "folder")
                    .imageScale(.large)
            })
                .buttonStyle(PlainButtonStyle())
        }
            .frame(height: 30)
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
    }
}
