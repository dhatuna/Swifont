//
//  FileDropDelegate.swift
//  Swifont
//
//  Created by JK on 12/1/26.
//

import SwiftUI
import UniformTypeIdentifiers

struct FontFileDropDelegate: DropDelegate {
    @Binding var isDragOver: Bool

    let onDrop: ([URL]) -> Void

    private static let supportedTypes: [UTType] = [
        .font,
        UTType(filenameExtension: "otf") ?? .font,
        UTType(filenameExtension: "ttf") ?? .font,
        UTType(filenameExtension: "ttc") ?? .font,
    ]

    func validateDrop(info: DropInfo) -> Bool {
        return info.hasItemsConforming(to: Self.supportedTypes)
    }

    func dropEntered(info: DropInfo) {
        isDragOver = true
    }

    func dropExited(info: DropInfo) {
        isDragOver = false
    }

    func performDrop(info: DropInfo) -> Bool {
        isDragOver = false

        let providers = info.itemProviders(for: Self.supportedTypes)

        guard !providers.isEmpty else { return false }

        Task {
            var urls: [URL] = []

            for provider in providers {
                if let url = await loadFileURL(from: provider) {
                    urls.append(url)
                }
            }

            if !urls.isEmpty {
                await MainActor.run {
                    onDrop(urls)
                }
            }
        }

        return true
    }

    private func loadFileURL(from provider: NSItemProvider) async -> URL? {
        if provider.hasItemConformingToTypeIdentifier(UTType.fileURL.identifier) {
            
            return await withCheckedContinuation { continuation in
                
                provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, error in
                    if let data = item as? Data,
                       let url = URL(dataRepresentation: data, relativeTo: nil) {
                        continuation.resume(returning: url)
                    } else if let url = item as? URL {
                        continuation.resume(returning: url)
                    } else {
                        continuation.resume(returning: nil)
                    }
                }
            }
        }
        
        
        for type in Self.supportedTypes {
            if provider.hasItemConformingToTypeIdentifier(type.identifier) {
                return await withCheckedContinuation { continuation in
                    provider.loadItem(forTypeIdentifier: type.identifier, options: nil) { item, error in
                        if let url = item as? URL {
                            continuation.resume(returning: url)
                        } else if let data = item as? Data,
                                  let url = URL(dataRepresentation: data, relativeTo: nil) {
                            continuation.resume(returning: url)
                        } else {
                            continuation.resume(returning: nil)
                        }
                    }
                }
            }
        }

        return nil
    }
}

extension View {
    func onFontFileDrop(isDragOver: Binding<Bool>, onDrop: @escaping ([URL]) -> Void) -> some View {
        self.onDrop(of: [.fileURL, .font], delegate: FontFileDropDelegate(isDragOver: isDragOver, onDrop: onDrop))
    }
}
