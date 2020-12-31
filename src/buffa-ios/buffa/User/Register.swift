//
//  Register.swift
//  buffa
//
//  Created by Zac Zacal on 12/30/20.
//

import SwiftUI

struct Register: View {
    @ObservedObject var viewService: ViewService
    @State var name: String = ""
    @State var password: String = ""
    @State var passwordConfirm: String = ""
    
    var body: some View {
        VStack {
            TextBox(placeholder: "Email",
                    text: $name, textCap: .none)
            TextBox(placeholder: "Password",
                    text: $password, textCap: .none)
            TextBox(placeholder: "Confirm Password",
                      text: $passwordConfirm, textCap: .none)
            HStack {
                Btn(label: "Login", action: {
                    viewService.login(name, password)
                })
                
                Btn(label: "Register", action: {
                    viewService.register(name, password)
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

struct Register_Previews: PreviewProvider {
    static var previews: some View {
        Register(service: ViewService(MockSrvClient()))
    }
}
