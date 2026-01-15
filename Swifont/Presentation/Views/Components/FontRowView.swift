//
//  FontRowView.swift
//  Swifont
//
//  Created by JK on 13/1/26.
//

import SwiftUI


struct FontFamilyRowView: View {

    let family: FontFamily
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: "textformat")
                .font(.system(size: 20))
                .foregroundColor(isSelected ? .white : .accentColor)
                .frame(width: 36, height: 36)
                .background(isSelected ? Color.accentColor : Color.accentColor.opacity(0.1))
                .clipShape(RoundedRectangle(cornerRadius: 8))

            VStack(alignment: .leading, spacing: 2) {
                Text(family.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(isSelected ? .white : .primary)

                Text(LocalisedString.FontList.weights(family.fonts.count))
                    .font(.system(size: 12))
                    .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
            }

            Spacer()

            LicenseBadgeView(riskLevel: family.highestRiskLevel, showLabel: false)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(isSelected ? Color.accentColor : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .contentShape(Rectangle())
    }
}


struct FontInfoRowView: View {

    let fontInfo: FontInfo

    var body: some View {
        HStack(spacing: 8) {
            Text(fontInfo.styleName)
                .font(.system(size: 13, weight: .medium))
                .frame(width: 100, alignment: .leading)

            Text(fontInfo.postScriptName)
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.secondary)

            Spacer()

            Text(".\(fontInfo.swiftCaseName)")
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.accentColor)
        }
        .padding(.vertical, 6)
        .padding(.horizontal, 8)
    }
}



struct FontFamilySectionView: View {

    let family: FontFamily
    @State private var isExpanded = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: 12) {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(.secondary)
                        .frame(width: 16)

                    Text(family.name)
                        .font(.system(size: 14, weight: .semibold))

                    Text("(\(family.fonts.count))")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)

                    Spacer()

                    LicenseBadgeView(riskLevel: family.highestRiskLevel)
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 12)
                .background(Color(nsColor: .controlBackgroundColor))
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(spacing: 0) {
                    ForEach(family.fonts) { font in
                        FontInfoRowView(fontInfo: font)
                        if font.id != family.fonts.last?.id {
                            Divider()
                                .padding(.leading, 116)
                        }
                    }
                }
                .padding(.leading, 28)
                .padding(.top, 4)
            }
        }
    }
}


#if DEBUG
struct FontRowView_Previews: PreviewProvider {
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

        VStack(spacing: 16) {
            FontFamilyRowView(family: family, isSelected: false)
            FontFamilyRowView(family: family, isSelected: true)

            Divider()

            FontFamilySectionView(family: family)
        }
        .padding()
        .frame(width: 400)
    }
}
#endif
