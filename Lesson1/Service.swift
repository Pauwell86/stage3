//
//  Service.swift
//  VK
//
//  Created by Pauwell on 27.05.2021.
//

import Foundation
import Alamofire

class WeatherService {
    // базовый URL сервиса
    let baseUrl = "http://api.openweathermap.org"
    // ключ для доступа к сервису
    let apiKey = "92cabe9523da26194b02974bfcd50b7e"
    
    // метод для загрузки данных, в качестве аргументов получает город
    func loadWeatherData(city: String){
        
    // путь для получения погоды за 5 дней
        let path = "/data/2.5/forecast"
    // параметры, город, единицы измерения градусы, ключ для доступа к сервису
        let parameters: Parameters = [
            "q": city,
            "units": "metric",
            "appid": apiKey
        ]
        
    // составляем URL из базового адреса сервиса и конкретного пути к ресурсу
        let url = baseUrl+path
        
    // делаем запрос
        AF.request(url, method: .get, parameters: parameters).responseJSON { repsonse in
            print(repsonse.value as Any)
        }
        
    }
}

