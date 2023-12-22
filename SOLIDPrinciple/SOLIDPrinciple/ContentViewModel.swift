import Foundation
import SwiftUI

class ContentViewModel: ObservableObject {

    @Published var comments: [CommentModel] = []
    @Published var users: [UserModel] = []
    
    let commentService: CommentsViewServiceProtocol
    let mockCommentService: CommentsServiceProtocol
    
    init(commentService: CommentsViewServiceProtocol = CommentsViewServices(),
         mocService: CommentsServiceProtocol = MockCommentViewService()) {
        self.commentService = commentService
        self.mockCommentService = mocService
    }
    
    func getComments() {
        //if isConnect() {
            debugPrint("Online")
            commentService.fetchComments { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self.comments = data
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        /*} else {
            debugPrint("Offline")
            mockCommentService.fetchComments { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let data):
                        self.comments = data
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        }*/
    }
    
    
    func getUsers() {
        commentService.fetchUsers { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self.users = data
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func isConnect() -> Bool {
        return false
    }
    
    
}
