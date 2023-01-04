//
//  CloudKitPushNotificationBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 4.01.23.
//

import SwiftUI
import CloudKit

class CloudKitPushNotificationBootcampViewModel: ObservableObject {
    
    func requestNotificationPermissions() async {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        do {
            let success = try await UNUserNotificationCenter.current().requestAuthorization(options: options)
            if success {
                print("Notification permission success!")
                await MainActor.run {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            } else {
                print("Notification permissions failure.")
            }
        } catch {
            print("Error: \(error)")
        }
    }
    
    func subscribeToNotifications() async {
        let predicate = NSPredicate(value: true)
        let subscription = CKQuerySubscription(recordType: "Fruits", predicate: predicate, subscriptionID: "fruit_added_to_database", options: .firesOnRecordCreation)
        
        let notification = CKSubscription.NotificationInfo()
        notification.title = "There's a new fruit!"
        notification.alertBody = "Open the app to check your fruits."
        notification.soundName = "default"
        subscription.notificationInfo = notification
        
        do {
            try await CKContainer.default().publicCloudDatabase.save(subscription)
            print("Successfully subscribed to notifications!")
        } catch {
            print("Error: \(error)")
        }
    }
    
    func unsubscribeToNotifications() async {
//        CKContainer.default().publicCloudDatabase.fetchAllSubscriptions
        do {
            try await CKContainer.default().publicCloudDatabase.deleteSubscription(withID: "fruit_added_to_database")
            print("Successfuly unsubscribed!")
        } catch {
            print("Error: \(error)")
        }
    }
}

struct CloudKitPushNotificationBootcamp: View {
    
    @StateObject private var vm = CloudKitPushNotificationBootcampViewModel()
    
    var body: some View {
        VStack(spacing: 40.0) {
            Button("Request notification permissions") {
                Task {
                    await vm.requestNotificationPermissions()
                }
            }
            Button("Subscribe to notifications") {
                Task {
                    await vm.subscribeToNotifications()
                }
            }
            Button("Unsubscribe to notifications") {
                Task {
                    await vm.unsubscribeToNotifications()
                }
            }
        }
    }
}

struct CloudKitPushNotificationBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitPushNotificationBootcamp()
    }
}
