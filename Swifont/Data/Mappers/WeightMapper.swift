//
//  WeightMapper.swift
//  Swifont
//
//  Created by JK on 12/1/26.
//

import Foundation

enum WeightMapper {
    private static let weightMappings: [(patterns: [String], swiftCase: String, sortOrder: Int)] = [
        (["thin", "hairline", "w100"], "thin", 100),
        (["ultralight", "ultra light", "extralight", "extra light", "w200"], "ultraLight", 200),
        (["light", "lite", "w300"], "light", 300),
        (["regular", "normal", "book", "roman", "w400", "text"], "regular", 400),
        (["medium", "w500"], "medium", 500),
        (["semibold", "semi bold", "demibold", "demi bold", "demi", "w600"], "semiBold", 600),
        (["bold", "w700"], "bold", 700),
        (["extrabold", "extra bold", "ultrabold", "ultra bold", "w800"], "extraBold", 800),
        (["black", "heavy", "w900"], "black", 900),
        (["extrablack", "extra black", "ultrablack", "ultra black", "w950"], "extraBlack", 950),
    ]

    static func mapToSwiftCase(_ styleName: String) -> String {
        let normalized = normalizeStyleName(styleName)

        for mapping in weightMappings {
            for pattern in mapping.patterns {
                if normalized.contains(pattern) {
                    return mapping.swiftCase
                }
            }
        }

        return styleName.toSwiftEnumCase()
    }

    static func sortOrder(for styleName: String) -> Int {
        let normalized = normalizeStyleName(styleName)

        for mapping in weightMappings {
            for pattern in mapping.patterns {
                if normalized.contains(pattern) {
                    return mapping.sortOrder
                }
            }
        }

        return 400
    }

    static func isItalic(_ styleName: String) -> Bool {
        let normalized = normalizeStyleName(styleName)
        return normalized.contains("italic") || normalized.contains("oblique")
    }

    static func separateWeightAndStyle(_ styleName: String) -> (weight: String, isItalic: Bool) {
        var normalized = normalizeStyleName(styleName)
        let italic = isItalic(styleName)

        normalized = normalized
            .replacingOccurrences(of: "italic", with: "")
            .replacingOccurrences(of: "oblique", with: "")
            .trimmingCharacters(in: .whitespaces)

        let weight = normalized.isEmpty ? "regular" : mapToSwiftCase(normalized)

        return (weight, italic)
    }

    private static func normalizeStyleName(_ styleName: String) -> String {
        styleName
            .lowercased()
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: "_", with: " ")
            .trimmingCharacters(in: .whitespaces)
    }
}
