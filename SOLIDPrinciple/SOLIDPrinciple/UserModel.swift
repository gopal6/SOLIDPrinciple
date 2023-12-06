//
//  UserModel.swift
//  SOLIDPrinciple
//
//  Created by VaishaliChandana Undrakonda on 18/11/23.
//

import Foundation

struct UserModel: Decodable {
    let id: Int
    let name, email, username: String
}
