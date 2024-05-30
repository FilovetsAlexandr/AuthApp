//
//  MainView.swift
//  AuthApp
//
//  Created by Alexandr Filovets on 29.05.24.
//

import CoreData
import SwiftUI

struct MainView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    
    var email: String
    @State private var showDeleteAlert = false
    
    var body: some View {
        VStack {
            HStack {
                Button (action: {
                    navigateToUserListView()
                }) {
                    HStack {
                        Image (systemName: "chevron.backward")
                            .font(.title2)
                        Text ("Users")
                            .font(.title2)
                    }
                }
                .padding()
                Spacer()
            }
            Spacer()
            Text("Welcome, \(email)")
                .font(.largeTitle)
                .padding()
            
            Button("Delete Account") {
                showDeleteAlert.toggle()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(8)
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Account"),
                message: Text("Are you sure you want to delete your account?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteUser()
                    checkUsersAndNavigate()
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private func checkUsersAndNavigate() {
        // Переход на экраны в зависимости если люди в бд
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        do {
            let users = try viewContext.fetch(fetchRequest)
            if users.isEmpty {
                navigateToRegistrationView()
            } else {
                navigateToUserListView()
            }
        } catch {
            print ("Failed to fetch users: \(error.localizedDescription)")
        }
    }
    
    private func navigateToRegistrationView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: RegistrationView(showUsersList: .constant(false)).environment(\.managedObjectContext, viewContext))
            window.makeKeyAndVisible()
        }
    }
    
    private func navigateToUserListView() {
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController = UIHostingController(rootView: UsersListView().environment(\.managedObjectContext, viewContext))
            window.makeKeyAndVisible()
        }
    }
    
    private func deleteUser() {
        let fetchRequest: NSFetchRequest<User> = User.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "email == %@", email)
        do {
            let users = try viewContext.fetch(fetchRequest)
            if let user = users.first {
                viewContext.delete(user)
                try viewContext.save()
            }
        } catch {
            print("Failed to delete user: \(error.localizedDescription)")
        }
    }
}
