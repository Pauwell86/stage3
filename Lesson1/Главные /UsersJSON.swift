//
//  UsersElement.swift
//  VK
//
//  Created by Pauwell on 02.06.2021.
//

import Foundation
import RealmSwift

// MARK: - GET FRIENDS

class Friends: Decodable {
    let response: FriendsResponse
}

class FriendsResponse: Decodable {
    let count: Int
    let items: [UserJSON]
}

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

// MARK: - GET PHOTOS

class Photos: Codable {
    let response: Response

    init(response: Response) {
        self.response = response
    }
}

class Response: Codable {
    let count: Int
    let items: [Item]

    init(count: Int, items: [Item]) {
        self.count = count
        self.items = items
    }
}

class Item: Codable {
    let albumID, id, date: Int
    let text: String
    let sizes: [PhotoJSON]
    let hasTags: Bool
    let ownerID: Int

    enum CodingKeys: String, CodingKey {
        case albumID = "album_id"
        case id, date, text, sizes
        case hasTags = "has_tags"
        case ownerID = "owner_id"
    }

    init(albumID: Int, id: Int, date: Int, text: String, sizes: [PhotoJSON], hasTags: Bool, ownerID: Int) {
        self.albumID = albumID
        self.id = id
        self.date = date
        self.text = text
        self.sizes = sizes
        self.hasTags = hasTags
        self.ownerID = ownerID
    }
}

class PhotoJSON: Codable {
    let width: Int
    let height: Int
    let url: String
    let type: TypeEnum


    init(width: Int, height: Int, url: String, type: TypeEnum) {
        self.width = width
        self.height = height
        self.url = url
        self.type = type
    }
}

enum TypeEnum: String, Codable {
    case m = "m"
    case o = "o"
    case p = "p"
    case q = "q"
    case r = "r"
    case s = "s"
    case w = "w"
    case x = "x"
    case y = "y"
    case z = "z"
}

