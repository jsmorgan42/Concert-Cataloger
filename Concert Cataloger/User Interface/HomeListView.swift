//
//  HomeListView.swift
//  Concert Cataloger
//
//  Created by Jesse Morgan on 5/17/22.
//

import CoreData
import SwiftUI

struct HomeListView: View {

    private var gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    @State private var showingForm = false

    @FetchRequest(sortDescriptors: []) var concerts: FetchedResults<Concert>

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: gridItems, spacing: 20) {
                    ForEach(concerts) { concert in
                        Text(concert.firstArtistName)
//                        Text(concert.artists.first?.displayName ?? "concert")
                    }
                }
                Button("create concert") {
                    showingForm.toggle()
                }
                .sheet(isPresented: $showingForm) {
                    NavigationView {
                        ConcertForm()
                    }
                }
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeListView()
    }
}
