//
//  ContentView.swift
//  ShaderPreview
//
//  Created by yinglun on 2020/12/9.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var renderer: ImageRenderer

    @State private var fullText: String = ""
    
    @State private var showsInfoView = false

    var body: some View {
        Group {
            if showsInfoView {
                ZStack {
                    mainView()
                    VStack {
                        Spacer()
                        infoView()
                    }
                }
            } else {
                mainView()
            }
        }
            .frame(idealWidth: 800, idealHeight: 600)
    }
    
    private func mainView() -> some View {
        func topBar() -> some View {
            HStack() {
                Spacer()
                Button(action: {
                    NSWorkspace.shared.open(ResourcesFolder.folderURL)
                }, label: {
                    Image(systemName: "folder")
                        .imageScale(.large)
                })
                    .buttonStyle(PlainButtonStyle())
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
                .frame(height: 30)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
        
        func previewView() -> some View {
            MetalPetalView(mtiContext: renderer.context, mtiImage: $renderer.image, errorHandler: { error in
                self.fullText = error?.localizedDescription ?? ""
            })
        }
        
        func bottomBar() -> some View {
            HStack {
                Button(action: {
                    showsInfoView = true
                }, label: {
                    HStack {
                        Image(systemName: "exclamationmark.triangle")
                            .imageScale(.small)
                        Text(fullText.isEmpty ? "0" : fullText.replacingOccurrences(of: "\n", with: ""))
                    }
                })
                    .buttonStyle(PlainButtonStyle())
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 3, trailing: 20))


                Spacer()
            }
                .frame(height: 22)
        }
        
        return VStack(spacing: 0) {
            topBar()
            previewView()
            bottomBar()
        }
    }
    
    
    private func infoView() -> some View {
        func topBar() -> some View {
            HStack() {
                Spacer()
                Button(action: {
                    showsInfoView = false
                }, label: {
                    Image(systemName: "xmark")
                        .imageScale(.medium)
                })
                    .buttonStyle(PlainButtonStyle())
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
            }
                .frame(height: 30)
        }
        
        return VStack {
            Rectangle()
                .fill(Color(NSColor.windowBackgroundColor))
                .frame(height: 1)
            topBar()
            TextEditor(text: $fullText)
                .frame(height: 186)
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
        }
            .background(Color(NSColor.controlBackgroundColor))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(renderer: ImageRenderer())
    }
}
