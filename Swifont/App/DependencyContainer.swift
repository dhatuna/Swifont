//
//  DependencyContainer.swift
//  Swifont
//
//  Created by JK on 12/1/26.
//

import Foundation

@MainActor
final class DependencyContainer {
    static let shared = DependencyContainer()

    private init() {}

    // MARK: - Data Layer
    private lazy var licenseAnalyzer: LicenseAnalyzer = {
        LicenseAnalyzer()
    }()

    private lazy var fontMetadataService: FontMetadataService = {
        FontMetadataService(licenseAnalyzer: licenseAnalyzer)
    }()

    private lazy var codeGenerator: CodeGenerator = {
        CodeGenerator()
    }()

    private lazy var fontRepository: FontRepository = {
        FontRepository(
            metadataService: fontMetadataService,
            codeGenerator: codeGenerator
        )
    }()

    // MARK: - Domain Layer (Use Cases)
    private lazy var analyzeFontUseCase: AnalyzeFontUseCase = {
        AnalyzeFontUseCase(repository: fontRepository)
    }()

    private lazy var generateCodeUseCase: GenerateCodeUseCase = {
        GenerateCodeUseCase(repository: fontRepository)
    }()

    // MARK: - Presentation Layer (View Models)
    func makeFontAnalyzerViewModel() -> FontAnalyzerViewModel {
        FontAnalyzerViewModel(
            analyzeFontUseCase: analyzeFontUseCase,
            generateCodeUseCase: generateCodeUseCase
        )
    }
}

extension DependencyContainer {
    func makeTestViewModel(repository: FontRepositoryProtocol) -> FontAnalyzerViewModel {
        let analyzeUseCase = AnalyzeFontUseCase(repository: repository)
        let generateUseCase = GenerateCodeUseCase(repository: repository)
        return FontAnalyzerViewModel(
            analyzeFontUseCase: analyzeUseCase,
            generateCodeUseCase: generateUseCase
        )
    }
}
