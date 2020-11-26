//
//  ObservableSrv.swift
//  buffa
//
//  Created by Zac Zacal on 11/20/20.
//

import SwiftUI

class ViewService : ObservableObject {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(entity: Identity.entity(),
                  sortDescriptors: [],
                  predicate: NSPredicate(format: "key != ''"))
    var identities: FetchedResults<Identity>
    
    var client: SrvClientProtocol
    var key: String?
    @Published var popped: String? = nil
    @Published var isPushing: Bool = false
    @Published var isPushedSuccess: Bool?
    
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
    
    func setKey(_ key: String) -> Bool {
        self.key = key
        
        let identity = Identity(context: viewContext)
        //let identity = NSEntityDescription.insertNewObject(forEntityName: "Identity", into: viewContext) as! Identity

        identity.key = key
        identity.email = "jj"
        identity.token = "asda"
        do {
            try viewContext.save()
            return true
        } catch {
            return false
        }
    }
    
    init(_ client: SrvClientProtocol) {
        self.client = client
//        if let id = identities.first(where: { x in x.key != nil }) {
//            self.key = id.key
//        }
    }
}
