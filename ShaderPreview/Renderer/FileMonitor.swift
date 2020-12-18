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
    
    func start(changeHandler: @escaping () -> Void) {
        self.delegate.pathDidChange = { [weak self] path in
            if path.hasSuffix(ResourcesFolder.shaderURL.lastPathComponent) {
                self?.reload(fileURL: ResourcesFolder.shaderURL) {
                    changeHandler()
                }
            } else if path.hasSuffix(ResourcesFolder.texturesFolderURL.lastPathComponent) {
                self?.reload(fileURL: ResourcesFolder.texturesFolderURL) {
                    changeHandler()
                }
            }
        }
        let queue = SKQueue(delegate: delegate)
        queue?.addPath(ResourcesFolder.shaderURL.path)
        queue?.addPath(ResourcesFolder.texturesFolderURL.path)
        self.kqueue = queue
    }
    
    func stop() {
        kqueue?.removePath(ResourcesFolder.shaderURL.path)
        kqueue?.removePath(ResourcesFolder.texturesFolderURL.path)
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
