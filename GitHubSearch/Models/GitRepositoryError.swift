//
//  GitRepositoryError.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 12/03/2021.
//

import Foundation
enum GitRepositoryAPIError: Error {
    case unknown
    case wrongURL
    case decoding
    case notHTTPResponse
    case badHTTPResponse(statusCode: Int)
}

extension GitRepositoryAPIError: LocalizedError {
     var errorDescription: String? {
        switch self {
        case .unknown:
            return NSLocalizedString("UnknownError", comment: "")
        case .wrongURL:
            return NSLocalizedString("WrongURLError", comment: "")
        case .decoding:
            return NSLocalizedString("DecodingError", comment: "")
        case .notHTTPResponse:
            return NSLocalizedString("HTTPResponseError", comment: "")
        case .badHTTPResponse:
            return NSLocalizedString("BadHTTP", comment: "")
        }
    }
}
