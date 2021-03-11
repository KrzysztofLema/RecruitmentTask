//
//  GitRepositoryApiImpl.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 11/03/2021.
//

import Foundation
import Combine

class GitRepositoryApiImpl: GitRepositoryAPI {
    
    let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    
    func getRepositorySearchResult(
        for text: String,
        sortedBy sorting: Sorting? = .numberOfStars
    ) -> AnyPublisher<Resources.GitResponse, GitRepositoryAPIError> {
        Future { [weak self] promise in
            guard let self = self else { return }
            var components = URLComponents()
            components.scheme = "https"
            components.host = "api.github.com"
            components.path = "/search/repositories"
            components.queryItems = [
                URLQueryItem(name: "q", value: text),
                URLQueryItem(name: "sort", value: sorting?.rawValue)
            ]
            
            guard let url = components.url else {
                promise(.failure(GitRepositoryAPIError.wrongURL))
                return
            }
            
            self.urlSession.dataTask(with: url) { data, response, error in
                if error != nil {
                    promise(.failure(GitRepositoryAPIError.unknown))
                }
                
                guard let httpResponse = response as? HTTPURLResponse else {
                    promise(.failure(GitRepositoryAPIError.unknown))
                    return
                }
                
                guard (200..<300).contains(httpResponse.statusCode) else {
                    let error = GitRepositoryAPIError.badHTTPResponse(statusCode: httpResponse.statusCode)
                    promise(.failure(error))
                    return
                }
                
                guard let data = data else {
                    promise(.failure(GitRepositoryAPIError.unknown))
                    return
                }
                
                do {
                    let jsonDecoder = JSONDecoder()
                    let decodedData = try jsonDecoder.decode(Resources.GitResponse.self, from: data)
                    promise(.success(decodedData))
                } catch {
                    debugError(error)
                    promise(.failure(GitRepositoryAPIError.decoding))
                }
            }.resume()
            
        }.eraseToAnyPublisher()
    }
}
