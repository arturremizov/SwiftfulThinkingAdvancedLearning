//
//  CustomBindingBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 9.04.24.
//

import SwiftUI

extension Binding where Value == Bool {
    
    init<T>(value: Binding<T?>) {
        self.init(get: {
            return value.wrappedValue != nil
        }, set: { newValue in
            if !newValue {
                value.wrappedValue = nil
            }
        })
    }
}

struct CustomBindingBootcamp: View {
    @State var title: String = "Start"
    
    @State private var errorTitle: String? = nil
//    @State private var showError: Bool = false
    
    var body: some View {
        VStack {
            Text(title)
            
            ChildView(title: $title)
            ChildView2(title: title) { newTitle in
                title = newTitle
            }
            ChildView3(title: $title)
            
            ChildView3(title: Binding(get: {
                return title
            }, set: { newValue in
                title = newValue
            }))
            
            Button("CLICK ME") {
                errorTitle = "New Error!!!"
//                showError = true
            }
        }
        .alert(errorTitle ?? "Error", isPresented: Binding(value: $errorTitle)) {
            Button("OK") { }
        }
//        .alert(errorTitle ?? "Error", isPresented: Binding(get: {
//            return errorTitle != nil
//        }, set: { newValue in
//            if !newValue {
//                errorTitle = nil
//            }
//        })) {
//            Button("OK") { }
//        }
    }
}

struct ChildView: View {
    @Binding var title: String
    var body: some View {
        Text(title)
            .onAppear {
//                title = "New Title"
            }
    }
}

struct ChildView2: View {
    let title: String
    let setTitle: (String) -> Void
    var body: some View {
        Text(title)
            .onAppear {
//                setTitle("New title 2")
            }
    }
}

struct ChildView3: View {
    let title: Binding<String>
    var body: some View {
        Text(title.wrappedValue)
            .onAppear {
                title.wrappedValue = "New title 3"
            }
    }
}

#Preview {
    CustomBindingBootcamp()
}
