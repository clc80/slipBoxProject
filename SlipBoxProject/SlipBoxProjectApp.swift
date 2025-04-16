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

    @Environment(\.scenePhase) var scenePhase

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
        .onChange(of: scenePhase) { _, newScenePhase in
            switch newScenePhase {
            case .active:
                print("app became active")
            case .inactive:
                print("app became inavtive")
            case .background:
                persistenceController.save()
                print("app entered background")
            @unknown default:
                print("app entered unknon case")
            }
        }
        .commands {
            CommandGroup(replacing: .saveItem) {
                Button ("Save") {
                    persistenceController.save()
                }
                .keyboardShortcut("S", modifiers: [.command])
            }
        }
    }
}
