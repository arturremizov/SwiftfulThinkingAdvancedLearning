//
//  UnitTestingBootcampViewModel_Tests.swift
//  SwiftfulThinkingAdvancedLearning_Tests
//
//  Created by Artur Remizov on 28.12.22.
//

import XCTest
@testable import SwiftfulThinkingAdvancedLearning
import Combine

final class UnitTestingBootcampViewModel_Tests: XCTestCase {

    var viewModel: UnitTestingBootcampViewModel?
    var subscriptions: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        viewModel = UnitTestingBootcampViewModel(isPremium: Bool.random())
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func test_UnitTestingBootcampViewModel_isPremium_shouldBeTrue() {
        // given
        let userIsPremium = true
        // when
        let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
        // then
        XCTAssertTrue(vm.isPremium)
    }
    
    func test_UnitTestingBootcampViewModel_isPremium_shouldBeFalse() {
        // given
        let userIsPremium = false
        // when
        let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
        // then
        XCTAssertFalse(vm.isPremium)
    }
    
    func test_UnitTestingBootcampViewModel_isPremium_shouldBeInjectedValue() {
        // given
        let userIsPremium = Bool.random()
        // when
        let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
        // then
        XCTAssertEqual(vm.isPremium, userIsPremium)
    }
    
    func test_UnitTestingBootcampViewModel_isPremium_shouldBeInjectedValue_stress() {
        for _ in 0..<100 {
            // given
            let userIsPremium = Bool.random()
            // when
            let vm = UnitTestingBootcampViewModel(isPremium: userIsPremium)
            // then
            XCTAssertEqual(vm.isPremium, userIsPremium)
        }
    }
    
    func test_UnitTestingBootcampViewModel_dataArray_shouldBeEmpty() {
        // when
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        // then
        XCTAssertTrue(vm.dataArray.isEmpty)
    }
    
    func test_UnitTestingBootcampViewModel_dataArray_shouldAddItems() {
        // given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        // when
        let loopCount = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
      
        // then
        XCTAssertFalse(vm.dataArray.isEmpty)
        XCTAssertEqual(vm.dataArray.count, loopCount)
    }
    
    func test_UnitTestingBootcampViewModel_dataArray_shouldNotAddBlackString() {
        // given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        // when
        vm.addItem(item: "")
        // then
        XCTAssertTrue(vm.dataArray.isEmpty)
    }
    
    func test_UnitTestingBootcampViewModel_dataArray_shouldNotAddBlackString2() {
        // given
        guard let vm = viewModel else {
            XCTFail()
            return
        }
        // when
        vm.addItem(item: "")
        // then
        XCTAssertTrue(vm.dataArray.isEmpty)
    }
    
    func test_UnitTestingBootcampViewModel_selectedItem_shouldStartAsNil() {
        // when
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        // then
        XCTAssertNil(vm.selectedItem)
    }
    
    func test_UnitTestingBootcampViewModel_selectedItem_shouldBeNilWhenSelectingInvalidItem() {
        // given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        // when
        
        // select valid item
        let newItem = UUID().uuidString
        vm.addItem(item: newItem)
        vm.selectItem(item: newItem)
        
        // select invalid item
        vm.selectItem(item: UUID().uuidString)
        
        // then
        XCTAssertNil(vm.selectedItem)
    }
    
    func test_UnitTestingBootcampViewModel_selectedItem_shouldBeSelected() {
        // given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        // when
        let newItem = UUID().uuidString
        vm.addItem(item: newItem)
        vm.selectItem(item: newItem)
        // then
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem, newItem)
    }
    
    func test_UnitTestingBootcampViewModel_selectedItem_shouldBeSelected_stress() {
        // given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        // when
        let loopCount = Int.random(in: 1..<100)
        var itemsArray: [String] = []
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            vm.addItem(item: newItem)
            itemsArray.append(newItem)
        }
        
        let randomItem = itemsArray.randomElement() ?? ""
        XCTAssertFalse(randomItem.isEmpty)
        vm.selectItem(item: randomItem)

        // then
        XCTAssertNotNil(vm.selectedItem)
        XCTAssertEqual(vm.selectedItem, randomItem)
    }
    
    func test_UnitTestingBootcampViewModel_saveItem_shouldThrowError_itemNotFound() {
        // given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        // when
        let loopCount = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        
        // then
        XCTAssertThrowsError(try vm.saveItem(item: UUID().uuidString), "Should throw Item Not Found error") { error in
            let error = error as? UnitTestingBootcampViewModel.DataError
            XCTAssertEqual(error, UnitTestingBootcampViewModel.DataError.itemNotFound)
        }
    }
    
    func test_UnitTestingBootcampViewModel_saveItem_shouldThrowError_noData() {
        // given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        // when
        let loopCount = Int.random(in: 1..<100)
        for _ in 0..<loopCount {
            vm.addItem(item: UUID().uuidString)
        }
        
        // then
        do {
            try vm.saveItem(item: "")
        } catch {
            let error = error as? UnitTestingBootcampViewModel.DataError
            XCTAssertEqual(error, UnitTestingBootcampViewModel.DataError.noData)
        }
    }
    
    func test_UnitTestingBootcampViewModel_saveItem_shouldSaveItem() {
        // given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        // when
        let loopCount = Int.random(in: 1..<100)
        var itemsArray: [String] = []
        for _ in 0..<loopCount {
            let newItem = UUID().uuidString
            vm.addItem(item: newItem)
            itemsArray.append(newItem)
        }
        
        let randomItem = itemsArray.randomElement() ?? ""
        XCTAssertFalse(randomItem.isEmpty)
        
        // then
        XCTAssertNoThrow(try vm.saveItem(item: randomItem))
        
        do {
            try vm.saveItem(item: randomItem)
        } catch {
            XCTFail()
        }
    }
    
    func test_UnitTestingBootcampViewModel_downloadItemsWithEscaping_shouldReturnItems() {
        // given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        // when
        let expectation = XCTestExpectation(description: "Should return items after 3 seconds")
        
        vm.$dataArray
            .dropFirst()
            .sink { items in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        vm.downloadItemsWithEscaping()
        
        // then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingBootcampViewModel_downloadItemsWithCombine_shouldReturnItems() {
        // given
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random())
        
        // when
        let expectation = XCTestExpectation(description: "Should return items after a second")
        
        vm.$dataArray
            .dropFirst()
            .sink { items in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        vm.downloadItemsWithCombine()
        
        // then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
    }
    
    func test_UnitTestingBootcampViewModel_downloadItemsWithCombine_shouldReturnItems2() {
        // given
        let items = [UUID().uuidString, UUID().uuidString, UUID().uuidString, UUID().uuidString, UUID().uuidString]
        let dataService: NewDataServiceProtocol = NewMockDataService(items: items)
        let vm = UnitTestingBootcampViewModel(isPremium: Bool.random(), dataService: dataService)
        
        // when
        let expectation = XCTestExpectation(description: "Should return items after a second")
        
        vm.$dataArray
            .dropFirst()
            .sink { items in
                expectation.fulfill()
            }
            .store(in: &subscriptions)
        
        vm.downloadItemsWithCombine()
        
        // then
        wait(for: [expectation], timeout: 5)
        XCTAssertGreaterThan(vm.dataArray.count, 0)
        XCTAssertEqual(vm.dataArray.count, items.count)
    }
}
