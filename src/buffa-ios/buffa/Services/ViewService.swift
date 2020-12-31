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
    var storageContext: NSManagedObjectContext?
    var client: SrvClientProtocol
    @Published var name: String?
    @Published var password: String?
    @Published var key: String?
    @Published var popped: String? = nil
    @Published var isPushing: Bool = false
    @Published var isPushedSuccess: Bool?
    @Published var userView: String?
    
    func pop(completion: @escaping (String) -> Void) {
        if let key = self.key {
            client.pop(key: key, handler: { result in
                if let msg = result {
                    DispatchQueue.main.async {
                        self.popped = msg
                    }
                    completion(msg)
                }
            })
        }
    }
    
    func push(_ msg: String, completion: @escaping () -> Void) {
        isPushing = true
        if let key = self.key {
            client.push(key: key, msg: msg, handler: {result in
                DispatchQueue.main.async {
                    self.isPushing = false
                    self.isPushedSuccess = result
                }
                completion()
            })
        }
    }
    
    func register(_ name: String, _ password: String) {
        guard self.userView == "register" else {
            self.userView = "register"
            return
        }

        client.register(name: name, password: password) { (result) in
            if let key = result {
                self.saveIdentity(key: key, completion: self.useResultKey(_:))
            }
        }
    }
    
    func login(_ name: String, _ password: String) {
        guard self.userView == "login" else {
            self.userView = "login"
            return
        }
        
        client.login(name: name, password: password) { (result) in
            if let key = result {
                self.saveIdentity(key: key, completion: self.useResultKey(_:))
            }
        }
    }

    func setKey(_ name: String) {
        key = name
        saveIdentity(key: name, completion: useResultKey(_:))
    }
    
    func useResultKey(_ result: Result<Identity, Error>) {
        switch result {
        case .success(let identity):
            DispatchQueue.main.async {
                self.key = identity.key
            }
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    func logOut() {
        deleteIdentity(completion: {result in
            switch result {
            case .success(_):
                self.key = nil
                self.userView = "login"
            case .failure(_): break
            }
        })
    }
    
    init(_ client: SrvClientProtocol) {
        self.client = client
    }
    
    init(_ client: SrvClientProtocol, _ viewContext: NSManagedObjectContext) {
        self.client = client
        self.storageContext = viewContext
        getIdentity(completion: { result in
            switch result {
            case .success(let found):
                if let identity = found {
                    self.key = identity.key
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        })
    }
}

extension ViewService {
    func saveIdentity(key: String, completion: (Result<Identity, Error>) -> Void) {
        if let context = storageContext {
            let newItem = Identity(context: context)
            newItem.timestamp = Date()
            newItem.key = key
            
            do {
                try context.save()
                completion(.success(newItem))
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                //fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                
                completion(.failure(nsError))
            }
        }
    }
    
    func deleteIdentity(completion: (Result<Bool, Error>) -> Void) {
        if let context = storageContext {
            let fetchRequest = NSFetchRequest<Identity>(entityName: "Identity")
            
            do {
                let results = try context.fetch(fetchRequest)
                results.forEach(context.delete)
                
                completion(.success(true))
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    func getIdentity(completion: (Result<Identity?, Error>) -> Void) {
        if let context = storageContext {
            let fetchRequest = NSFetchRequest<Identity>(entityName: "Identity")
            fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Identity.timestamp, ascending: true)]
            do {
                let results = try context.fetch(fetchRequest)
                completion(.success(results.first))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
