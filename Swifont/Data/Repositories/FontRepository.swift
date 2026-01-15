//
//  FontRepository.swift
//  Swifont
//
//  Created by JK on 12/1/26.
//

import Foundation

final class FontRepository: FontRepositoryProtocol {
    private let metadataService: FontMetadataService
    private let codeGenerator: CodeGenerator

    init(
        metadataService: FontMetadataService = FontMetadataService(),
        codeGenerator: CodeGenerator = CodeGenerator()
    ) {
        self.metadataService = metadataService
        self.codeGenerator = codeGenerator
    }

    func extractFontInfo(from urls: [URL]) async throws -> [FontInfo] {
        var allFontInfos: [FontInfo] = []
        var errors: [Error] = []

        await withTaskGroup(of: Result<[FontInfo], Error>.self) { group in
            for url in urls {
                group.addTask {
                    do {
                        let fontInfos = try await self.metadataService.extractMetadata(from: url)
                        return .success(fontInfos)
                    } catch {
                        return .failure(error)
                    }
                }
            }

            for await result in group {
                switch result {
                case .success(let fontInfos):
                    allFontInfos.append(contentsOf: fontInfos)
                case .failure(let error):
                    errors.append(error)
                }
            }
        }

        if allFontInfos.isEmpty && !errors.isEmpty {
            throw errors.first!
        }

        return allFontInfos
    }

    func generateCode(for family: FontFamily) -> GeneratedCode {
        let code = codeGenerator.generateWithPreview(for: family)
        return GeneratedCode(familyName: family.name, code: code)
    }

    func generateCode(for families: [FontFamily]) -> [GeneratedCode] {
        families.map { generateCode(for: $0) }
    }
}
