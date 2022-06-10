//
//  ImagePicker.swift
//  Concert Cataloger
//
//  Created by Jesse Morgan on 5/31/22.
//

import PhotosUI
import SwiftUI

protocol CoordinatorDelegate {
    func didFinishPickingImages(_ images: [UIImage])
    func didUpdateLoadingState(_ isLoading: Bool)
}

struct ImagePicker: UIViewControllerRepresentable, CoordinatorDelegate {

    @Binding var images: [UIImage]?
    @Binding var isLoading: Bool

    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.selectionLimit = 0
        config.filter = .images
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

    func didFinishPickingImages(_ images: [UIImage]) {
        self.images = images
        print("*** Images Loaded: \(images.count)")
    }

    func didUpdateLoadingState(_ isLoading: Bool) {
        self.isLoading = isLoading
        print("*** isLoading Updated: \(isLoading)")
    }

    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        var delegate: CoordinatorDelegate?

        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            delegate?.didUpdateLoadingState(true)
            picker.dismiss(animated: true)
            print("*** Did Dismiss")

            var images: [UIImage] = []

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
                        images.append(image)

                        if index == results.count - 1 {
                            self.delegate?.didFinishPickingImages(images)
                            self.delegate?.didUpdateLoadingState(false)
                        }
                    }
                }
            }
        }
    }
}
