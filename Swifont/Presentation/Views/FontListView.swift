//
//  FontListView.swift
//  Swifont
//
//  Created by JK on 14/1/26.
//

import SwiftUI

struct FontListView: View {

    let families: [FontFamily]
    @Binding var selectedFamily: FontFamily?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView

            Divider()
            
            if families.isEmpty {
                emptyStateView
            } else {
                familyListView
            }
        }
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var headerView: some View {
        HStack {
            Label(LocalisedString.FontList.title, systemImage: "textformat.size")
                .font(.system(size: 12, weight: .semibold))
                .foregroundColor(.secondary)

            Spacer()

            if !families.isEmpty {
                Text(LocalisedString.FontList.count(families.count))
                    .font(.system(size: 11))
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(Color.secondary.opacity(0.1))
                    .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }

    private var emptyStateView: some View {
        VStack(spacing: 8) {
            Image(systemName: "tray")
                .font(.system(size: 24))
                .foregroundColor(.secondary.opacity(0.5))

            Text(LocalisedString.FontList.empty)
                .font(.system(size: 12))
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(.vertical, 40)
    }

    private var familyListView: some View {
        ScrollView {
            LazyVStack(spacing: 4) {
                ForEach(families) { family in
                    FontFamilyRowView(
                        family: family,
                        isSelected: selectedFamily?.id == family.id
                    )
                    .onTapGesture {
                        withAnimation(.easeInOut(duration: 0.15)) {
                            selectedFamily = family
                        }
                    }
                }
            }
            .padding(8)
        }
    }
}

struct FontDetailView: View {

    let family: FontFamily

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView

            Divider()

            fontListView

            Divider()

            licenseInfoView
        }
        .background(Color(nsColor: .controlBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }

    private var headerView: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(family.name)
                    .font(.system(size: 14, weight: .semibold))

                Text("\(LocalisedString.FontDetail.swiftPrefix)\(family.swiftEnumName)")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(.accentColor)
            }

            Spacer()

            LicenseBadgeView(riskLevel: family.highestRiskLevel)
        }
        .padding(12)
    }

    private var fontListView: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(family.fonts) { font in
                    FontInfoRowView(fontInfo: font)

                    if font.id != family.fonts.last?.id {
                        Divider()
                            .padding(.leading, 8)
                    }
                }
            }
        }
        .frame(maxHeight: 200)
    }

    private var licenseInfoView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(LocalisedString.FontDetail.licenseInfo, systemImage: "doc.text")
                .font(.system(size: 11, weight: .semibold))
                .foregroundColor(.secondary)

            if let firstFont = family.fonts.first {
                VStack(alignment: .leading, spacing: 4) {
                    LicenseTypeBadge(licenseType: firstFont.license.type)

                    Text(firstFont.license.type.localizedDescription)
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                        .lineLimit(2)

                    if let copyright = firstFont.copyright {
                        Text(copyright)
                            .font(.system(size: 10))
                            .foregroundColor(.secondary.opacity(0.8))
                            .lineLimit(2)
                    }
                }
            }
        }
        .padding(12)
    }
}

#if DEBUG
struct FontListView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleFonts = [
            FontInfo(
                fileURL: URL(fileURLWithPath: "/test.otf"),
                familyName: "Pretendard",
                postScriptName: "Pretendard-Regular",
                styleName: "Regular",
                license: LicenseInfo(rawText: "OFL", type: .ofl, riskLevel: .safe)
            ),
            FontInfo(
                fileURL: URL(fileURLWithPath: "/test.otf"),
                familyName: "Pretendard",
                postScriptName: "Pretendard-Bold",
                styleName: "Bold",
                license: LicenseInfo(rawText: "OFL", type: .ofl, riskLevel: .safe)
            )
        ]
        let family = FontFamily(name: "Pretendard", fonts: sampleFonts)

        HStack(spacing: 16) {
            FontListView(
                families: [family],
                selectedFamily: .constant(family)
            )
            .frame(width: 280)

            FontDetailView(family: family)
                .frame(width: 300)
        }
        .padding()
        .frame(height: 400)
    }
}
#endif
