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
        }
        .alert(isPresented: $showDeleteAlert) {
            Alert(
                title: Text("Delete Account"),
                message: Text("Are you sure you want to delete your account?"),
                primaryButton: .destructive(Text("Delete")) {
                    deleteUser()
                    presentationMode.wrappedValue.dismiss()
                },
                secondaryButton: .cancel()
            )
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
