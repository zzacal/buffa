//
//  ObservableSrv.swift
//  buffa
//
//  Created by Zac Zacal on 11/20/20.
//

import Foundation

class ObservableSrv : ObservableObject {
    var client: SrvClientProtocol
    @Published var popped: String? = nil
    @Published var isPushing: Bool = false
    @Published var isPushedSuccess: Bool?
    
    func pop() {
        client.pop(handler: {msg in
            if let msg = msg {
                self.popped = msg
            }
        })
    }
    
    func push(msg: String) {
        isPushing = true
        client.push(msg: msg, handler: {result in
            self.isPushing = false
            self.isPushedSuccess = result
        })
    }
    
    init(_ client: SrvClientProtocol) {
        self.client = client
    }
}
