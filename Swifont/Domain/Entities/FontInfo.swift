//
//  FontInfo.swift
//  Swifont
//
//  Created by JK on 13/1/26.
//

import Foundation

struct FontInfo: Identifiable, Hashable {
    let id: UUID
    let fileURL: URL
    let familyName: String
    let postScriptName: String
    let styleName: String
    let copyright: String?
    let license: LicenseInfo

    init(
        id: UUID = UUID(),
        fileURL: URL,
        familyName: String,
        postScriptName: String,
        styleName: String,
        copyright: String? = nil,
        license: LicenseInfo
    ) {
        self.id = id
        self.fileURL = fileURL
        self.familyName = familyName
        self.postScriptName = postScriptName
        self.styleName = styleName
        self.copyright = copyright
        self.license = license
    }

    var fileName: String {
        fileURL.lastPathComponent
    }

    var swiftCaseName: String {
        styleName.toSwiftEnumCase()
    }
}


extension String {
    func toSwiftEnumCase() -> String {
        let normalized = self
            .replacingOccurrences(of: "-", with: " ")
            .replacingOccurrences(of: "_", with: " ")
            .split(separator: " ")
            .map { String($0) }

        guard !normalized.isEmpty else { return "regular" }

        var result = normalized[0].lowercased()
        for word in normalized.dropFirst() {
            result += word.capitalized
        }

        return result
    }
}
