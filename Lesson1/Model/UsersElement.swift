//
//  UsersElement.swift
//  VK
//
//  Created by Pauwell on 02.06.2021.
//

import Foundation

struct UserJSONElement: Codable {
    let response: Response
}

// MARK: - Response
struct Response: Codable {
    let count: Int
    let items: [Item]
}

// MARK: - Item
struct Item: Codable {
    let canAccessClosed: Bool?
    let id: Int
    let photo200_Orig: String
    let lastName, trackCode: String
    let isClosed: Bool?
    let firstName: String
    let deactivated: String?
    let lists: [Int]?

    enum CodingKeys: String, CodingKey {
        case canAccessClosed = "can_access_closed"
        case id
        case photo200_Orig = "photo_200_orig"
        case lastName = "last_name"
        case trackCode = "track_code"
        case isClosed = "is_closed"
        case firstName = "first_name"
        case deactivated, lists
    }
}
