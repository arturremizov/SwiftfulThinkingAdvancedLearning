//
//  CustomOperatorBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 24.04.24.
//

import SwiftUI

struct CustomOperatorBootcamp: View {
    
    @State private var value: Double = 0
    
    var body: some View {
        Text("\(value)")
            .onAppear {
//                value = (5 + 5) / 2
//                value = 5 +/ 5
//                value = 6 ++/ 3
                let someValue: Int = 5
                value = someValue => Double.self
            }
    }
}

infix operator +/
infix operator ++/

extension FloatingPoint {
    static func +/ (lhs: Self, rhs: Self) -> Self {
        (lhs + rhs) / 2
    }
    
    static func ++/ (lhs: Self, rhs: Self) -> Self {
        (lhs + rhs) / rhs
    }
}

infix operator =>

protocol InitFromBinaryFloatingPoint {
    init<T>(_ source: T) where T : BinaryInteger
}

extension Double: InitFromBinaryFloatingPoint {
    
}

extension BinaryInteger {
    static func => <T: InitFromBinaryFloatingPoint>(value: Self, newType: T.Type) -> T {
        return T(value)
    }
}

#Preview {
    CustomOperatorBootcamp()
}
