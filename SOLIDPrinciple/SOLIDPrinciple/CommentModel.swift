import Foundation

struct CommentModel: Decodable {
    let id: Int
    let postId: Int
    let name, email, body: String
}


