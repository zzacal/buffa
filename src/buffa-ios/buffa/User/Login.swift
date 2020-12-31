//
//  UserLogin.swift
//  buffa
//
//  Created by Zac Zacal on 11/18/20.
//

import SwiftUI

struct Login: View {
    @ObservedObject var viewService: ViewService
    @State var name: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack {
            TextBox(placeholder: "Email",
                    text: $name, textCap: .none)
            TextBox(placeholder: "Password",
                    text: $password, textCap: .none)
            HStack {
                Btn(label: "Register", action: {
                    viewService.register(name, password)
                })
                
                Btn(label: "Login", action: {
                    viewService.login(name, password)
                })
            }
        }
    }
    
    init(service: ViewService) {
        viewService = service
        name = viewService.name ?? ""
        password = viewService.password ?? ""
    }
}

struct UserLogin_Previews: PreviewProvider {
    static var previews: some View {
        Login(service: ViewService(MockSrvClient()))
    }
}
