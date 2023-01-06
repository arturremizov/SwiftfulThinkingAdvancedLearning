//
//  CloudKitUserBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 2.01.23.
//

import SwiftUI

class CloudKitUserBootcampViewModel: ObservableObject {
    
    @Published var isSignedInToiCloud: Bool = false
    @Published var error: String = ""
    @Published var permissionStatus: Bool = false
    @Published var userName: String = ""
    
    init() {
        Task {
            await getiCloudStatus()
            await requestPermission()
            await getCurrentUserName()
        }
    }
    
    private func getiCloudStatus() async {
        do {
            let status = try await CloudKitUtility.getiCloudStatus()
            await MainActor.run {
                isSignedInToiCloud = status
            }
        } catch {
            self.error = error.localizedDescription
        }
    }
    
    private func requestPermission() async {
        let status = await CloudKitUtility.requestApplicationPermission()
        await MainActor.run {
            permissionStatus = status
        }
    }
    
    private func getCurrentUserName() async {
        do {
            let name = try await CloudKitUtility.discoverUserIdentity()
            await MainActor.run {
                userName = name
            }
        } catch {
            self.error = error.localizedDescription
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
