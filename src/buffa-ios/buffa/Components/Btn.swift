//
//  Btn.swift
//  buffa
//
//  Created by Zac Zacal on 11/18/20.
//

import SwiftUI

struct Btn: View {
    var label: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Spacer()
            Text(label)
            Spacer()
        }
    }
}

struct Btn_Previews: PreviewProvider {
    static var previews: some View {
        Btn(label: "Button", action: {})
    }
}
