//
//  Command.swift
//  buffa
//
//  Created by Zac Zacal on 11/19/20.
//

import SwiftUI

struct Command: View {
    @State var currentLine: String
    var body: some View {
        VStack{
            TextBox(placeholder: "",
                    text: $currentLine)
            Btn(label: "Push", action: {})
        }
    }
}

struct Command_Previews: PreviewProvider {
    static var previews: some View {
        Command(currentLine: "sdasd")
    }
}
