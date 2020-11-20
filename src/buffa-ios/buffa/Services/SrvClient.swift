//
//  SrvClient.swift
//  buffa
//
//  Created by Zac Zacal on 11/20/20.
//

import Foundation

protocol SrvClientProtocol {
    func pop(handler: @escaping (String?) -> Void) -> Void
    func push(msg: String, handler: @escaping (Bool) -> Void) -> Void
}

class SrvClient: SrvClientProtocol {
    var serviceHost: String = ""
    
    func pop(handler: @escaping (String?) -> Void) -> Void  {
        get(url: "pop", completionHandler: {(data: Data?) -> Void in
            if let sureData = data,
               let result = NSString(data: sureData, encoding: String.Encoding.utf8.rawValue) as String? {
                handler(result)
            } else {
                handler(nil)
            }
        })
    }
    
    func push(msg: String, handler: @escaping (Bool) -> Void) -> Void {
        do {
            let params = try JSONSerialization.data(withJSONObject: ["message": msg])
            post(url: "push", data: params, completionHandler: { (data: Data?) in
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
    
    init(_ host: String, _ apiKey: String) {
        self.serviceHost = host
    }
}
