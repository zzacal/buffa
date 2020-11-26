//
//  buffaApp.swift
//  buffa
//
//  Created by Zac Zacal on 11/18/20.
//

import SwiftUI

@main
struct buffaApp: App {
    let persistenceController = PersistenceController.shared
    let client = SrvClient("")

    var body: some Scene {
        WindowGroup {
            ContentView(viewService: ViewService(client))
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
