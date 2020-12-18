//
//  Clock.swift
//  ShaderPreview
//
//  Created by yinglun on 2020/12/18.
//

import Foundation
import Combine

class Clock: ObservableObject {
    @Published var timeString: String = "0.00"
    
    private(set) var time: TimeInterval = 0.0 {
        didSet {
            timeString = String(format: "%.2f", time)
        }
    }

    @Published private(set) var isPlaying = false
    
    let fps: TimeInterval = 30.0
    
    private var timer: Timer?
    
    func toggle() {
        if isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    func play() {
        pause()
        let step = 1.0/fps
        let timer = Timer.scheduledTimer(withTimeInterval: step, repeats: true, block: { [weak self] timer in
            if let strongSelf = self, timer === strongSelf.timer {
                strongSelf.time += step
            }
        })
        RunLoop.main.add(timer, forMode: .common)
        self.timer = timer
        self.isPlaying = true
    }
    
    func pause() {
        timer?.invalidate()
        timer = nil
        isPlaying = false
    }
}
