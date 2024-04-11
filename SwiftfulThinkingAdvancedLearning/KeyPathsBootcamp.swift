//
//  KeyPathsBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 11.04.24.
//

import SwiftUI

struct DataModel: Identifiable {
    let id: String = UUID().uuidString
    let title: String
    let count: Int
    let date: Date
}

//struct MovieTitle {
//    let primary: String
//    let secondary: String
//}

extension Array {
    mutating func sortBy<T:Comparable>(keyPath: KeyPath<Element, T>, ascending: Bool = true) {
        sort { item1, item2 in
            let value1 = item1[keyPath: keyPath]
            let value2 = item2[keyPath: keyPath]
            return ascending ? value1 < value2 : value1 > value2
        }
    }
}

struct KeyPathsBootcamp: View {
    
//    @Environment(\.dismiss) var dismiss
    @AppStorage("user_count") var userCount: Int = 0
    @State private var dataArray: [DataModel] = []
    
    var body: some View {
        List {
            ForEach(dataArray) { item in
                VStack(alignment: .leading) {
                    Text(item.id)
                    Text(item.title)
                    Text("\(item.count)")
                    Text(item.date.description)
                }
                .font(.headline)
            }
        }
        .onAppear {
            dataArray = [
                DataModel(title: "Three", count: 3, date: .distantFuture),
                DataModel(title: "One", count: 1, date: .now),
                DataModel(title: "Two", count: 2, date: .distantPast)
            ]
            dataArray.sortBy(keyPath: \.count, ascending: false)
            
//                let item = DataModel(title: "One", count: 1, date: .now)
//                let title = item.title
//                let title2 = item[keyPath: \.title]
//                screenTitle = title2
        }
    }
}

#Preview {
    KeyPathsBootcamp()
}
