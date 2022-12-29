//
//  UnitTestingBootcampViewModel.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by Artur Remizov on 28.12.22.
//

import SwiftUI

class UnitTestingBootcampViewModel: ObservableObject {
    
    enum DataError: LocalizedError {
        case noData
        case itemNotFound
    }
    
    @Published var isPremium: Bool
    @Published var dataArray: [String] = []
    @Published var selectedItem: String? = nil
    
    let dataService: NewDataServiceProtocol
    
    init(isPremium: Bool, dataService: NewDataServiceProtocol = NewMockDataService(items: nil)) {
        self.isPremium = isPremium
        self.dataService = dataService
    }
    
    func addItem(item: String) {
        guard !item.isEmpty else { return }
        self.dataArray.append(item)
    }
    
    func selectItem(item: String) {
        if let foundItem = dataArray.first(where: { $0 == item }) {
            selectedItem = foundItem
        } else {
            selectedItem = nil
        }
    }
    
    func saveItem(item: String) throws {
        guard !item.isEmpty else {
            throw DataError.noData
        }
        if let foundItem = dataArray.first(where: { $0 == item }) {
            print("Save item here!!!", foundItem)
        } else {
            throw DataError.itemNotFound
        }
    }
    
    func downloadItemsWithEscaping() {
        dataService.downloadItemsWithEscaping { [weak self] items in
            self?.dataArray = items
        }
    }
    
    func downloadItemsWithCombine() {
        dataService.downloadItemsWithCombine()
            .replaceError(with: [])
            .assign(to: &$dataArray)
    }
}
