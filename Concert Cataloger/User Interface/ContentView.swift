//
//  ContentView.swift
//  Concert Cataloger
//
//  Created by Jesse Morgan on 5/17/22.
//

import SwiftUI

struct ContentView: View {

    private var gridItems = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]

    @State private var showingForm = false

    var body: some View {
        NavigationView {
            ScrollView {
//                LazyVGrid(columns: gridItems, spacing: 20) {
//                    ForEach((0...10), id: \.self) { _ in
//                        Image(systemName: "music.mic")
//                    }
//                }
                Button("create concert") {
                    showingForm.toggle()
                }
                .sheet(isPresented: $showingForm) {
                    ConcertForm()
                }
            }

        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
