//
//  ErrorAlertBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 10.04.24.
//

import SwiftUI

protocol AlertProtocol {
    var title: String { get }
    var subtitle: String? { get }
    var actions: AnyView { get }
}

extension View {
    func showCustomAlert<T: AlertProtocol>(errorAlert: Binding<T?>) -> some View {
        self.alert(errorAlert.wrappedValue?.title ?? "Error", isPresented: Binding(value: errorAlert), actions: {
            errorAlert.wrappedValue?.actions
        }, message: {
            if let subtitle = errorAlert.wrappedValue?.subtitle {
                Text(subtitle)
            }
        })
    }
}

struct ErrorAlertBootcamp: View {
    
//    enum Error: LocalizedError {
//        case noInternetConnection
//        case dataNotFound
//        case urlError(Swift.Error)
//        
//        var errorDescription: String? {
//            switch self {
//            case .noInternetConnection:
//                return "Please check your internet connection and try again."
//            case .dataNotFound:
//                return "There was an error loading data. Please try again!"
//            case .urlError(let error):
//                return "Error: \(error)"
//            }
//        }
//    }
    
    enum ErrorAlert: AlertProtocol {
        typealias ActionHandler = () -> Void
        case noInternetConnection(onOkPressed: ActionHandler, onRetryPressed: ActionHandler)
        case dataNotFound
        case urlError(Swift.Error)
        
        var title: String {
            switch self {
            case .noInternetConnection:
                return "No Internet Connection"
            case .dataNotFound:
                return "No Data"
            case .urlError:
                return "Error"
            }
        }
        
        var subtitle: String? {
            switch self {
            case .noInternetConnection:
                return "Please check your internet connection and try again."
            case .dataNotFound:
                return nil
            case .urlError(let error):
                return "Error: \(error)"
            }
        }
        
        var actions: AnyView {
            AnyView(buttons)
        }
        
        @ViewBuilder
        private var buttons: some View {
            switch self {
            case .noInternetConnection(let onOkPressed, let onRetryPressed):
                Button("OK") { onOkPressed() }
                Button("Retry") { onRetryPressed() }
            case .dataNotFound:
                Button("Retry") { }
            default:
                Button("Delete", role: .destructive) { }
            }
        }
    }
    
    @State private var errorAlert: ErrorAlert? = nil
    
    var body: some View {
        Button("CLICK ME", action: saveData)
            .showCustomAlert(errorAlert: $errorAlert)
    }
    
    private func saveData() {
        let isSuccessful = false
        if isSuccessful {
            // do something
        } else {
            errorAlert = .noInternetConnection(onOkPressed: {
                
            }, onRetryPressed: {
                
            })
        }
    }
}

#Preview {
    ErrorAlertBootcamp()
}
