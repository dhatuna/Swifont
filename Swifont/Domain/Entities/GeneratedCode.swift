//
//  GeneratedCode.swift
//  Swifont
//
//  Created by JK on 15/1/26.
//

import Foundation

struct GeneratedCode: Identifiable, Hashable {
    let id: UUID
    let familyName: String
    let code: String
    let generatedAt: Date

    init(
        id: UUID = UUID(),
        familyName: String,
        code: String,
        generatedAt: Date = Date()
    ) {
        self.id = id
        self.familyName = familyName
        self.code = code
        self.generatedAt = generatedAt
    }

    var lineCount: Int {
        code.components(separatedBy: .newlines).count
    }
}
