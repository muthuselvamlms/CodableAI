//
//  OutputParser.swift
//  CodableAi
//
//  Created by Muthu L on 04/09/25.
//

import Foundation

public class OutputParser {
    public static func parse<T: Codable>(_ jsonString: String, type: T.Type) throws -> T {
        guard let data = jsonString.data(using: .utf8) else {
            throw LLMError.decodingFailed
        }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
