//
//  MaxPointsApp.swift
//  MaxPoints
//
//  Created by Max Hakin on 24/07/2024.
//

import SwiftUI

@main
struct MaxPointsApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
