//
//  BadgeView.swift
//  Swifont
//
//  Created by JK on 14/1/26.
//

import SwiftUI

struct LicenseBadgeView: View {

    let riskLevel: RiskLevel
    var showLabel: Bool = true

    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: riskLevel.symbolName)
                .font(.system(size: 12, weight: .semibold))

            if showLabel {
                Text(riskLevel.localizedName)
                    .font(.system(size: 11, weight: .medium))
            }
        }
        .foregroundColor(foregroundColor)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(backgroundColor)
        .clipShape(Capsule())
    }

    private var foregroundColor: Color {
        switch riskLevel {
        case .safe:
            return .green
        case .caution:
            return .orange
        case .restricted:
            return .red
        }
    }

    private var backgroundColor: Color {
        foregroundColor.opacity(0.15)
    }
}

struct LicenseTypeBadge: View {

    let licenseType: LicenseType

    var body: some View {
        Text(licenseType.localizedName)
            .font(.system(size: 10, weight: .medium))
            .foregroundColor(.secondary)
            .padding(.horizontal, 6)
            .padding(.vertical, 2)
            .background(Color.secondary.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 4))
    }
}

#if DEBUG
struct LicenseBadgeView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 12) {
            LicenseBadgeView(riskLevel: .safe)
            LicenseBadgeView(riskLevel: .caution)
            LicenseBadgeView(riskLevel: .restricted)

            Divider()

            LicenseBadgeView(riskLevel: .safe, showLabel: false)
            LicenseBadgeView(riskLevel: .caution, showLabel: false)

            Divider()

            LicenseTypeBadge(licenseType: .ofl)
            LicenseTypeBadge(licenseType: .commercial)
        }
        .padding()
    }
}
#endif
