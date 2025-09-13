//
//  LLMModel.swift
//  CodableAi
//
//  Created by Muthu L on 04/09/25.
//

import Foundation

// MARK: - AI Model Enum (OpenAI, Anthropic, Gemini, Local, etc.)
public enum LLMModel: LLMModelProtocol {
    case openAI(modelName: String)
    case anthropic(modelName: String)
    case gemini(modelName: String)
    case local(modelName: String)

    var name: String {
        switch self {
        case .openAI(let modelName): return "OpenAI - \(modelName)"
        case .anthropic(let modelName): return "Anthropic - \(modelName)"
        case .gemini(let modelName): return "Google Gemini - \(modelName)"
        case .local(let modelName): return "Local Model - \(modelName)"
        }
    }

    public func generate<T: LLMCodable>(request: LLMRequest<T>) async throws -> LLMResponse<T> {
        // Here you implement provider-specific API calls
        // For now, throw not implemented
        switch self {
        case .openAI(let modelName):
            guard let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
                  let dict = NSDictionary(contentsOfFile: path),
                  let apiKey = dict["OPENAI_API_KEY"] as? String else {
                fatalError("Missing OPENAI_API_KEY in Config.plist")
            }
            let openAIModel = OpenAIModel(apiKey: apiKey, modelName: modelName)
            return try await openAIModel.generate(request: request)
        case .anthropic(let modelName):
            throw LLMError.notImplemented
        case .gemini(let modelName):
            throw LLMError.notImplemented
        case .local(modelName: let modelName):
            throw LLMError.notImplemented
        }
    }
}
