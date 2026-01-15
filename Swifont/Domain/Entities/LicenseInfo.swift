//
//  LicenseInfo.swift
//  Swifont
//
//  Created by JK on 13/1/26.
//

import Foundation

struct LicenseInfo: Hashable {
    let rawText: String?
    let type: LicenseType
    let riskLevel: RiskLevel

    init(rawText: String?, type: LicenseType, riskLevel: RiskLevel) {
        self.rawText = rawText
        self.type = type
        self.riskLevel = riskLevel
    }

    static var unknown: LicenseInfo {
        LicenseInfo(rawText: nil, type: .unknown, riskLevel: .caution)
    }
}

enum LicenseType: String, CaseIterable {
    case ofl
    case apache
    case mit
    case commercial
    case personalOnly
    case restricted
    case unknown

    var localizedName: String {
        switch self {
        case .ofl: return NSLocalizedString("license.ofl", comment: "")
        case .apache: return NSLocalizedString("license.apache", comment: "")
        case .mit: return NSLocalizedString("license.mit", comment: "")
        case .commercial: return NSLocalizedString("license.commercial", comment: "")
        case .personalOnly: return NSLocalizedString("license.personal_only", comment: "")
        case .restricted: return NSLocalizedString("license.restricted", comment: "")
        case .unknown: return NSLocalizedString("license.unknown", comment: "")
        }
    }

    var localizedDescription: String {
        switch self {
        case .ofl: return NSLocalizedString("license.desc.ofl", comment: "")
        case .apache: return NSLocalizedString("license.desc.apache", comment: "")
        case .mit: return NSLocalizedString("license.desc.mit", comment: "")
        case .commercial: return NSLocalizedString("license.desc.commercial", comment: "")
        case .personalOnly: return NSLocalizedString("license.desc.personal_only", comment: "")
        case .restricted: return NSLocalizedString("license.desc.restricted", comment: "")
        case .unknown: return NSLocalizedString("license.desc.unknown", comment: "")
        }
    }
}

enum RiskLevel: Int, Comparable {
    case safe = 0
    case caution = 1  
    case restricted = 2 

    static func < (lhs: RiskLevel, rhs: RiskLevel) -> Bool {
        lhs.rawValue < rhs.rawValue
    }

    var localizedName: String {
        switch self {
        case .safe: return NSLocalizedString("risk.safe", comment: "")
        case .caution: return NSLocalizedString("risk.caution", comment: "")
        case .restricted: return NSLocalizedString("risk.restricted", comment: "")
        }
    }

    var symbolName: String {
        switch self {
        case .safe: return "checkmark.seal.fill"
        case .caution: return "exclamationmark.triangle.fill"
        case .restricted: return "xmark.seal.fill"
        }
    }
}
