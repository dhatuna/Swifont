//
//  CodeGenerator.swift
//  Swifont
//
//  Created by JK on 15/1/26.
//

import Foundation

final class CodeGenerator {
    func generate(for family: FontFamily) -> String {
        let enumName = family.swiftEnumName
        let sortedFonts = sortFontsByWeight(family.fonts)

        let weightCases = generateWeightCases(from: sortedFonts)
        let switchCases = generateSwitchCases(from: sortedFonts)
        let defaultWeight = determineDefaultWeight(from: sortedFonts)

        return """
extension Font {
    enum \(enumName) {
        enum Weight: CaseIterable {
\(weightCases)

            var fontName: String {
                switch self {
\(switchCases)
                }
            }
        }

        static func font(size: CGFloat, weight: Self.Weight = .\(defaultWeight)) -> Font {
            return .custom(weight.fontName, size: size, relativeTo: .body)
        }

        static func uiFont(size: CGFloat, weight: Self.Weight = .\(defaultWeight)) -> UIFont {
            return .init(name: weight.fontName, size: size) ?? .systemFont(ofSize: size)
        }
    }
}
"""
    }

    
    func generate(for families: [FontFamily]) -> [String] {
        families.map { generate(for: $0) }
    }

    func generateWithPreview(for family: FontFamily) -> String {
        let mainCode = generate(for: family)
        let previewCode = generatePreview(for: family)

        return mainCode + "\n\n" + previewCode
    }

    // MARK: - Private Methods
    private func sortFontsByWeight(_ fonts: [FontInfo]) -> [FontInfo] {
        fonts.sorted { font1, font2 in
            WeightMapper.sortOrder(for: font1.styleName) < WeightMapper.sortOrder(for: font2.styleName)
        }
    }

    private func generateWeightCases(from fonts: [FontInfo]) -> String {
        let cases = fonts.map { font in
            let caseName = WeightMapper.mapToSwiftCase(font.styleName)
            return "            case \(caseName)"
        }
        return cases.joined(separator: "\n")
    }

    private func generateSwitchCases(from fonts: [FontInfo]) -> String {
        let cases = fonts.map { font in
            let caseName = WeightMapper.mapToSwiftCase(font.styleName)
            return "                case .\(caseName): return \"\(font.postScriptName)\""
        }
        return cases.joined(separator: "\n")
    }

    private func determineDefaultWeight(from fonts: [FontInfo]) -> String {
        let hasRegular = fonts.contains {
            WeightMapper.mapToSwiftCase($0.styleName) == "regular"
        }
        if hasRegular {
            return "regular"
        }

        if let firstFont = fonts.first {
            return WeightMapper.mapToSwiftCase(firstFont.styleName)
        }

        return "regular"
    }

    private func generatePreview(for family: FontFamily) -> String {
        let enumName = family.swiftEnumName

        return """
// MARK: - Preview
#if DEBUG
struct \(enumName)FontPreview: PreviewProvider {
    static var previews: some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(Font.\(enumName).Weight.allCases, id: \\.self) { weight in
                Text("\\(weight) - 가나다라 ABCabc 0123")
                    .font(Font.\(enumName).font(size: 18, weight: weight))
            }
        }
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
#endif
"""
    }
}
