//
//  AuthAppApp.swift
//  AuthApp
//
//  Created by Alexandr Filovets on 29.05.24.
//

import SwiftUI

@main
struct AuthAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            InitialView()
                .environment(\.managedObjectContext, persistenceController.viewContext)
        }
    }
}
