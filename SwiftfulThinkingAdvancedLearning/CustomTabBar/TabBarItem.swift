//
//  TabBarItem.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 18.12.22.
//

import SwiftUI

//struct TabBarItem: Hashable {
//    let iconName: String
//    let title: String
//    let color: Color
//}

enum TabBarItem: Hashable, CaseIterable {
    
    case home, favorites, profile, messages
    
    var iconName: String {
        switch self {
        case .home:
            return "house.fill"
        case .favorites:
            return "heart.fill"
        case .profile:
            return "person.fill"
        case .messages:
            return "message.fill"
        }
    }
    
    var title: String {
        switch self {
        case .home:
            return "Home"
        case .favorites:
            return "Favorites"
        case .profile:
            return "Profile"
        case .messages:
            return "Messages"
        }
    }
    
    var color: Color {
        switch self {
        case .home:
            return .red
        case .favorites:
            return .blue
        case .profile:
            return .green
        case .messages:
            return .orange
        }
    }
}

