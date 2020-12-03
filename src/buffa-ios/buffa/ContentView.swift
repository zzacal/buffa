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
        Button("Add") {
            addItem()
        }
        List {
            ForEach(viewService.dates, id: \.self) { item in
                Text("Item at \(item, formatter: itemFormatter)")
            }
            .onDelete(perform: deleteItems)
        }
        .toolbar {
            #if os(iOS)
            EditButton()
            #endif

            Button(action: addItem) {
                Label("Add Item", systemImage: "plus")
            }
        }
    }

    private func addItem() {
        viewService.addItem()
        viewService.getItems()
    }

    private func deleteItems(offsets: IndexSet) {
        viewService.deleteItems(offsets: offsets)
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
