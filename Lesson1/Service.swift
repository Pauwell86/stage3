//
//  Service.swift
//  VK
//
//  Created by Pauwell on 27.05.2021.
//

import Foundation
import Alamofire


final class VKService {
  private var baseURL = "https://api.vk.com/method/"
  private var version = "5.131"
        
    func loadFriends(completion: @escaping ([Item]) -> Void) {

    let path = "friends.get"

    let parameters: Parameters = [
                    "access_token": DataStorage.shared.tokenVk,
                    "v": version,
                    "fields": "photo_200_orig"
                ]

    let url = baseURL + path

    AF.request(url, method: .get, parameters: parameters).responseData { response in

        guard let data = response.value else { return }
                    
        guard let users = try? JSONDecoder().decode(UserJSONElement.self, from: data).response.items else { return }
                
        DispatchQueue.main.async {
            completion(users)
        }
    }
  }
}



