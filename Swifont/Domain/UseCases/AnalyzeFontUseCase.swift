//
//  AnalyzeFontUseCase.swift
//  Swifont
//
//  Created by JK on 13/1/26.
//

import Foundation

final class AnalyzeFontUseCase {
    private let repository: FontRepositoryProtocol

    init(repository: FontRepositoryProtocol) {
        self.repository = repository
    }

    func execute(urls: [URL]) async throws -> [FontFamily] {
        let validURLs = urls.filter { url in
            let ext = url.pathExtension.lowercased()
            return ext == "otf" || ext == "ttf" || ext == "ttc"
        }

        guard !validURLs.isEmpty else {
            throw FontRepositoryError.noFontsFound
        }

        let fontInfos = try await repository.extractFontInfo(from: validURLs)

        guard !fontInfos.isEmpty else {
            throw FontRepositoryError.noFontsFound
        }

        return FontFamily.groupByFamily(fontInfos)
    }
}
