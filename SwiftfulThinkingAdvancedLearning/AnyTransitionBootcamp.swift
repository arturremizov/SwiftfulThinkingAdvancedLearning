//
//  AnyTransitionBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 10.12.22.
//

import SwiftUI

struct RotateViewModifier: ViewModifier {
    
    let rotation: Double
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(Angle(degrees: rotation))
            .offset(
                x: rotation != 0 ? UIScreen.main.bounds.width : 0,
                y: rotation != 0 ? UIScreen.main.bounds.height: 0
            )
    }
}

extension AnyTransition {
    
    static var rotating: AnyTransition {
        modifier(active: RotateViewModifier(rotation: 180),
                 identity: RotateViewModifier(rotation: 0))
    }
    
    static func rotating(rotation: Double) -> AnyTransition {
        modifier(active: RotateViewModifier(rotation: rotation),
                 identity: RotateViewModifier(rotation: 0))
    }
    
    static var rotateOn: AnyTransition {
        asymmetric(
            insertion: .rotating,
            removal: .move(edge: .leading)
        )
    }
}

struct AnyTransitionBootcamp: View {
    
    @State private var showRectangle: Bool = false
    
    var body: some View {
        VStack {
            Spacer()
            
            if showRectangle {
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 250, height: 350)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
//                    .transition(.rotating(rotation: 1080))
                    .transition(.rotateOn)
            }
            
            
            Spacer()
            
            Button {
                withAnimation(.easeInOut) {
                    showRectangle.toggle()
                }
            } label: {
                Text("Click me!")
                    .withDefaultButtonFormatting()
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 40)
              
        }
    }
}

struct AnyTransitionBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AnyTransitionBootcamp()
    }
}
