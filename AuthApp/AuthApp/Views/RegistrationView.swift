//
//  RegistrationView.swift
//  AuthApp
//
//  Created by Alexandr Filovets on 29.05.24.
//

import CoreData
import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var showError = false
    @Binding var showUsersList: Bool
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            Text("Регистрация")
                .font(.largeTitle)
                .padding()
            
            TextField("Email", text: $email)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(16)
            
            if showError {
                Text("Invalid email or password")
                    .foregroundColor(.red)
            }
            
            Button("Зарегистрироваться") {
                if validateFields() {
                    saveUser()
//                    showUsersList = true
                    navigateToMainView()
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
    
    private func validateFields() -> Bool {
        let emailRegEx = "^[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-]+(\\.[\\p{L}0-9!#$%&'*+\\/=?^_`{|}~-]+)*@[\\p{L}0-9-]+(\\.[\\p{L}0-9-]+)*\\.([\\p{L}]{2,})$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email) && password.count >= 8
    }
    
    private func navigateToMainView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: MainView(email: email)
                .environment(\.managedObjectContext, viewContext))
            window.makeKeyAndVisible()
        }
    }
    
    private func saveUser() {
        let newUser = User(context: viewContext)
        newUser.email = email
        newUser.password = password
        do {
            try viewContext.save()
        } catch {
            print("Failed to save user: \(error.localizedDescription)")
        }
    }
}

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
