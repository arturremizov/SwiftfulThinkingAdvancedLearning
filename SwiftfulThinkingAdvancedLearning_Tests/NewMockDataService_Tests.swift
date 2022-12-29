//
//  NewMockDataService_Tests.swift
//  SwiftfulThinkingAdvancedLearning_Tests
//
//  Created by Artur Remizov on 29.12.22.
//

import XCTest
@testable import SwiftfulThinkingAdvancedLearning
import Combine

final class NewMockDataService_Tests: XCTestCase {

    var subscriptions: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
      
    }

    override func tearDownWithError() throws {
        subscriptions.removeAll()
    }
    
    func test_NewMockDataService_init_doesSetValuesCorrectly() {
        // given
        let items: [String]? = nil
        let items2: [String]? = []
        let items3: [String]? = [UUID().uuidString, UUID().uuidString]
        
        // when
        let dataService = NewMockDataService(items: items)
        let dataService2 = NewMockDataService(items: items2)
        let dataService3 = NewMockDataService(items: items3)
        
        // then
        XCTAssertFalse(dataService.items.isEmpty)
        XCTAssertTrue(dataService2.items.isEmpty)
        XCTAssertEqual(dataService3.items.count, items3?.count)
    }
    
    func test_NewMockDataService_downloadItemsWithEscaping_doesReturnValues() {
        // given
        let dataService = NewMockDataService(items: nil)
        
        // when
        var items: [String] = []
        let expectation = XCTestExpectation()
        dataService.downloadItemsWithEscaping { returnedItems in
            items = returnedItems
            expectation.fulfill()
        }
        
        // then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }
    
    func test_NewMockDataService_downloadItemsWithCombine_doesReturnValues() {
        // given
        let dataService = NewMockDataService(items: nil)
        
        // when
        var items: [String] = []
        let expectation = XCTestExpectation()
        
        dataService.downloadItemsWithCombine()
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail()
                }
            } receiveValue: { returnedItems in
                items = returnedItems
            }
            .store(in: &subscriptions)
        
        // then
        wait(for: [expectation], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }
    
    func test_NewMockDataService_downloadItemsWithCombine_doesFail() {
        // given
        let dataService = NewMockDataService(items: [])
        
        // when
        var items: [String] = []
        let expectation = XCTestExpectation(description: "Does throw an error")
        let expectation2 = XCTestExpectation(description: "Does throw an URLError.badServerResponse")
        
        dataService.downloadItemsWithCombine()
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail()
                case .failure(let error):
                    expectation.fulfill()
                    
//                    let urlError = error as? URLError
//                    XCTAssertEqual(urlError, URLError(.badServerResponse))
                    if error as? URLError  == URLError(.badServerResponse) {
                        expectation2.fulfill()
                    }
                }
            } receiveValue: { returnedItems in
                items = returnedItems
            }
            .store(in: &subscriptions)
        
        // then
        wait(for: [expectation, expectation2], timeout: 5)
        XCTAssertEqual(items.count, dataService.items.count)
    }
}
