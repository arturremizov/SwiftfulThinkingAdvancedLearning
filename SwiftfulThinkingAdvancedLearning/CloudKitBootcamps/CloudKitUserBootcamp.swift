//
//  CloudKitUserBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 2.01.23.
//

import SwiftUI
import CloudKit

class CloudKitUserBootcampViewModel: ObservableObject {
    
    enum CouldKitError: String, LocalizedError {
        case iCloudAccountNotFound
        case iCloudAccountNotDetermine
        case iCloudAccountRestricted
        case iCloudAccountUnknown
    }
    
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    @Published var permissionStatus: Bool = false
    @Published var userName: String = ""
    
    init() {
        Task {
            await getiCloudStatus()
            await requestPermission()
        }
        fetchiCloudRecordID()
    }
    
    private func getiCloudStatus() async {
        do {
            let status = try await CKContainer.default().accountStatus()
            await MainActor.run {
                switch status {
                case .available:
                    isSignedInToiCloud = true
                case .noAccount:
                    error = CouldKitError.iCloudAccountNotFound.rawValue
                case .couldNotDetermine:
                    error = CouldKitError.iCloudAccountNotDetermine.rawValue
                case .restricted:
                    error = CouldKitError.iCloudAccountRestricted.rawValue
                default:
                    error = CouldKitError.iCloudAccountUnknown.rawValue
                }
            }
        } catch {
            print("Error: \(error)")
            self.error = CouldKitError.iCloudAccountUnknown.rawValue
        }
    }
    
    private func requestPermission() async {
        let status = try? await CKContainer.default().requestApplicationPermission([.userDiscoverability])
        if status == .granted {
            await MainActor.run {
                permissionStatus = true
            }
        }
    }
    
    private func fetchiCloudRecordID() {
        CKContainer.default().fetchUserRecordID { [weak self] id, error in
            if let id {
                self?.discoveriCloudUser(id: id)
            }
        }
    }
    
    private func discoveriCloudUser(id: CKRecord.ID) {
        CKContainer.default().discoverUserIdentity(withUserRecordID: id) { [weak self] identity, error in
            DispatchQueue.main.async {
                if let name = identity?.nameComponents?.givenName {
                    self?.userName = name
                }
            }
        }
    }
}

struct CloudKitUserBootcamp: View {
    
    @StateObject private var vm = CloudKitUserBootcampViewModel()
    
    var body: some View {
        VStack {
            Text("IS SIGNED IN: \(vm.isSignedInToiCloud.description)")
            Text(vm.error)
            Text("Permission: \(vm.permissionStatus.description)")
            Text("NAME: \(vm.userName)")
        }
    }
}

struct CloudKitUserBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        CloudKitUserBootcamp()
    }
}
