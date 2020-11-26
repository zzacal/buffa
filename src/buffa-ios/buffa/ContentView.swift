//
//  ContentView.swift
//  buffa
//
//  Created by Zac Zacal on 11/18/20.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @ObservedObject var viewService: ViewService
    @State var stackName: String = ""
    var body: some View {
        // Command(currentLine: currentLine)
        SetStack(viewService: viewService)
    }
    
    init(viewService: ViewService) {
        self.viewService = viewService
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewService: ViewService(MockSrvClient()))
    }
}
