//
//  UserLogin.swift
//  buffa
//
//  Created by Zac Zacal on 11/18/20.
//

import SwiftUI

struct UserLogin: View {
    @ObservedObject var viewService: ViewService
    @State var username: String = ""
    @State var password: String = ""
    
    var body: some View {
        VStack {
            TextBox(placeholder: "Email",
                      text: $username)
            TextBox(placeholder: "Password",
                      text: $password)
            Btn(label: "Login", action: {
                viewService.login(username, password)
            })
        }
    }
}

struct UserLogin_Previews: PreviewProvider {
    static var previews: some View {
        UserLogin(viewService: ViewService(MockSrvClient()))
    }
}
