//
//  InitialView.swift
//  AuthApp
//
//  Created by Alexandr Filovets on 29.05.24.
//

import CoreData
import SwiftUI

struct InitialView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isSplashActive = true
    @State private var showRegistration = false
    @State private var showUsersList = false

    var body: some View {
        NavigationView {
            Group {
                if isSplashActive {
                    SplashView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                isSplashActive = false
                                if hasRegisteredUsers() {
                                    showUsersList = true
                                } else {
                                    showRegistration = true
                                }
                            }
                        }
                } else {
                    if showUsersList {
                        UsersListView()
                            .navigationBarBackButtonHidden(true)
                            .environment(\.managedObjectContext, viewContext)
                    } else if showRegistration {
                        RegistrationView(showUsersList: $showUsersList)
                            .environment(\.managedObjectContext, viewContext)
                    }
                }
            }
        }
    }

    private func hasRegisteredUsers() -> Bool {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let count = try viewContext.count(for: fetchRequest)
            return count > 0
        } catch {
            print("Failed to fetch user count: \(error.localizedDescription)")
            return false
        }
    }
}
