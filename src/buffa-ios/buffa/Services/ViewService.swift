//
//  ObservableSrv.swift
//  buffa
//
//  Created by Zac Zacal on 11/20/20.
//

import SwiftUI
import Foundation
import CoreData

class ViewService : ObservableObject {
    var viewContext: NSManagedObjectContext?
    
    var client: SrvClientProtocol
    var key: String?
    @Published var popped: String? = nil
    @Published var isPushing: Bool = false
    @Published var isPushedSuccess: Bool?
    @Published var dates: [Date] = []
    
    func pop() {
        if let key = self.key {
            client.pop(key: key, handler: {msg in
                if let msg = msg {
                    self.popped = msg
                }
            })
        }
    }
    
    func push(_ msg: String) {
        isPushing = true
        if let key = self.key {
            client.push(key: key, msg: msg, handler: {result in
                self.isPushing = false
                self.isPushedSuccess = result
            })
        }
    }

    func setKey(_ name: String) {
        
    }

    func addItem() {
        if let context = viewContext {
            let newItem = Identity(context: context)
            newItem.timestamp = Date()
            
            getItems()
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    func deleteItems(offsets: IndexSet) {
        if let context = viewContext {
            let fetchRequet = NSFetchRequest<NSManagedObject>(entityName: "Identity")

            withAnimation {
                do {
                    let results = try context.fetch(fetchRequet)
                    offsets.map { results[$0] }.forEach(context.delete)
                    
                    getItems()
                    try context.save()
                } catch {
                    // Replace this implementation with code to handle the error appropriately.
                    // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
            }
        }
    }
    
    func getItems(){
        if let context = viewContext {
            let fetchRequet = NSFetchRequest<NSManagedObject>(entityName: "Identity")
            do {
                let results = try context.fetch(fetchRequet)
                publishItems(objs: results)
            } catch {
                print("nope")
            }
        }
    }
    
    private func publishItems(objs: [NSManagedObject]) {
        dates = objs.map { result in result.value(forKey: "timestamp") as! Date}
    }
    
    init(_ client: SrvClientProtocol) {
        self.client = client
    }
    
    init(_ client: SrvClientProtocol, _ viewContext: NSManagedObjectContext) {
        self.client = client
        self.viewContext = viewContext
        getItems()
    }
}