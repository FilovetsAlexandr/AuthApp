//
//  AuthorizationView.swift
//  AuthApp
//
//  Created by Alexandr Filovets on 29.05.24.
//

import CoreData
import SwiftUI

struct AuthorizationView: View {
    var email: String
    @State private var password = ""
    @State private var showError = false
    @Environment(\.managedObjectContext) private var viewContext
    @State private var isAuthorized = false
    
    var body: some View {
        if isAuthorized {
            MainView(email: email)
        } else {
            VStack {
                Text("Авторизация")
                    .font(.largeTitle)
                    .padding()
                
                Text(email)
                    .padding()
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(16)
                
                if showError {
                    Text("Invalid password")
                        .foregroundColor(.red)
                }
                
                Button("Войти") {
                    if validateUser() {
                        isAuthorized = true
                    } else {
                        showError = true
                    }
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            .padding()
            .onTapGesture {
                self.hideKeyboard()
            }
        }
    }
    
    private func validateUser() -> Bool {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        do {
            let users = try viewContext.fetch(fetchRequest)
            if let user = users.first, user.password == password {
                return true
            }
        } catch {
            print("Failed to fetch user: \(error.localizedDescription)")
        }
        return false
    }
}
