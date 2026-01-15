//
//  FontAnalyzerViewModel.swift
//  Swifont
//
//  Created by JK on 13/1/26.
//

import Foundation
import SwiftUI
import Combine
import UniformTypeIdentifiers


@MainActor
final class FontAnalyzerViewModel: ObservableObject {
    @Published private(set) var fontFamilies: [FontFamily] = []
    @Published var selectedFamily: FontFamily?
    
    @Published private(set) var generatedCodes: [GeneratedCode] = []
    
    @Published private(set) var isLoading = false
    @Published var errorMessage: String?
    @Published var isDragOver = false

    private let analyzeFontUseCase: AnalyzeFontUseCase
    private let generateCodeUseCase: GenerateCodeUseCase

    init(
        analyzeFontUseCase: AnalyzeFontUseCase,
        generateCodeUseCase: GenerateCodeUseCase
    ) {
        self.analyzeFontUseCase = analyzeFontUseCase
        self.generateCodeUseCase = generateCodeUseCase
    }

    func analyzeFonts(urls: [URL]) async {
        guard !urls.isEmpty else { return }

        isLoading = true
        errorMessage = nil

        do {
            let families = try await analyzeFontUseCase.execute(urls: urls)
            fontFamilies = families

            generatedCodes = generateCodeUseCase.execute(families: families)

            if selectedFamily == nil {
                selectedFamily = families.first
            }
        } catch {
            errorMessage = error.localizedDescription
        }

        isLoading = false
    }
    
    var selectedCode: String {
        guard let family = selectedFamily,
              let code = generatedCodes.first(where: { $0.familyName == family.name }) else {
            return LocalisedString.CodePreview.placeholder
        }
        return code.code
    }

    var combinedCode: String {
        generateCodeUseCase.executeCombined(families: fontFamilies)
    }

    func copyCodeToClipboard(allFamilies: Bool = false) {
        let codeToCopy = allFamilies ? combinedCode : selectedCode
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(codeToCopy, forType: .string)
    }

    func saveCodeToFile(allFamilies: Bool = false) {
        let codeToCopy = allFamilies ? combinedCode : selectedCode

        let panel = NSSavePanel()
        panel.allowedContentTypes = [.swiftSource]
        panel.nameFieldStringValue = allFamilies
            ? LocalisedString.Dialog.saveFilename
            : LocalisedString.Dialog.saveFilenameSingle(selectedFamily?.swiftEnumName ?? "Font")

        panel.begin { response in
            if response == .OK, let url = panel.url {
                try? codeToCopy.write(to: url, atomically: true, encoding: .utf8)
            }
        }
    }

    func reset() {
        fontFamilies = []
        selectedFamily = nil
        generatedCodes = []
        errorMessage = nil
    }

    func selectFamily(_ family: FontFamily) {
        selectedFamily = family
    }
}

extension FontAnalyzerViewModel {
    var hasFonts: Bool {
        !fontFamilies.isEmpty
    }

    var totalFontCount: Int {
        fontFamilies.reduce(0) { $0 + $1.fonts.count }
    }

    var familyCount: Int {
        fontFamilies.count
    }

    var highestRiskLevel: RiskLevel {
        fontFamilies.map(\.highestRiskLevel).max() ?? .caution
    }
}
