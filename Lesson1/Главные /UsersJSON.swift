//
//  UsersElement.swift
//  VK
//
//  Created by Pauwell on 02.06.2021.
//

import Foundation
import RealmSwift

class Friends: Decodable {
    let response: FriendsResponse
}

// MARK: - Response
class FriendsResponse: Decodable {
    let count: Int
    let items: [UserJSON]
}

// MARK: - Item
class UserJSON: Object, Decodable {
    @objc dynamic var canaccessClosed = false
    @objc dynamic var id = 0
    @objc dynamic var photo200_Orig = ""
    @objc dynamic var lastName = ""
    @objc dynamic var trackCode = ""
    @objc dynamic var firstName = ""

    enum CodingKeys: String, CodingKey {
        case id
        case photo200_Orig = "photo_200_orig"
        case lastName = "last_name"
        case trackCode = "track_code"
        case firstName = "first_name"
    }
}
