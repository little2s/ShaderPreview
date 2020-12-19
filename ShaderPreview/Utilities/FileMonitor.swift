//
//  FileMonitor.swift
//  ShaderPreview
//
//  Created by yinglun on 2020/12/18.
//

import Foundation
import SKQueue

class FileMonitor {
    private class Delegate: SKQueueDelegate {
        var pathDidChange: ((String) -> Void)?
        func receivedNotification(_ notification: SKQueueNotification, path: String, queue: SKQueue) {
    //            print("note: \(notification.toStrings()), path: \(path)")
            DispatchQueue.main.async {
                self.pathDidChange?(path)
            }
        }
    }
        
    private var kqueue: SKQueue?
    private let delegate = Delegate()
    
    private var observingURLs: [URL] = []
    
    func start(URLs: [URL], changeHandler: @escaping () -> Void) {
        stop()
        observingURLs = URLs
        
        delegate.pathDidChange = { [weak self] path in
            guard let strongSelf = self else { return }
            strongSelf.observingURLs.forEach {
                if path.hasSuffix($0.lastPathComponent) {
                    strongSelf.reload(fileURL: $0, action: changeHandler)
                }
            }
        }
        let queue = SKQueue(delegate: delegate)
        URLs.forEach { queue?.addPath($0.path) }
        self.kqueue = queue
    }
    
    func stop() {
        observingURLs.forEach { kqueue?.removePath($0.path) }
        observingURLs.removeAll()
        timerTable.forEach { $0.value.invalidate() }
        timerTable.removeAll()
    }
    
    private var timerTable: [URL: Timer] = [:]
    private func reload(fileURL: URL, action: @escaping () -> Void) {
        if FileManager.default.fileExists(atPath: fileURL.path) {
            DispatchQueue.main.async {
                action()
            }
        } else {
            func stop() {
                timerTable[fileURL]?.invalidate()
                timerTable.removeValue(forKey: fileURL)
            }
            stop()
            let timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] (timer) in
                if FileManager.default.fileExists(atPath: fileURL.path) {
                    stop()
                    self?.kqueue?.removePath(fileURL.path)
                    self?.kqueue?.addPath(fileURL.path)
                    action()
                }
            }
            timerTable[fileURL] = timer
        }
    }

}
