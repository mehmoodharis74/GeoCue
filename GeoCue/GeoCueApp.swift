//
//  GeoCueApp.swift
//  GeoCue
//
//  Created by Haris  on 14/02/2025.
//

import SwiftUI

@main
struct GeoCueApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
