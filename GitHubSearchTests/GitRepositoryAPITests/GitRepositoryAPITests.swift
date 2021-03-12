//
//  GitRepositoryAPITests.swift
//  GitHubSearchTests
//
//  Created by Krzysztof Lema on 12/03/2021.
//

import Foundation
import XCTest
import Combine
@testable import GitHubSearch

class GitRepositoryAPITests: XCTestCase {
    
    var sut: GitRepositoryApiImpl!
    var session: URLSession!
    var subscriptions = Set<AnyCancellable>()
    
    
    override func setUp() {
        let config = URLSessionConfiguration.ephemeral
        config.protocolClasses = [MockURLProtocol.self]
        session = URLSession(configuration: config)
        sut = GitRepositoryApiImpl(urlSession: session)
    }
    
    override func tearDown() {
        sut = nil
        session = nil
    }
    
    func test_whenTheStatusCodeIs200_AfterSendRequest_ShouldReceiveData() {
        let expectation = XCTestExpectation(description: "resume() triggered")
        MockURLProtocol.testData = try? JSONEncoder().encode(GitResponse(items: [
            GitRepository(
                id: 0, name: "Krzysztof", url: URL(string: "www.google.pl"),
                owner: Owner(avatar: URL(string: "")))
        ]))
        MockURLProtocol.statusCode = 200
        let expectedValue =  GitResponse(items: [
            GitRepository(
                id: 0, name: "Krzysztof", url: URL(string: "www.google.pl"),
                owner: Owner(avatar: URL(string: "")))
        ])
        var receivedValue: GitResponse?
        
        sut.getRepositorySearchResult(for: "asd")
            .sink { _ in } receiveValue: { received in
                receivedValue = received
                expectation.fulfill()
            }.store(in: &subscriptions)

        wait(for: [expectation], timeout: 1.0)
        XCTAssertEqual(expectedValue, receivedValue)
    }
}

class MockURLProtocol: URLProtocol {
    static var testData: Data?
    static var statusCode: Int?
    static func mockResponse(url: URL, statusCode: Int) -> HTTPURLResponse? {
        HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)
    }
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        self.client?.urlProtocol(self, didReceive: MockURLProtocol.mockResponse(url: request.url!, statusCode: MockURLProtocol.statusCode!)!, cacheStoragePolicy: .notAllowed)
        self.client?.urlProtocol(self, didLoad: MockURLProtocol.testData ?? Data())
        
        self.client?.urlProtocolDidFinishLoading(self)
    }
    
    override func stopLoading() {}
    
}



