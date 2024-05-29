//
//  UserListView.swift
//  AuthApp
//
//  Created by Alexandr Filovets on 29.05.24.
//

import CoreData
import SwiftUI

struct UsersListView: View {
    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: []
    ) var users: FetchedResults<User>

    @State private var showRegistration = false

    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(users, id: \.self) { user in
                        NavigationLink(destination: AuthorizationView(email: user.email ?? "")) {
                            Text(user.email ?? "")
                        }
                    }
                }

                VStack {
                    Spacer()
                    Button("Регистрация") {
                        showRegistration.toggle()
                    }
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding()
                }
            }
        }
        .sheet(isPresented: $showRegistration) {
            RegistrationView(showUsersList: .constant(false))
        }
    }
}
