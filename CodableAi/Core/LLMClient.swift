//
//  LLMClient.swift
//  CodableAi
//
//  Created by Muthu L on 04/09/25.
//

import Foundation

public class LLMClient {
    private let model: LLMModelProtocol

    public init(model: LLMModelProtocol) {
        self.model = model
    }

    public func generate<T: LLMCodable>(_ prompt: String, type: T.Type) async throws -> T {
        let request = LLMRequest(prompt: prompt, type: type)
        let response = try await model.generate(request: request)
        return response.data
    }
}
