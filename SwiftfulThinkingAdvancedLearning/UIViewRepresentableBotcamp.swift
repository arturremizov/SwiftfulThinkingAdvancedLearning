//
//  UIViewRepresentableBotcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 20.12.22.
//

import SwiftUI

struct UIViewRepresentableBotcamp: View {
    
    @State private var text: String = ""
    
    var body: some View {
        VStack {
            Text(text)
            HStack {
                Text("SwiftUI:")
                TextField("Type here...", text: $text)
                    .frame(height: 55)
                    .background(Color.gray)
            }
            HStack {
                Text("UIKit:    ")
                UITextViewUIViewRepresentable(text: $text)
                    .updatePlaceholder("New Placeholder!!!")
                    .frame(height: 55)
                    .background(Color.gray)
            }
        }
    }
}

struct UIViewRepresentableBotcamp_Previews: PreviewProvider {
    static var previews: some View {
        UIViewRepresentableBotcamp()
    }
}

struct UITextViewUIViewRepresentable: UIViewRepresentable {
    
    @Binding var text: String
    var placeholder: String
    let placeholderColor: UIColor
    
    init(text: Binding<String>, placeholder: String = "Default placeholder...", placeholderColor: UIColor = .red) {
        self._text = text
        self.placeholder = placeholder
        self.placeholderColor = placeholderColor
    }
    
    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField()
        textField.attributedPlaceholder = .init(string: placeholder,
                                                attributes: [ .foregroundColor: placeholderColor])
        textField.delegate = context.coordinator
        return textField
    }
    
    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
    }
    
    func updatePlaceholder(_ text: String) -> UITextViewUIViewRepresentable {
        var viewRepresentable = self
        viewRepresentable.placeholder = text
        return viewRepresentable
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        
        @Binding var text: String
        
        init(text: Binding<String>) {
            self._text = text
        }
        
        func textFieldDidChangeSelection(_ textField: UITextField) {
            text = textField.text ?? ""
        }
    }
}

struct BasicUIViewRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> some UIView {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}
