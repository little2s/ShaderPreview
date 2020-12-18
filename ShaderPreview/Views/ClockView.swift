//
//  ClockView.swift
//  ShaderPreview
//
//  Created by yinglun on 2020/12/18.
//

import SwiftUI

struct ClockView: View {
    
    @ObservedObject var clock: Clock

    var body: some View {
        HStack {
            Button(action: {
                clock.toggle()
            }, label: {
                HStack {
                    Image(systemName: clock.isPlaying ? "pause" : "play")
                        .imageScale(.small)
                }
            })
                .buttonStyle(PlainButtonStyle())
            
            Text(clock.timeString)
                .frame(width: 64)
            
            Text("\(Int(clock.fps)) fps")
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 3, trailing: 20))
    }
}

struct ClockView_Previews: PreviewProvider {
    static var previews: some View {
        ClockView(clock: Clock())
    }
}
