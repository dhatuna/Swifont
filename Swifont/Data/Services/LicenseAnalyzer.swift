//
//  LicenseAnalyzer.swift
//  Swifont
//
//  Created by JK on 13/1/26.
//

import Foundation

final class LicenseAnalyzer {
    private let detectionRules: [(keywords: [String], type: LicenseType, risk: RiskLevel)] = [
        (["ofl", "open font license", "sil open font"], .ofl, .safe),
        (["apache license", "apache-2.0", "apache 2.0"], .apache, .safe),
        (["mit license", "mit-license"], .mit, .safe),

        // Restricted
        (["personal use only", "personal use", "non-commercial"], .personalOnly, .restricted),
        (["restricted", "proprietary", "all rights reserved"], .restricted, .restricted),

        // Commercial
        (["commercial license", "commercial use", "purchased", "licensed to"], .commercial, .caution),
    ]

    // MARK: - Public Methods
    func analyze(licenseText: String?, copyright: String?) -> LicenseInfo {
        let combinedText = [licenseText, copyright]
            .compactMap { $0 }
            .joined(separator: " ")
            .lowercased()

        guard !combinedText.isEmpty else {
            return LicenseInfo(rawText: nil, type: .unknown, riskLevel: .caution)
        }

        for rule in detectionRules {
            for keyword in rule.keywords {
                if combinedText.contains(keyword) {
                    return LicenseInfo(
                        rawText: licenseText ?? copyright,
                        type: rule.type,
                        riskLevel: rule.risk
                    )
                }
            }
        }

        return LicenseInfo(
            rawText: licenseText ?? copyright,
            type: .unknown,
            riskLevel: .caution
        )
    }
    
    
    func inferFromURL(_ url: String) -> LicenseType? {
        let lowercased = url.lowercased()

        if lowercased.contains("scripts.sil.org/ofl") {
            return .ofl
        } else if lowercased.contains("apache.org/licenses") {
            return .apache
        } else if lowercased.contains("opensource.org/licenses/mit") {
            return .mit
        }

        return nil
    }
}
