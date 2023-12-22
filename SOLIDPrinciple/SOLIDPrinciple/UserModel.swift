import Foundation

struct UserModel: Decodable {
    let id: Int
    let name, email, username: String
}
