//
//  SetStack.swift
//  buffa
//
//  Created by Zac Zacal on 11/24/20.
//

import SwiftUI

struct SetStack: View {
    @ObservedObject var viewService: ViewService
    @State var stackName: String = ""
    var body: some View {
        VStack {
            TextBox(placeholder: "Stack", text: $stackName)
            Btn(label: "Use Stack") {
                viewService.setKey(stackName)
            }
        }
    }
}

struct SetStack_Previews: PreviewProvider {
    static var previews: some View {
        SetStack(viewService: ViewService(MockSrvClient()))
    }
}
