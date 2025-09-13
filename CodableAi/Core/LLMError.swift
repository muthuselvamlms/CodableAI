//
//  LLMError.swift
//  CodableAi
//
//  Created by Muthu L on 04/09/25.
//

import Foundation

public enum LLMError: Error {
    case notImplemented
    case invalidResponse
    case decodingFailed
    case networkError(Error)
}
