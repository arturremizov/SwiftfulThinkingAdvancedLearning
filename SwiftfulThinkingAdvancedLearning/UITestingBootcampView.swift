//
//  UITestingBootcampView.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 30.12.22.
//

import SwiftUI

class UITestingBootcampViewModel: ObservableObject {
    
    let placeholderText: String = "Add name here..."
    @Published var textFieldText: String = ""
    @Published var isCurrentUserSignedIn: Bool
    
    init(isCurrentUserSignedIn: Bool) {
        self.isCurrentUserSignedIn = isCurrentUserSignedIn
    }
    
    func signUpButtonPressed() {
        guard !textFieldText.isEmpty else { return }
        isCurrentUserSignedIn = true
    }
}

struct UITestingBootcampView: View {
    
    @StateObject private var vm: UITestingBootcampViewModel
    
    init(isCurrentUserSignedIn: Bool) {
        _vm = StateObject(wrappedValue: UITestingBootcampViewModel(isCurrentUserSignedIn: isCurrentUserSignedIn))
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [.blue, .black]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ZStack {
                if vm.isCurrentUserSignedIn {
                    SignedInHomeView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .trailing))
                } else {
                    signUpLayer
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .transition(.move(edge: .leading))
                }
            }
        }
    }
}

struct UITestingBootcampView_Previews: PreviewProvider {
    static var previews: some View {
        UITestingBootcampView(isCurrentUserSignedIn: true)
    }
}

extension UITestingBootcampView {
    
    private var signUpLayer: some View {
        VStack {
            TextField(vm.placeholderText, text: $vm.textFieldText)
                .font(.headline)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .accessibilityIdentifier("SignUpTextField")
            
            Button {
                withAnimation(.spring()) {
                    vm.signUpButtonPressed()
                }
            } label: {
                Text("Sign Up")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .accessibilityIdentifier("SignUpButton")
            }
        }
        .padding()
    }
}


struct SignedInHomeView: View {
    
    @State private var showAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20.0) {
                Button {
                    showAlert.toggle()
                } label: {
                    Text("Show weclome alert!")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .accessibilityIdentifier("ShowAlertButton")
                .alert("Welcome to the app!", isPresented: $showAlert) { }
                
                NavigationLink {
                    Text("Destination")
                } label: {
                    Text("Navigate")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .accessibilityIdentifier("NavigationLinkToDestination")
            }
            .padding()
            .navigationTitle("Welcome")
        }
    }
}
