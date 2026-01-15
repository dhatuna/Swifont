//
//  CodePreviewView.swift
//  Swifont
//
//  Created by JK on 15/1/26.
//

import SwiftUI



struct CodePreviewView: View {

    let code: String
    let familyName: String?
    let onCopy: () -> Void
    let onCopyAll: () -> Void
    let onSave: () -> Void
    let onSaveAll: () -> Void

    @State private var showCopiedFeedback = false

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerView

            Divider()

            codeContentView
        }
        .background(Color(nsColor: .textBackgroundColor))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(Color.secondary.opacity(0.2), lineWidth: 1)
        )
    }

    private var headerView: some View {
        HStack(spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "swift")
                    .font(.system(size: 14))
                    .foregroundColor(.orange)

                Text(familyName.map { "\($0)+Extension.swift" } ?? LocalisedString.Dialog.saveFilename)
                    .font(.system(size: 12, weight: .medium, design: .monospaced))
                    .foregroundColor(.primary)
            }

            Spacer()

            if showCopiedFeedback {
                HStack(spacing: 4) {
                    Image(systemName: "checkmark")
                    Text(LocalisedString.CodePreview.copied)
                }
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.green)
                .transition(.opacity.combined(with: .scale))
            }

            actionButtons
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color(nsColor: .controlBackgroundColor))
    }

    private var actionButtons: some View {
        HStack(spacing: 8) {
            Menu {
                Button {
                    performCopy(action: onCopy)
                } label: {
                    Label(LocalisedString.CodePreview.copy, systemImage: "doc.on.doc")
                }

                Button {
                    performCopy(action: onCopyAll)
                } label: {
                    Label(LocalisedString.CodePreview.copyAll, systemImage: "doc.on.doc.fill")
                }
            } label: {
                Image(systemName: "doc.on.doc")
                    .font(.system(size: 13))
            }
            .menuStyle(.borderlessButton)
            .frame(width: 28)

            Menu {
                Button {
                    onSave()
                } label: {
                    Label(LocalisedString.CodePreview.save, systemImage: "square.and.arrow.down")
                }

                Button {
                    onSaveAll()
                } label: {
                    Label(LocalisedString.CodePreview.saveAll, systemImage: "square.and.arrow.down.fill")
                }
            } label: {
                Image(systemName: "square.and.arrow.down")
                    .font(.system(size: 13))
            }
            .menuStyle(.borderlessButton)
            .frame(width: 28)
        }
    }

    private var codeContentView: some View {
        ScrollView([.horizontal, .vertical]) {
            Text(code)
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.primary)
                .textSelection(.enabled)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func performCopy(action: () -> Void) {
        action()
        withAnimation(.easeInOut(duration: 0.2)) {
            showCopiedFeedback = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeInOut(duration: 0.2)) {
                showCopiedFeedback = false
            }
        }
    }
}

#if DEBUG
struct CodePreviewView_Previews: PreviewProvider {
    static let sampleCode = """
extension Font {
    enum Pretendard {
        enum Weight: CaseIterable {
            case thin
            case light
            case regular
            case medium
            case semiBold
            case bold

            var fontName: String {
                switch self {
                case .thin: return "Pretendard-Thin"
                case .light: return "Pretendard-Light"
                case .regular: return "Pretendard-Regular"
                case .medium: return "Pretendard-Medium"
                case .semiBold: return "Pretendard-SemiBold"
                case .bold: return "Pretendard-Bold"
                }
            }
        }

        static func font(size: CGFloat, weight: Self.Weight = .regular) -> Font {
            return .custom(weight.fontName, size: size, relativeTo: .body)
        }
    }
}
"""

    static var previews: some View {
        CodePreviewView(
            code: sampleCode,
            familyName: "Pretendard",
            onCopy: {},
            onCopyAll: {},
            onSave: {},
            onSaveAll: {}
        )
        .frame(width: 500, height: 400)
        .padding()
    }
}
#endif
