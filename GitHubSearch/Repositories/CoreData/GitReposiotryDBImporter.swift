//
//  GitReposiotryDBImporter.swift
//  GitHubSearch
//
//  Created by Krzysztof Lema on 19/03/2021.
//

import Foundation
import Combine
import CoreData

class GitRepositoryImporetr {
    private static var syncQueue = DispatchQueue(label: "MovieDbImporter.queue")
    private static var _isRunning: Bool = false
    private var networkApi: NetworkApiType
    public static var isRunning: Bool {
        get { return syncQueue.sync { _isRunning }}
        set { syncQueue.sync{ _isRunning = newValue }}
    }
    
    init(networkApi: NetworkApiType) {
        self.networkApi = networkApi
    }
    
    func importGitRepository(in context: NSManagedObjectContext, for text: String) -> AnyPublisher<Void, Error> {
        guard !Self.isRunning else {
            return Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        Self.isRunning = true
        
        return networkApi.fetchData(for: text)
            .map(\.items)
            .handleEvents(receiveOutput: { repositories in
               
                    context.performAndWait {
                        repositories.forEach { repository in
                            
                    }
                }
            }, receiveCompletion: <#T##((Subscribers.Completion<Error>) -> Void)?##((Subscribers.Completion<Error>) -> Void)?##(Subscribers.Completion<Error>) -> Void#>, receiveCancel: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>, receiveRequest: <#T##((Subscribers.Demand) -> Void)?##((Subscribers.Demand) -> Void)?##(Subscribers.Demand) -> Void#>)
            .map {  _ in return ()}
            .eraseToAnyPublisher()


           
       
        
    }
}
