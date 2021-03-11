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
    
    func getRepositorySearchResult(for text: String) -> AnyPublisher<Resources.GitResponse, GitRepositoryAPIError> {
        Future { [weak self] promise in
            guard let self = self else { return }
            let baseURL = "https://api.github.com/search/repositories?q=language:Swift+language:RXSwift&sort=stars&order=desc"
            guard let url = URL(string: baseURL) else {
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
                    promise(.failure(GitRepositoryAPIError.badHTTPResponse(statusCode: httpResponse.statusCode)))
                    return
                }
                
                guard let data = data else {
                    promise(.failure(GitRepositoryAPIError.unknown))
                    return
                }
                
                do {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
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
