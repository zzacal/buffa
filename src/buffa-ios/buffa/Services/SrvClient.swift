//
//  SrvClient.swift
//  buffa
//
//  Created by Zac Zacal on 11/20/20.
//

import Foundation

protocol SrvClientProtocol {
    func pop(key: String, handler: @escaping (String?) -> Void)
    func push(key: String, msg: String, handler: @escaping (Bool) -> Void)
    func register(name: String, password: String, handler: @escaping (String?) -> Void)
    func login(name: String, password: String, handler: @escaping (String?) -> Void)
}

class SrvClient: SrvClientProtocol {
    var serviceHost: String = ""
    func pop(key: String, handler: @escaping (String?) -> Void)  {
        get(url: "pop?key=\(key)", completionHandler: {(data: Data?) -> Void in
            if let sureData = data,
               let result = NSString(data: sureData, encoding: String.Encoding.utf8.rawValue) as String? {
                handler(result)
            } else {
                handler(nil)
            }
        })
    }
    
    func push(key: String, msg: String, handler: @escaping (Bool) -> Void) {
        do {
            let params = try JSONSerialization.data(withJSONObject: ["message": msg])
            post(url: "push?key=\(key)", data: params, completionHandler: { (data: Data?) in
                if let _ = data {
                    handler(true)
                } else {
                    handler(false)
                }
            })
        } catch {
            handler(false)
        }
    }
    
    func register(name: String, password: String, handler: @escaping (String?) -> Void) {
        do {
            let params = try JSONSerialization.data(withJSONObject: ["name": name, "password": password])
            post(url: "user", data: params) { data in
                if let response = data,
                   let body = try? JSONSerialization.jsonObject(with: response),
                   let user = body as? [String: String],
                   let key = user["key"] {
                    handler(key)
                } else  {
                    handler(nil)
                }
            }
        } catch {
            handler(nil)
        }
    }
    
    func login(name: String, password: String, handler: @escaping (String?) -> Void) {
        get(url: "user?name=\(name)&password=\(password)") { data in
            if let response = data,
               let body = try? JSONSerialization.jsonObject(with: response),
               let user = body as? [String: String],
               let key = user["key"] {
                handler(key)
            } else  {
                handler(nil)
            }
        }
    }
    
    func post(url: String, data: Data?, completionHandler: @escaping (Data?) -> Void) -> Void {
        let request = createRequest(method: "POST", path: url, params: data)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let e = error {
                print(e.localizedDescription)
                completionHandler(nil)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }
        task.resume()
    }
    
    func get(url: String, completionHandler: @escaping(Data?) -> Void) -> Void {
        let request = createRequest(method: "GET", path: url, params: nil)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let e = error {
                print(e.localizedDescription)
                completionHandler(nil)
                return
            }
            guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
                completionHandler(nil)
                return
            }
            completionHandler(data)
        }
        task.resume()
    }
    
    func createRequest(method: String, path : String, params : Data?) -> URLRequest {
        let url = address(path: path)
        var request = URLRequest(url: url)
        
        request.httpMethod = method
        request.timeoutInterval = 15.0
        if let body = params {
            request.httpBody = body
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        return request
    }
    
    func address(path: String) -> URL {        
        URL(string: "\(serviceHost)/\(path)")!
    }
    
    init(_ host: String) {
        self.serviceHost = host
    }
}

struct MockSrvClient: SrvClientProtocol {
    func register(name: String, password: String, handler: @escaping (String?) -> Void) {
        handler("testkey")
    }
    
    func login(name: String, password: String, handler: @escaping (String?) -> Void) {
        handler("testkey")
    }
    
    func pop(key: String, handler: @escaping (String?) -> Void) -> Void {
        handler("test")
    }
    func push(key: String, msg: String, handler: @escaping (Bool) -> Void) -> Void {
        handler(true)
    }
}
