//
//  SubscriptsBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 23.04.24.
//

import SwiftUI

extension Array {
//    func getItem(at index: Int) -> Element? {
//        for (i, element) in enumerated() {
//            if index == i {
//                return element
//            }
//        }
//        return nil
//    }
//    
//    subscript(index: Int) -> Element? {
//        for (i, element) in enumerated() {
//            if index == i {
//                return element
//            }
//        }
//        return nil
//    }
}

extension Array where Element == String {
    subscript(value: String) -> Element? {
        first(where: { $0 == value })
    }
}

struct Address {
    let street: String
    let city: City
}

struct City {
    let name: String
    let state: String
}

struct Customer {
    let name: String
    let address: Address
    
    subscript(value: String) -> String {
        switch value {
        case "name": return name
        case "address": return "\(address.street), \(address.city.name)"
        case "city": return address.city.name
        default: fatalError()
        }
    }
    
    subscript(index: Int) -> String {
        switch index {
        case 0: return name
        case 1: return "\(address.street), \(address.city.name)"
        default: fatalError()
        }
    }
}

struct SubscriptsBootcamp: View {
    @State private var array = ["one", "two", "three"]
    @State private var selectedItem: String? = nil
    var body: some View {
        VStack {
            ForEach(array, id:\.self) { item in
                Text(item)
            }
            Text("SELECTED: \(selectedItem ?? "none")")
        }
        .onAppear {
            let value = "three"
            selectedItem = array[value]
            
            let customer = Customer(
                name: "Nick",
                address: Address(
                    street: "Main Street",
                    city: City(name: "New York", state: "New York")
                )
            )
            selectedItem = customer[1]
        }
    }
}

#Preview {
    SubscriptsBootcamp()
}
