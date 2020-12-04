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
    var body: some Scene {
        WindowGroup {
            ContentView(viewService: ViewService(SrvClient("https://buffa-srv.azurewebsites.net"), persistenceController.container.viewContext))
        }
    }
}
