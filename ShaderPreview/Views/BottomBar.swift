//
//  BottomBar.swift
//  ShaderPreview
//
//  Created by yinglun on 2020/12/19.
//

import SwiftUI

struct BottomBar: View {
    
    @Binding var clock: Clock

    @Binding var errorDescription: String
    
    let errorActionHandler: () -> Void
    
    var body: some View {
        HStack {
            Button(action: {
                errorActionHandler()
            }, label: {
                HStack {
                    Image(systemName: "exclamationmark.triangle")
                        .imageScale(.small)
                    Text(errorDescription)
                }
            })
                .buttonStyle(PlainButtonStyle())
                .padding(EdgeInsets(top: 0, leading: 20, bottom: 3, trailing: 20))
            Spacer()
            ClockView(clock: clock)
        }
            .frame(height: 22)
    }
}
