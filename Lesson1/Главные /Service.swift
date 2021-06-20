//
//  Service.swift
//  VK
//
//  Created by Pauwell on 27.05.2021.
//

import Foundation
import Alamofire
import RealmSwift
import FirebaseFirestore


 class VKService {

  var friendsWithoutDeleted = [UserJSON]()

  private var baseURL = "https://api.vk.com/method"
  private var version = "5.131"
    
        //completion: @escaping ([UserJSON]) -> ()
    func getFriends() {

    let method = "/friends.get"

    let parameters: Parameters = [
                    "user_id": "8023208",
                    "access_token": DataStorage.shared.tokenVk,
                    "v": version,
                    "fields": "photo_200_orig"
                ]

    let url = baseURL + method

    AF.request(url, method: .get, parameters: parameters).responseData { [weak self] response in

        guard let data = response.data else { return }
    
//        print(data.prettyJSON as Any)
                    
        guard let friends = try? JSONDecoder().decode(Friends.self, from: data).response.items else { return }
        
        for friend in friends {
            if friend.firstName != "DELETED" {
                self!.friendsWithoutDeleted.append(friend)
            }
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.clearData()
            self?.saveFriendsData(self!.friendsWithoutDeleted)
        }
    }
        
  }
    
    func getFriendsFotos(completion: @escaping ([Item]) -> ())  {
        let method = "/photos.getAll"

        let parameters: Parameters = [
                        "owner_id": DataStorage.shared.userID,
                        "access_token": DataStorage.shared.tokenVk,
                        "v": version,
                    ]

        let url = baseURL + method

        AF.request(url, method: .get, parameters: parameters).responseData { response in

            guard let data = response.data else { return }
            
//            print(data.prettyJSON as Any)
            do {
                let photos = try JSONDecoder().decode(Photos.self, from: data).response.items
    //        print("\(photos)  hey")
                
                DispatchQueue.main.async {
                    completion(photos)
                }
            } catch {
                print(error)
            }
        }
    }
    
    func getGroups() {

    let method = "/groups.get"

    let parameters: Parameters = [
                    "user_id": "8023208",
                    "extended": "1",
                    "access_token": DataStorage.shared.tokenVk,
                    "v": version,
                    "fields": "photo_200"
                ]

    let url = baseURL + method

    AF.request(url, method: .get, parameters: parameters).responseData { [weak self] response in

        guard let data = response.data else { return }
                        
        guard let groups = try? JSONDecoder().decode(Groups.self, from: data).response.items else { return }
                
        DispatchQueue.main.async { [weak self] in
//            self?.clearGroupsData(groups)
            self?.saveGroupsData(groups)
        }
    }
        
  }
    
    func clearData() {
        do {
            let realm = try Realm()
            try realm.write {
            realm.deleteAll()
            }
            } catch {
                print(error)
            }
        }
    
    func clearFriendsData(_ friends: [UserJSON]) {
        do {
            let realm = try Realm()
            let oldValues = realm.objects(UserJSON.self)
                realm.beginWrite()
                realm.delete(oldValues)
                realm.add(friends)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func clearGroupsData(_ groups: [GroupsJSON]) {
        do {
            let realm = try Realm()
            let oldValues = realm.objects(GroupsJSON.self)
            realm.beginWrite()
                realm.delete(oldValues)
                realm.add(groups)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }
    
    func saveFriendsData(_ friends: [UserJSON]) {
            do {
                let realm = try Realm()
                print(realm.configuration.fileURL as Any)
                realm.beginWrite()
                realm.add(friends)
                try realm.commitWrite()
            } catch {
                print(error)
            }
    }
    
    func saveGroupsData(_ groups: [GroupsJSON]) {
            do {
                let realm = try Realm()
                print(realm.configuration.fileURL as Any)
                realm.beginWrite()
                realm.add(groups)
                try realm.commitWrite()
            } catch {
                print(error)
            }
    }
    
    func saveToFirestore(_ groups: [GroupsJSON], group: String) {
 
        let database = Firestore.firestore()
        
        let groupsToSend = groups
            .map { $0.toFirestore() }
            .reduce([:]) { $0.merging($1) { (current, _) in current } }
        database.collection("groups").document(group).setData(groupsToSend, merge: true) {
            error in
            if let error = error {
                print(error.localizedDescription)
            } else {
                print("data saved")
            }
        }
    }
    
}



