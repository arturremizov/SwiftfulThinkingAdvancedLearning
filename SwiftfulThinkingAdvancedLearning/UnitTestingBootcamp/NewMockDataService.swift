//
//  NewMockDataService.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 29.12.22.
//

import Foundation
import Combine

protocol NewDataServiceProtocol {
    func downloadItemsWithEscaping(completion: @escaping (_ items: [String]) -> Void)
    func downloadItemsWithCombine() -> AnyPublisher<[String], Error>
}

class NewMockDataService: NewDataServiceProtocol {
    
    let items: [String]
    
    init(items: [String]?) {
        self.items = items ?? ["one", "two", "three"]
    }
    
    func downloadItemsWithEscaping(completion: @escaping (_ items: [String]) -> Void) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            completion(self.items)
        }
    }
    
    func downloadItemsWithCombine() -> AnyPublisher<[String], Error> {
        Just(items)
            .tryMap { items in
                guard !items.isEmpty else {
                    throw URLError(.badServerResponse)
                }
                return items
            }
            .eraseToAnyPublisher()
    }
}
