//
//  TextBox.swift
//  buffa
//
//  Created by Zac Zacal on 11/18/20.
//

import SwiftUI

struct TextBox: View {
    @State var placeholder: String = ""
    @Binding var text: String
    
    var textCap: UITextAutocapitalizationType = .none
    
    var body: some View {
        TextField(placeholder, text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .cornerRadius(3, antialiased: true)
            .textCase(.none)
            .padding(8).autocapitalization(textCap)
    }
}

struct TextBox_Previews: PreviewProvider {
    static var previews: some View {
        TextBox(placeholder: "Email",
                text: .constant(""))
    }
}
