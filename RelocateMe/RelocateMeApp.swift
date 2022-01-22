//
//  RelocateMeApp.swift
//  RelocateMe
//
//  Created by MidnightChips on 1/10/22.
//

import SwiftUI

@main
struct RelocateMeApp: App {
    @StateObject var envModel = EnviromentModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(envModel)
        }
    }
}
