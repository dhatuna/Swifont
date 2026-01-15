//
//  MainView.swift
//  Swifont
//
//  Created by JK on 13/1/26.
//

import SwiftUI

struct MainView: View {

    @StateObject private var viewModel: FontAnalyzerViewModel

    init(viewModel: FontAnalyzerViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(spacing: 0) {
            DropZoneView(
                isDragOver: $viewModel.isDragOver,
                isLoading: viewModel.isLoading,
                hasFonts: viewModel.hasFonts,
                onDrop: handleDrop,
                onReset: viewModel.reset
            )
            .padding()

            if let error = viewModel.errorMessage {
                errorBanner(message: error)
            }

            if viewModel.hasFonts {
                mainContent
            } else {
                emptyStateView
            }
        }
        .frame(minWidth: 900, minHeight: 600)
        .background(Color(nsColor: .windowBackgroundColor))
    }

    private var mainContent: some View {
        HSplitView {
            VStack(spacing: 12) {
                FontListView(
                    families: viewModel.fontFamilies,
                    selectedFamily: $viewModel.selectedFamily
                )

                if let family = viewModel.selectedFamily {
                    FontDetailView(family: family)
                }
            }
            .frame(minWidth: 280, idealWidth: 320, maxWidth: 400)
            .padding(.leading)
            .padding(.bottom)

            CodePreviewView(
                code: viewModel.selectedCode,
                familyName: viewModel.selectedFamily?.swiftEnumName,
                onCopy: { viewModel.copyCodeToClipboard(allFamilies: false) },
                onCopyAll: { viewModel.copyCodeToClipboard(allFamilies: true) },
                onSave: { viewModel.saveCodeToFile(allFamilies: false) },
                onSaveAll: { viewModel.saveCodeToFile(allFamilies: true) }
            )
            .frame(minWidth: 400)
            .padding(.trailing)
            .padding(.bottom)
        }
    }

    private var emptyStateView: some View {
        VStack(spacing: 16) {
            Image(systemName: "text.badge.plus")
                .font(.system(size: 48, weight: .ultraLight))
                .foregroundColor(.secondary.opacity(0.5))

            VStack(spacing: 4) {
                Text(LocalisedString.Empty.title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.secondary)

                Text(LocalisedString.Empty.subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.secondary.opacity(0.8))
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    
    private func errorBanner(message: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: "exclamationmark.triangle.fill")
                .foregroundColor(.orange)

            Text(message)
                .font(.system(size: 12))

            Spacer()

            Button {
                withAnimation {
                    viewModel.errorMessage = nil
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.secondary)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.orange.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .padding(.horizontal)
    }

    private func handleDrop(urls: [URL]) {
        Task {
            await viewModel.analyzeFonts(urls: urls)
        }
    }
}

#if DEBUG
struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        let repository = FontRepository()
        let analyzeUseCase = AnalyzeFontUseCase(repository: repository)
        let generateUseCase = GenerateCodeUseCase(repository: repository)
        let viewModel = FontAnalyzerViewModel(
            analyzeFontUseCase: analyzeUseCase,
            generateCodeUseCase: generateUseCase
        )

        MainView(viewModel: viewModel)
    }
}
#endif
