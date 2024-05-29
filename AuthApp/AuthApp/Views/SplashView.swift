//
//  SplashView.swift
//  AuthApp
//
//  Created by Alexandr Filovets on 29.05.24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        VStack {
            Image("launchImage")
                .resizable()
                .scaledToFit()
                .edgesIgnoringSafeArea(.all)
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(2)
        }
    }
}
