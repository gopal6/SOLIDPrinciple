//
//  CommentsViewServices.swift
//  SOLIDPrinciple
//
//  Created by VaishaliChandana Undrakonda on 18/11/23.
//

import Foundation

let commentsURL = "https://jsonplaceholder.typicode.com/comments"
let usersURL = "https://jsonplaceholder.typicode.com/users"

enum APIError: Error {
    case badURL
    case decodeFailure
    case serverError
    case noData
}

protocol CommentsViewServiceProtocol: CommentsServiceProtocol, UsersServiceProtocol {
    
}

protocol CommentsServiceProtocol {
    func fetchComments(completion: @escaping (Result<[CommentModel], APIError>) -> Void)
}

protocol UsersServiceProtocol {
    func fetchUsers(completion: @escaping (Result<[UserModel], APIError>) -> Void)
}

class CommentsViewServices: CommentsViewServiceProtocol {

    let networkManager: NetworkManagerProtocol
    
    init(networkManager: NetworkManagerProtocol = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func fetchComments(completion: @escaping (Result<[CommentModel], APIError>) -> Void) {
        networkManager.fetch(urlString: commentsURL, type: [CommentModel].self, completion: completion)
    }
    
    func fetchUsers(completion: @escaping (Result<[UserModel], APIError>) -> Void) {
        networkManager.fetch(urlString: usersURL, type: [UserModel].self, completion: completion)
    }
}

class MockCommentViewService: CommentsServiceProtocol {

    //let networkManager: NetworkManagerProtocol
    let fileName: String
    var result: Result<[CommentModel], APIError>!
     
    init(fileName: String = "") {
        self.fileName = fileName
        //self.networkManager = networkManager
    }
    
    func fetchComments(completion: @escaping (Result<[CommentModel], APIError>) -> Void) {
        completion(result)
    }
    
    func readLocalFile() -> Data? {
        do {
            guard let url = Bundle.main.url(forResource: fileName, withExtension: "json") else {
                return nil
            }
            let data = try Data(contentsOf: url)
            return data
        } catch let error{
            print(error.localizedDescription)
            return nil
        }
    }
}
