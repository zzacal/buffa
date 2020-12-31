//
//  Command.swift
//  buffa
//
//  Created by Zac Zacal on 11/19/20.
//

import SwiftUI

struct Command: View {
    @ObservedObject var viewService: ViewService
    @State var currentLine: String
    var body: some View {
        VStack {
            VStack {
                Btn(label: "Log out", action: { viewService.logOut() })
            }
            Spacer()
            VStack {
                Spacer()
                TextBox(placeholder: "", text: $currentLine, textCap: .none)
                
                HStack {
                    Btn(label: "Pop", action: { viewService.pop(completion: { msg in currentLine = msg }) })
                    Btn(label: "Push", action: { viewService.push(currentLine, completion: { currentLine = ""} ) })
                }
            }
        }
    }
}

struct Command_Previews: PreviewProvider {
    static var previews: some View {
        Command(viewService: ViewService(MockSrvClient()), currentLine: "sdasd")
    }
}
