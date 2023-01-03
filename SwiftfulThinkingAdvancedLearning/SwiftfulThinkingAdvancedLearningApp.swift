//
//  SwiftfulThinkingAdvancedLearningApp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 9.12.22.
//

import SwiftUI

@main
struct SwiftfulThinkingAdvancedLearningApp: App {
    
    let isCurrentUserSignedIn: Bool
    
    init() {
//        let userIsSignedIn: Bool =  CommandLine.arguments.contains("-UITest_startSignIn") ? true : false
        let userIsSignedIn: Bool = ProcessInfo.processInfo.arguments.contains("-UITest_startSignIn") ? true : false
//        let value = ProcessInfo.processInfo.environment["-UITest_startSignIn2"]
//        let userIsSignedIn: Bool = value == "true" ? true : false
        self.isCurrentUserSignedIn = userIsSignedIn
    }
    
    var body: some Scene {
        WindowGroup {
//            UITestingBootcampView(isCurrentUserSignedIn: isCurrentUserSignedIn)
            CloudKitCrudBootcamp()
        }
    }
}
