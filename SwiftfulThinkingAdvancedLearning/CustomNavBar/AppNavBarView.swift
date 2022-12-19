//
//  AppNavBarView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 19.12.22.
//

import SwiftUI

struct AppNavBarView: View {
    var body: some View {
        CustomNavView {
            ZStack {
                Color.orange.ignoresSafeArea()
                
                CustomNavLink {
                    Text("Destination")
                        .customNavigationTitle("Second Screen")
                        .customNavigationSubtitle("Subtitle should be showing!!!")
                } label: {
                    Text("Navigate")
                }
            }
            .customNavBarItems(title: "New Title", subtitle: "Subtitle", backButtonHidden: true)
        }
    }
}

struct AppNavBarView_Previews: PreviewProvider {
    static var previews: some View {
        AppNavBarView()
    }
}

extension AppNavBarView {
    
    var defaultNavView: some View {
        NavigationStack {
            ZStack {
                Color.green.ignoresSafeArea()
                
                NavigationLink {
                    Text("Destination")
                        .navigationTitle("Title 2")
                        .navigationBarBackButtonHidden(false)
                } label: {
                    Text("Navigate")
                }
            }
            .navigationTitle("Nav title here")
        }
    }
}
