//
//  Localization.swift
//  Swifont
//
//  Created by JK on 15/1/26.
//

import Foundation
import SwiftUI

extension String {
    var localized: String {
        NSLocalizedString(self, comment: "")
    }

    func localized(with arguments: CVarArg...) -> String {
        String(format: self.localized, arguments: arguments)
    }
}

enum LocalisedString {
    enum App {
        static let name = "app.name".localized
        static let version = "app.version".localized
        static let copyright = "app.copyright".localized
    }

    enum Menu {
        static let open = "menu.open".localized
        static let about = "menu.about".localized
    }

    enum About {
        static let title = "about.title".localized
        static let description = "about.description".localized
        static let features = "about.features".localized
        static let ok = "about.ok".localized
    }

    enum DropZone {
        static let title = "dropzone.title".localized
        static let subtitle = "dropzone.subtitle".localized
        static let loading = "dropzone.loading".localized
        static let addMore = "dropzone.add_more".localized
        static let reset = "dropzone.reset".localized
    }

    enum FontList {
        static let title = "fontlist.title".localized
        static let empty = "fontlist.empty".localized
        static func weights(_ count: Int) -> String {
            "fontlist.weights".localized(with: count)
        }
        static func count(_ count: Int) -> String {
            "fontlist.count".localized(with: count)
        }
    }

    enum FontDetail {
        static let swiftPrefix = "fontdetail.swift_prefix".localized
        static let licenseInfo = "fontdetail.license_info".localized
    }

    enum CodePreview {
        static let placeholder = "codepreview.placeholder".localized
        static let copy = "codepreview.copy".localized
        static let copyAll = "codepreview.copy_all".localized
        static let save = "codepreview.save".localized
        static let saveAll = "codepreview.save_all".localized
        static let copied = "codepreview.copied".localized
    }

    enum Empty {
        static let title = "empty.title".localized
        static let subtitle = "empty.subtitle".localized
    }

    enum Error {
        static func fileAccessDenied(_ file: String) -> String {
            "error.file_access_denied".localized(with: file)
        }
        static func invalidFontFile(_ file: String) -> String {
            "error.invalid_font_file".localized(with: file)
        }
        static func metadataExtractionFailed(_ file: String, _ reason: String) -> String {
            "error.metadata_extraction_failed".localized(with: file, reason)
        }
        static let noFontsFound = "error.no_fonts_found".localized
    }

    enum License {
        static let ofl = "license.ofl".localized
        static let apache = "license.apache".localized
        static let mit = "license.mit".localized
        static let commercial = "license.commercial".localized
        static let personalOnly = "license.personal_only".localized
        static let restricted = "license.restricted".localized
        static let unknown = "license.unknown".localized

        enum Desc {
            static let ofl = "license.desc.ofl".localized
            static let apache = "license.desc.apache".localized
            static let mit = "license.desc.mit".localized
            static let commercial = "license.desc.commercial".localized
            static let personalOnly = "license.desc.personal_only".localized
            static let restricted = "license.desc.restricted".localized
            static let unknown = "license.desc.unknown".localized
        }
    }

    enum Risk {
        static let safe = "risk.safe".localized
        static let caution = "risk.caution".localized
        static let restricted = "risk.restricted".localized
    }

    enum Dialog {
        static let selectFonts = "dialog.select_fonts".localized
        static let saveFilename = "dialog.save_filename".localized
        static func saveFilenameSingle(_ name: String) -> String {
            "dialog.save_filename_single".localized(with: name)
        }
    }
}
