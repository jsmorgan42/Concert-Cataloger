//
//  ConcertForm.swift
//  Concert Cataloger
//
//  Created by Jesse Morgan on 5/31/22.
//

import SwiftUI

struct ConcertForm: View {

    @Environment(\.presentationMode) var presentation

    @State var artistName = ""
    @State var date = Date()
    @State var images: [UIImage]?
    @State var isLoadingImages = false

    @State private var showingImagePicker = false

    private var gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    var isFormIncomplete: Bool {
        artistName.isEmpty
    }

    var body: some View {
        NavigationView {
            Form {
                TextField("Artist Name", text: $artistName)
                DatePicker("Date", selection: $date, displayedComponents: [.date])
                Button("Add Images") {
                    showingImagePicker.toggle()
                }
                .sheet(isPresented: $showingImagePicker) {
                    ImagePicker(images: $images, isLoading: $isLoadingImages)
                }
                if isLoadingImages {
                    // TODO: Figure out why this isn't showing up after the first time
                    ProgressView("Loading images...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                } else {
                    LazyVGrid(columns: gridItems, spacing: 20) {
                        ForEach(images ?? [], id: \.self) { image in
                            GeometryReader { reader in
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: reader.size.width)
                            }
                            .clipped()
                            .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Submit") {
                    self.presentation.wrappedValue.dismiss()
                }
                .disabled(isFormIncomplete)
            }
        }


    }
}

struct ConcertForm_Previews: PreviewProvider {
    static var previews: some View {
        ConcertForm()
    }
}
