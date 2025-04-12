//
//  SlipBoxProjectApp.swift
//  SlipBoxProject
//
//  Created by Claudia Maciel on 4/11/25.
//

import SwiftUI

@main
struct SlipBoxProjectApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
