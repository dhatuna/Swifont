//
//  FontRepositoryProtocol.swift
//  Swifont
//
//  Created by JK on 13/1/26.
//

import Foundation

protocol FontRepositoryProtocol {
    func extractFontInfo(from urls: [URL]) async throws -> [FontInfo]
    func generateCode(for family: FontFamily) -> GeneratedCode
    func generateCode(for families: [FontFamily]) -> [GeneratedCode]
}

enum FontRepositoryError: LocalizedError {
    case fileAccessDenied(URL)
    case invalidFontFile(URL)
    case metadataExtractionFailed(URL, String)
    case noFontsFound

    var errorDescription: String? {
        switch self {
        case .fileAccessDenied(let url):
            return String(format: NSLocalizedString("error.file_access_denied", comment: ""), url.lastPathComponent)
        case .invalidFontFile(let url):
            return String(format: NSLocalizedString("error.invalid_font_file", comment: ""), url.lastPathComponent)
        case .metadataExtractionFailed(let url, let reason):
            return String(format: NSLocalizedString("error.metadata_extraction_failed", comment: ""), url.lastPathComponent, reason)
        case .noFontsFound:
            return NSLocalizedString("error.no_fonts_found", comment: "")
        }
    }
}
