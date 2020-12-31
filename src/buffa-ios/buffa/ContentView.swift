//
//  ContentView.swift
//  buffa
//
//  Created by Zac Zacal on 11/25/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var viewService: ViewService
    var body: some View {
        if viewService.key == nil {
            switch viewService.userView {
            case "register":
                Register(service: viewService)
            case "login":
                Login(service: viewService)
            default:
                Register(service: viewService)
            }
        } else {
            Command(viewService: viewService, currentLine: "")
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewService: ViewService(MockSrvClient()))
    }
}
