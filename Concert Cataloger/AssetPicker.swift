//
//  ImagePicker.swift
//  Concert Cataloger
//
//  Created by Jesse Morgan on 5/31/22.
//

import PhotosUI
import SwiftUI
import QuickLook

protocol CoordinatorDelegate {
    func didFinishPickingAssets(_ assets: [Asset])
    func didUpdateLoadingState(_ isLoading: Bool)
}

struct ImagePicker: UIViewControllerRepresentable, CoordinatorDelegate {

    @Binding var assets: [Asset]
    @Binding var isLoading: Bool

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration(photoLibrary: PHPhotoLibrary.shared())
        config.selectionLimit = 0
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }

    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {
        
    }

    func makeCoordinator() -> Coordinator {
        let coordinator = Coordinator()
        coordinator.delegate = self
        return coordinator
    }

    // MARK: CoordinatorDelegate

    func didFinishPickingAssets(_ assets: [Asset]) {
        self.assets = assets
    }

    func didUpdateLoadingState(_ isLoading: Bool) {
        self.isLoading = isLoading
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var delegate: CoordinatorDelegate?

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            delegate?.didUpdateLoadingState(true)
            picker.dismiss(animated: true)

            var assets: [Asset] = []

            results.enumerated().forEach { (index, result) in
                let provider = result.itemProvider
                if provider.canLoadObject(ofClass: UIImage.self) {
                    provider.loadObject(ofClass: UIImage.self) { image, error in
                        if let error = error {
                            print("*** Error: \(error)")
                        }

                        guard let image = image as? UIImage else {
                            print("*** Nil image")
                            return
                        }

                        assets.append(Asset(thumbnail: image, assetIdentifier: result.assetIdentifier))

                        if index == results.count - 1 {
                            DispatchQueue.main.async {
                                self.delegate?.didFinishPickingAssets(assets)
                                self.delegate?.didUpdateLoadingState(false)
                            }
                        }
                    }
                }

                if provider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                    provider.loadItem(forTypeIdentifier: UTType.movie.identifier, options: [:]) { (videoURL, error) in
                        DispatchQueue.main.async {
                            guard let url = videoURL as? URL else {
                                print("*** Invalid video URL")
                                return
                            }

                            let request = QLThumbnailGenerator.Request.init(fileAt: url, size: .init(width: 100, height: 100), scale: 1.0, representationTypes: .thumbnail)

                            let generator = QLThumbnailGenerator.shared

                            generator.generateBestRepresentation(for: request) { thumbnail, error in
                                if let error = error {
                                    print(error)
                                }

                                guard let cgImage = thumbnail?.cgImage else {
                                    print("*** Could not generate image")
                                    return
                                }

                                assets.append(Asset(thumbnail: UIImage(cgImage: cgImage),
                                                    assetIdentifier: result.assetIdentifier))

                                if index == results.count - 1 {
                                    picker.dismiss(animated: true)
                                    self.delegate?.didFinishPickingAssets(assets)
                                    self.delegate?.didUpdateLoadingState(false)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
