//
//  LLMResponse.swift
//  CodableAi
//
//  Created by Muthu L on 04/09/25.
//

import Foundation

public struct LLMResponse<T: Codable> {
    let data: T
    let rawText: String
}
