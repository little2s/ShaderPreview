//
//  ContentView.swift
//  ShaderPreview
//
//  Created by yinglun on 2020/12/9.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: ImageRenderer
    
    @State private var showsErrorLogView = false

    var body: some View {
        Group {
            if showsErrorLogView {
                ZStack {
                    mainView()
                    VStack {
                        Spacer()
                        ErrorLogView(text: $viewModel.errorLog, cancelHandler: {
                            showsErrorLogView = false
                        })
                    }
                }
            } else {
                mainView()
            }
        }
            .frame(idealWidth: 800, idealHeight: 600)
    }
    
    private func mainView() -> some View {
        VStack(spacing: 0) {
            TopBar(engineName: $viewModel.engineName, engineActionHandler: {
                viewModel.toggleEngine()
            })
            Spacer()
            PreviewView(nsImage: $viewModel.image)
            Spacer()
            BottomBar(clock: $viewModel.clock, errorDescription: $viewModel.errorDescription, errorActionHandler: {
                showsErrorLogView = true
            })
        }
    }
    
}
