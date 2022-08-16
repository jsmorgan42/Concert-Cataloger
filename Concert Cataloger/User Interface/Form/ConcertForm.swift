//
//  ConcertForm.swift
//  Concert Cataloger
//
//  Created by Jesse Morgan on 5/31/22.
//

import SwiftUI

struct ConcertForm: View {

    @Environment(\.dismiss) var dismiss

    @State var artistName = ""
    @State var date = Date()
    @State var assets: [Asset] = []
    @State var isLoadingImages = false

    @State private var showingImagePicker = false

    @Environment(\.managedObjectContext) var managedObjectContext

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
                    ImagePicker(assets: $assets, isLoading: $isLoadingImages)
                }
                if isLoadingImages {
                    // TODO: Figure out why this isn't showing up after the first time
                    ProgressView("Loading media...")
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                } else {
                    LazyVGrid(columns: gridItems, spacing: 20) {
                        ForEach(assets, id: \.self) { asset in
                            GeometryReader { reader in
                                Image(uiImage: asset.thumbnail)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(height: reader.size.width)
                            }
                            .cornerRadius(8)
                            .clipped()
                            .aspectRatio(1, contentMode: .fit)
                        }
                    }
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button("Cancel") {
                    self.dismiss()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add") {

                    do {
                        let artist = Artist(context: managedObjectContext)
                        artist.name = artistName
                        let concert = Concert(context: managedObjectContext)
                        concert.addToArtists(artist)
                        try managedObjectContext.save()
                    } catch (let error) {
                        preconditionFailure("Failed to save new concert: \(error)")
                    }

                    self.dismiss()
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
