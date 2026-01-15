//
//  FontMetadataService.swift
//  Swifont
//
//  Created by JK on 12/1/26.
//

import Foundation
import CoreText
import AppKit

final class FontMetadataService {

    private let licenseAnalyzer: LicenseAnalyzer

    init(licenseAnalyzer: LicenseAnalyzer = LicenseAnalyzer()) {
        self.licenseAnalyzer = licenseAnalyzer
    }

    // MARK: - Public Methods
    func extractMetadata(from url: URL) throws -> [FontInfo] {
        let hasAccess = url.startAccessingSecurityScopedResource()
        defer {
            if hasAccess {
                url.stopAccessingSecurityScopedResource()
            }
        }

        guard let descriptors = CTFontManagerCreateFontDescriptorsFromURL(url as CFURL) as? [CTFontDescriptor] else {
            throw FontRepositoryError.invalidFontFile(url)
        }

        guard !descriptors.isEmpty else {
            throw FontRepositoryError.invalidFontFile(url)
        }

        return descriptors.compactMap { descriptor in
            extractFontInfo(from: descriptor, fileURL: url)
        }
    }

    // MARK: - Private Methods
    private func extractFontInfo(from descriptor: CTFontDescriptor, fileURL: URL) -> FontInfo? {
        guard let familyName = getAttribute(descriptor, key: kCTFontFamilyNameAttribute) as? String,
              let postScriptName = getAttribute(descriptor, key: kCTFontNameAttribute) as? String else {
            return nil
        }

        let styleName = (getAttribute(descriptor, key: kCTFontStyleNameAttribute) as? String) ?? "Regular"

        let font = CTFontCreateWithFontDescriptor(descriptor, 0, nil)

        let copyright = CTFontCopyName(font, kCTFontCopyrightNameKey) as String?

        let licenseText = extractLicenseText(from: font)
        let license = licenseAnalyzer.analyze(licenseText: licenseText, copyright: copyright)

        return FontInfo(
            fileURL: fileURL,
            familyName: familyName,
            postScriptName: postScriptName,
            styleName: styleName,
            copyright: copyright,
            license: license
        )
    }

    private func getAttribute(_ descriptor: CTFontDescriptor, key: CFString) -> Any? {
        CTFontDescriptorCopyAttribute(descriptor, key)
    }

    private func extractLicenseText(from font: CTFont) -> String? {
        if let license = CTFontCopyName(font, kCTFontLicenseNameKey) as String?, !license.isEmpty {
            return license
        }

        if let licenseURL = CTFontCopyName(font, kCTFontLicenseURLNameKey) as String?, !licenseURL.isEmpty {
            return licenseURL
        }

        if let description = CTFontCopyName(font, kCTFontDescriptionNameKey) as String?, !description.isEmpty {
            return description
        }

        return nil
    }
}
