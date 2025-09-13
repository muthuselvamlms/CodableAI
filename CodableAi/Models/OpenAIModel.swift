//
//  OpenAIModel.swift
//  CodableAi
//
//  Created by Muthu L on 04/09/25.
//

import Foundation

struct OpenAIResponse: Codable {
    struct Choice: Codable {
        struct Message: Codable {
            let content: String
        }
        let message: Message
    }
    let choices: [Choice]
}

public class OpenAIModel: LLMModelProtocol {
    private let apiKey: String
    private let modelName: String
    
    public init(apiKey: String, modelName: String = "gpt-4o") {
        self.apiKey = apiKey
        self.modelName = modelName
    }
    
    private func functionSchema<T: LLMCodable>(for type: T.Type) throws -> [String: Any] {
        var properties: [String: Any] = [:]
        var required: [String] = []
        guard let dummy = try? JSONDecoder().decode(T.self, from: Data("{}".utf8)) else { return [:] }
        let mirror = Mirror(reflecting: dummy)
        for child in mirror.children {
            guard let label = child.label else { continue }
            let valueType = try type.init(from: child.value as! Decoder)
            var propertySchema: [String: Any] = [:]
            switch valueType {
            case is Int.Type, is Double.Type, is Float.Type:
                propertySchema["type"] = "number"
            case is String.Type:
                propertySchema["type"] = "string"
            case is Bool.Type:
                propertySchema["type"] = "boolean"
            default:
                propertySchema["type"] = "string"
            }
            properties[label] = propertySchema
            // Check if property is non-optional
            if !(valueType is Optional<Any>.Type) {
                required.append(label)
            }
        }
        return [
            "name": T.name,
            "description": T.description,
            "parameters": [
                "type": "object",
                "properties": properties,
                "required": required
            ]
        ]
    }
    
    public func generate<T: LLMCodable>(request: LLMRequest<T>) async throws -> LLMResponse<T> {
        // 1. Create URL
        guard let url = URL(string: "https://api.openai.com/v1/chat/completions") else {
            throw LLMError.invalidResponse
        }
        
        // 2. Prepare request body
        var body: [String: Any] = [
            "model": modelName,
            "messages": [
                ["role": "user", "content": request.prompt]
            ],
            "temperature": 0
        ]
        let schema = try functionSchema(for: T.self)
        body["functions"] = [schema]
        body["function_call"] = ["name": schema["name"] ?? ""]
        
        let jsonData = try JSONSerialization.data(withJSONObject: body)
        
        // 3. Prepare URLRequest
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        urlRequest.httpBody = jsonData
        
        // 4. Send request
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: urlRequest)
            print("Response Data: \(String(data: data, encoding: .utf8) ?? "")")
            print("Response headers: \((response as? HTTPURLResponse)?.allHeaderFields ?? [:])")
        } catch {
            throw LLMError.networkError(error)
        }
        
        // 5. Validate HTTP response
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw LLMError.invalidResponse
        }
        
        // 6. Decode response JSON
        
        let openAIResponse: OpenAIResponse
        do {
            openAIResponse = try JSONDecoder().decode(OpenAIResponse.self, from: data)
        } catch {
            throw LLMError.decodingFailed
        }
        
        guard let messageContent = openAIResponse.choices.first?.message.content else {
            throw LLMError.invalidResponse
        }
        
        // 7. Parse content into typed Codable object
        let parsedData: T
        do {
            parsedData = try OutputParser.parse(messageContent, type: T.self)
        } catch {
            throw LLMError.decodingFailed
        }
        
        return LLMResponse(data: parsedData, rawText: messageContent)
    }
}
