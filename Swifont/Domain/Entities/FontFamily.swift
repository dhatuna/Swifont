//
//  FontFamily.swift
//  Swifont
//
//  Created by JK on 13/1/26.
//

import Foundation

struct FontFamily: Identifiable, Hashable {
    let id: UUID
    let name: String
    let fonts: [FontInfo]

    init(id: UUID = UUID(), name: String, fonts: [FontInfo]) {
        self.id = id
        self.name = name
        self.fonts = fonts.sorted { $0.styleName < $1.styleName }
    }

    var highestRiskLevel: RiskLevel {
        fonts.map(\.license.riskLevel).max() ?? .caution
    }

    var swiftEnumName: String {
        name.toSwiftTypeName()
    }

    var weights: [String] {
        fonts.map(\.styleName)
    }

    static func groupByFamily(_ fonts: [FontInfo]) -> [FontFamily] {
        let grouped = Dictionary(grouping: fonts, by: \.familyName)
        return grouped.map { name, fonts in
            FontFamily(name: name, fonts: fonts)
        }.sorted { $0.name < $1.name }
    }
}

extension String {
    func toSwiftTypeName() -> String {
        let cleaned = self
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: "_", with: " ")
            .split(separator: " ")
            .map { String($0).capitalized }
            .joined()

        if let first = cleaned.first, first.isNumber {
            return "_" + cleaned
        }

        return cleaned.isEmpty ? "UnknownFont" : cleaned
    }
}
