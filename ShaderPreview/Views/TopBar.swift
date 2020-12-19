//
//  TopBar.swift
//  ShaderPreview
//
//  Created by yinglun on 2020/12/19.
//

import SwiftUI

struct TopBar: View {
    @Binding var engineName: String
    
    let engineActionHandler: () -> Void
    
    var body: some View {
        HStack() {
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
