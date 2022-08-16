//
//  Concert_CatalogerApp.swift
//  Concert Cataloger
//
//  Created by Jesse Morgan on 5/17/22.
//

import SwiftUI

@main
struct Concert_CatalogerApp: App {

    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            HomeListView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
