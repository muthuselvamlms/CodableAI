//
//  LLMClientTests.swift
//  LLMClientTests
//
//  Created by Muthu L on 04/09/25.
//

import Testing
@testable import CodableAi

struct LLMClientTests {
    
    // Define your structured type
    @SchemaGenerable
    struct Weather: LLMCodable {
        static var name: String = "Weather"
        
        static var description: String  = "Represents weather information including temperature, condition, location, and unit."
        
        let temperature: Int
        let condition: String
        let location: String
        let unit: String
    }

    @Test func example() async throws {
        // Write your test here and use APIs like `#expect(...)` to check expected conditions.
        let client = LLMClient(model: LLMModel.openAI(modelName: "gpt-4o"))
        
        do {
//            let prompt = """
//                You are a helpful assistant.  
//                Your task is to return information strictly in **valid JSON format** that matches the given schema.  
//
//                ⚠️ Important rules:
//                - Do not include explanations, comments, or extra text.  
//                - Do not wrap the JSON in code blocks or markdown.  
//                - Output **only JSON** that conforms to the schema.  
//
//                Here is the schema:
//                {
//                  "temperature": number,     // in Celsius
//                  "condition": string,       // e.g., "Sunny", "Cloudy", "Rainy"
//                  "location": string,        // city name
//                  "unit": string             // always "Celsius"
//                }
//
//                Now, generate the response for: "What is the weather in Chennai today?"
//                """
            let prompt = "What is the weather in Chennai today?"
            let weather: Weather = try await client.generate(prompt, type: Weather.self)
            print("Temp: \(weather.temperature), Condition: \(weather.condition)")
        } catch let llmError as LLMError {
            // Handle LLMError specifically
            switch llmError {
            case .notImplemented:
                print("Provider not implemented yet.")
            case .invalidResponse:
                print("Received invalid response from the model.")
            case .decodingFailed:
                print("Failed to decode the model output.")
            case .networkError(let underlyingError):
                print("Network error occurred: \(underlyingError.localizedDescription)")
            }
        } catch {
            // Catch any other unexpected errors
            print("Unexpected error: \(error.localizedDescription)")
        }
    }

}
