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

//    func getRepositorySearchResult(
//        for text: String,
//    ) -> AnyPublisher<GitResponse, GitRepositoryAPIError> {
//        Future { [weak self] promise in
//            guard let self = self else { return }
//
//
//            guard let url = components.url else {
//                promise(.failure(GitRepositoryAPIError.wrongURL))
//                return
//            }
//
//            self.urlSession.dataTask(with: url) { data, response, error in
//                if error != nil {
//                    promise(.failure(GitRepositoryAPIError.unknown))
//                }
//
//                guard let httpResponse = response as? HTTPURLResponse else {
//                    promise(.failure(GitRepositoryAPIError.unknown))
//                    return
//                }
//
//                guard (200..<300).contains(httpResponse.statusCode) else {
//                    let error = GitRepositoryAPIError.badHTTPResponse(statusCode: httpResponse.statusCode)
//                    promise(.failure(error))
//                    return
//                }
//
//                guard let data = data else {
//                    promise(.failure(GitRepositoryAPIError.unknown))
//                    return
//                }
//
//                do {
//                    let jsonDecoder = JSONDecoder()
//                    let decodedData = try jsonDecoder.decode(GitResponse.self, from: data)
//                    promise(.success(decodedData))
//                } catch {
//                    debugError(error)
//                    promise(.failure(GitRepositoryAPIError.decoding))
//                }
//            }.resume()
//        }.eraseToAnyPublisher()
//    }

