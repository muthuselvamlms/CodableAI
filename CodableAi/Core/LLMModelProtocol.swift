//
//  LLMModelProtocol.swift
//  CodableAi
//
//  Created by Muthu L on 04/09/25.
//

import Foundation

public protocol LLMCodable: Codable {
    static var name: String { get }
    static var description: String { get }
}

public protocol LLMModelProtocol {
    func generate<T: LLMCodable>(request: LLMRequest<T>) async throws -> LLMResponse<T>
}

public protocol SchemaDescribable {
    static var schema: [String: Any] { get }
}

@attached(extension, conformances: SchemaDescribable, names: named(schema))
@attached(member, names: arbitrary)
public macro SchemaGenerable() = #externalMacro(
    module: "CodableAIMacros",
    type: "SchemaGenerableMacro"
)

@attached(peer, names: arbitrary)
public macro SchemaHint(_ description: String) = #externalMacro(
    module: "CodableAIMacros",
    type: "SchemaHintMacro"
)
