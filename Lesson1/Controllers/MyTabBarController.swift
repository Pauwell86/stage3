//
//  ViewController.swift
//  VK
//
//  Created by Pauwell on 13.04.2021.
//

import UIKit

class MyTabBarController: UITabBarController {
    
    
    func fillUsersArray() {
        // Создаю друзей
//        let user1 = setNewUser(userNumber: 1, userName: "Вова", userAge: 68)
//        let user2 = setNewUser(userNumber: 2, userName: "Джо", userAge: 78)
//        let user3 = setNewUser(userNumber: 3, userName: "Анжела", userAge: 66)
//        let user4 = setNewUser(userNumber: 4, userName: "Ким", userAge: 37)
//        let user5 = setNewUser(userNumber: 5, userName: "Эмик", userAge: 43)
//        
//        let usersArray = [user1, user2, user3, user4, user5]
        
        // Создаю группы
        let group1 = Group(name: "Пиво всему голова!",
                           discription: "Группа любителей пива. История. Сорта. Отзывы.",
                           groupImage: UIImage(named: "Пиво"))
        let group2 = Group(name: "F1",
                           discription: "Все о Формуле 1. Турнирная таблица. Расписание гонок.",
                           groupImage: UIImage(named: "Формула1"))
        let group3 = Group(name: "Поохотимся?",
                           discription: "Все о охоте, оружие и экипировке",
                           groupImage: UIImage(named: "Охота"))
        let group4 = Group(name: "Футбол",
                           discription: "Все о футболе. Расписание матчей",
                           groupImage: UIImage(named: "Футбол"))
        
        let groupsArray = [group1, group2, group3, group4]
        
        // Создаю новости
        let news1 = News(newsTtitle: "Ты не поверишь! Магазин колясок закрывается",
                         newsImage: UIImage(named: "магазин"))
        let news2 = News(newsTtitle: "Ты не поверишь! Компания Gillette тестирует свою продукцию на животных. Правозащитники в шоке!",
                         newsImage: UIImage(named: "gillette"))
        let news3 = News(newsTtitle: "Ты не поверишь! Умер принц Филипп. Королева II замечена в Tinder",
                         newsImage: UIImage(named: "королева"))
        
        let newsArray = [news1, news2, news3]
        
//        DataStorage.shared.myFriendsArray = usersArray
//        DataStorage.shared.allGroups = groupsArray
        DataStorage.shared.newsGroups = newsArray
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fillUsersArray()
    }
}
