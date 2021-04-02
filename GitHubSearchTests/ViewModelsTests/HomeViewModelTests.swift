//
//  HomeViewModelTests.swift
//  GitHubSearchTests
//
//  Created by Krzysztof Lema on 12/03/2021.
//

import Foundation
import XCTest
import Combine
@testable import GitHubSearch

class HomeViewModelTests: XCTestCase {
    
    var sut: HomeViewModel!
    var mockGitRepositoryApi: MockTestGitRepositoryApi!
    var subscriptions = Set<AnyCancellable>()
    
    override func setUp() {
        mockGitRepositoryApi = MockTestGitRepositoryApi()
        sut = HomeViewModel(gitRepositoryApi: mockGitRepositoryApi)
    }
    
    override func tearDown() {
        mockGitRepositoryApi = nil
        sut = nil
        subscriptions = []
    }
    
    func test_initialViewModelState() {
        XCTAssertEqual(sut.searchInput, "")
        XCTAssertEqual(sut.gitRepositoryResults.count, 0)
        XCTAssertEqual(sut.homeViewState, .defaultState)
    }
    
    func test_whenSearchInputIsUpdated_then() {
        let expectation = XCTestExpectation(description: "")
        let expectedValue: [String] = ["", "asd"]
        var receivedValue: [String] = []
        sut.$searchInput
            .sink { received in
                receivedValue.append(received)
                expectation.fulfill()
            }.store(in: &subscriptions)
        
        sut.searchInput = "asd"
        wait(for: [expectation], timeout: 2.0)
        XCTAssertEqual(expectedValue, receivedValue)
    }
    
    func test_whenFutureResultIsFailureAndSearchInputIsReceivingValue_thenHomeViewState() {
        let expectation = XCTestExpectation(description: "")
        let expectedValue: [HomeViewState] = [.defaultState,.isLoadingData]
        var receivedValue: [HomeViewState] = []
        mockGitRepositoryApi.futureResult = Future { promise in
            promise(.failure(.unknown))
        }
        
        sut.$searchInput
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .sink { _ in
                expectation.fulfill()
            }.store(in: &subscriptions)
        
        sut
            .$homeViewState
            .sink { homeViewState in
                receivedValue.append(homeViewState)
            }.store(in: &subscriptions)
        
        sut.searchInput = "asd"
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(expectedValue, receivedValue)
    }
    
    func test_whenMockGitRepositoryGetSuccessAndGotSearchInput_thenExpectationOfHomeViewStateShouldBe() {
        let expectation = XCTestExpectation(description: "")
        let expectedValue: [HomeViewState] = [.defaultState, .isLoadingData, .loadedData]
        var receivedValue: [HomeViewState] = []
        
        mockGitRepositoryApi.futureResult = Future { promise in
            promise(.success(GitResponse(items: [
                GitRepository(
                    id: 0, name: "Krzysztof", url: URL(string: "www.google.pl"),
                    owner: Owner(avatar: URL(string: ""))),
                GitRepository(
                    id: 0, name: "Krzysztof", url: URL(string: "www.google.pl"),
                    owner: Owner(avatar: URL(string: ""))),
                GitRepository(
                    id: 0, name: "Krzysztof", url: URL(string: "www.google.pl"),
                    owner: Owner(avatar: URL(string: "")))
            ])))
            
        }
        sut.$searchInput
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .sink { _ in
                expectation.fulfill()
            }.store(in: &subscriptions)
        
        sut.$homeViewState
            .sink { received in
                receivedValue.append(received)
            }.store(in: &subscriptions)
        
        sut.searchInput = "asd"
        
        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(expectedValue, receivedValue)
        XCTAssertEqual(sut.gitRepositoryResults.count, 3)
    }
}
