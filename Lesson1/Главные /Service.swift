//
//  Service.swift
//  VK
//
//  Created by Pauwell on 27.05.2021.
//

import Foundation
import Alamofire
import RealmSwift



 class VKService {
  private var baseURL = "https://api.vk.com/method"
  private var version = "5.131"
    
        //completion: @escaping ([UserJSON]) -> ()
    func getFriends(completion: @escaping ([UserJSON]) -> ()) {

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
//        print("\(friends) zzz")

        DispatchQueue.main.async {
            self?.clearFriendsData()
            self?.saveFriendsData(friends)
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
    
    func clearFriendsData() {
        do {
            let realm = try Realm()
            try realm.write {
            realm.deleteAll()
            }
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
}



