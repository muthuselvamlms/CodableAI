//
//  LLMRequest.swift
//  CodableAi
//
//  Created by Muthu L on 04/09/25.
//

import Foundation

public struct LLMRequest<T: Codable> {
    let prompt: String
    let type: T.Type
}
