//
//  GitRepositoryApiImpl.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 11/03/2021.
//

import Foundation
import Combine

protocol NetworkApiType {
    func fetchData(for text: String) -> AnyPublisher<GitResponse, Error>
}

class NetworkApi: NetworkApiType {
    
    let urlSession: URLSession
    let decoder: JSONDecoder
    init(urlSession: URLSession) {
        self.urlSession = urlSession
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func fetchData(for text: String) -> AnyPublisher<GitResponse, Error> {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.github.com"
        components.path = "/search/repositories"
        components.queryItems = [
            URLQueryItem(name: "q", value: text),
        ]
        
        guard let url = components.url else {
            return Just("{}".data(using: .utf8)!)
                .decode(type: APIError.self, decoder: JSONDecoder())
                .tryMap {
                    throw $0
                }.eraseToAnyPublisher()
        }
        
        return urlSession.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: GitResponse.self, decoder: decoder)
            .eraseToAnyPublisher()
    }
}

struct APIError: Decodable, Error {
    // fields that model your error
}
