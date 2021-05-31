//
//  DataStorage.swift
//  VK
//
//  Created by Pauwell on 13.04.2021.
//

import UIKit

class DataStorage: NSObject {
    static let shared = DataStorage()
    private override init() {
        super.init()
    }

    // var userArray = [User]()
    var myFriendsArray = [User]()
    var allGroups = [Group]()
    var myFavoriteGroups = [Group]()
    var newsGroups = [News]()
    var tokenVk = String()
    var userId = Int()

    
}
