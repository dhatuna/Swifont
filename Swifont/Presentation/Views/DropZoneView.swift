//
//  DropZoneView.swift
//  Swifont
//
//  Created by JK on 14/1/26.
//

import SwiftUI

struct DropZoneView: View {

    @Binding var isDragOver: Bool
    let isLoading: Bool
    let hasFonts: Bool
    let onDrop: ([URL]) -> Void
    let onReset: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .fill(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            style: StrokeStyle(lineWidth: 2, dash: hasFonts ? [] : [8])
                        )
                        .foregroundColor(borderColor)
                )

            if isLoading {
                loadingContent
            } else if hasFonts {
                compactContent
            } else {
                emptyContent
            }
        }
        .frame(height: hasFonts ? 60 : 140)
        .animation(.easeInOut(duration: 0.2), value: isDragOver)
        .animation(.easeInOut(duration: 0.3), value: hasFonts)
        .onFontFileDrop(isDragOver: $isDragOver, onDrop: onDrop)
    }

    private var emptyContent: some View {
        VStack(spacing: 12) {
            Image(systemName: "arrow.down.doc")
                .font(.system(size: 32, weight: .light))
                .foregroundColor(isDragOver ? .accentColor : .secondary)

            VStack(spacing: 4) {
                Text(LocalisedString.DropZone.title)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isDragOver ? .accentColor : .primary)

                Text(LocalisedString.DropZone.subtitle)
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
        }
    }

    private var loadingContent: some View {
        HStack(spacing: 12) {
            ProgressView()
                .scaleEffect(0.8)

            Text(LocalisedString.DropZone.loading)
                .font(.system(size: 14))
                .foregroundColor(.secondary)
        }
    }

    private var compactContent: some View {
        HStack(spacing: 16) {
            Image(systemName: "plus.circle.fill")
                .font(.system(size: 20))
                .foregroundColor(.accentColor)

            Text(LocalisedString.DropZone.addMore)
                .font(.system(size: 13))
                .foregroundColor(.secondary)

            Button {
                onReset()
            } label: {
                Text(LocalisedString.DropZone.reset)
                    .font(.system(size: 13, weight: .medium))
            }
            .buttonStyle(.link)
        }
    }

    private var backgroundColor: Color {
        if isDragOver {
            return Color.accentColor.opacity(0.1)
        }
        return Color(nsColor: .controlBackgroundColor)
    }

    private var borderColor: Color {
        if isDragOver {
            return .accentColor
        }
        return Color.secondary.opacity(0.3)
    }
}

#if DEBUG
struct DropZoneView_Previews: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 20) {
            DropZoneView(
                isDragOver: .constant(false),
                isLoading: false,
                hasFonts: false,
                onDrop: { _ in },
                onReset: {}
            )

            DropZoneView(
                isDragOver: .constant(true),
                isLoading: false,
                hasFonts: false,
                onDrop: { _ in },
                onReset: {}
            )

            DropZoneView(
                isDragOver: .constant(false),
                isLoading: true,
                hasFonts: false,
                onDrop: { _ in },
                onReset: {}
            )

            DropZoneView(
                isDragOver: .constant(false),
                isLoading: false,
                hasFonts: true,
                onDrop: { _ in },
                onReset: {}
            )
        }
        .padding()
        .frame(width: 500)
    }
}
#endif
