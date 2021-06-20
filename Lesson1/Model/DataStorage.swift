//
//  DataStorage.swift
//  VK
//
//  Created by Pauwell on 13.04.2021.
//

import UIKit

final class DataStorage: NSObject {
    static let shared = DataStorage()
    private override init() {
        super.init()
    }

    // var userArray = [User]()
    var myFriendsArray = [User]()
    var friedPhotos = [UIImage]()
    var allGroups = [Group]()
    var myFavoriteGroups = [GroupsJSON]()
    var newsGroups = [News]()
    var tokenVk = String()
    var userID = Int()
}
