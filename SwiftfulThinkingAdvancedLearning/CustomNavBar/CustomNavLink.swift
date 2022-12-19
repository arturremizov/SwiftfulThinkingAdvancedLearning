//
//  CustomNavLink.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 19.12.22.
//

import SwiftUI

struct CustomNavLink<Label: View, Destination: View>: View {
    
    private let navigationLink: NavigationLink<Label, CustomNavBarContainerView<Destination>>
    
    init(@ViewBuilder destination: () -> Destination, @ViewBuilder label: () -> Label) {
        navigationLink = NavigationLink(destination: {
            CustomNavBarContainerView(content: destination)
                
        }, label: label)
    }
    
    var body: some View {
        navigationLink
    }
}

struct CustomNavLink_Previews: PreviewProvider {
    static var previews: some View {
        CustomNavView {
            CustomNavLink {
                Text("Destination")
            } label: {
                Text("Navigate")
            }
        }
    }
}
