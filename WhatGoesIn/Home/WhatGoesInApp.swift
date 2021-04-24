//
//  WhatGoesInApp.swift
//  WhatGoesIn
//
//  Created by Daniel Levi-Minzi on 2/15/21.
//

import SwiftUI

@main
struct WhatGoesInApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
