//
//  CommentModel.swift
//  SOLIDPrinciple
//
//  Created by VaishaliChandana Undrakonda on 18/11/23.
//

import Foundation

struct CommentModel: Decodable {
    let id: Int
    let postId: Int
    let name, email, body: String
}


