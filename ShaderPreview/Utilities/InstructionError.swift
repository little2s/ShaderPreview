//
//  InstructionError.swift
//  ShaderPreview
//
//  Created by yinglun on 2020/12/19.
//

import Foundation

struct InstructionError: LocalizedError {
    private let instruction: String
    var errorDescription: String? { instruction }
    init(_ instruction: String) { self.instruction = instruction }
}
