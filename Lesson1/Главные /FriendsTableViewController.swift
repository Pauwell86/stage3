//
//  FriendsTableViewController.swift
//  VK
//
//  Created by Pauwell on 10.05.2021.
//

import UIKit
import RealmSwift

class FriendsTableViewController: UITableViewController, UINavigationControllerDelegate {

    
    
    let fromFriendsToFriendSegue = "fromFriendsToFriendSegue"
    let friendTableViewCellReuse = "MyTableViewCell"
   
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var mySearchBar: UISearchBar!
    
    let interactiveTransition = InteractiveTransitionClass()
//    let searchController = UISearchController()
    
    var myFriendsDict = [String: [User]]()
    var myFriendsSectionTitles = [String]()
    
    var friend = User(name: "")
    var friensInfo = [UserJSON]()
    var friends: Results<UserJSON>?
    var friendsService = VKService()
    var usersArray = [User]()
    var token: NotificationToken?

        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.delegate = self
        self.tableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: friendTableViewCellReuse)
        mySearchBar.delegate = self
//        navigationItem.searchController = searchController
        
//        let realm = try! Realm()
//        let friends = realm.objects(UserJSON.self)
//        print("\(friends) xxx")
//        
//        token = friends.observe { [weak self] changes in
//
//            switch changes {
//                       case .initial:
//                        self?.tableView.reloadData()
//
//                       case .update(_, let deletions, let insertions, let modifications):
//
//                        self?.tableView.beginUpdates()
//
//                         self?.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
//                                             with: .automatic)
//                         self?.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
//                                             with: .automatic)
//                         self?.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
//                                             with: .automatic)
//                        self?.tableView.endUpdates()
//
//                       case .error(let error):
//                        print(error)
//                   }
//
//            print("данные изменились")
//
//        }
        
        loadDataFromRealm()
        friendsService.getFriends { [weak self] _ in
            DispatchQueue.main.async {
                self?.loadDataFromRealm()
            }
            
        }

}
    
//    deinit {
//        token?.invalidate()
//    }
        
    
override func numberOfSections(in tableView: UITableView) -> Int {
    return DataStorage.shared.myFriendsArray.count
}


//override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//    let view = CustomLabel()
//    view.text = myFriendsSectionTitles[section]
//    view.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
//
//
//    return view
//}
    
//override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
//    return myFriendsSectionTitles
//}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//    let myFriendKey = myFriendsSectionTitles[section]
//    guard let myFriendValues = myFriendsDict[myFriendKey] else { return 0 }
    
    return DataStorage.shared.myFriendsArray.count
}

override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let cell = tableView.cellForRow(at: indexPath) as? MyTableViewCell,
          let user = cell.saveUser
    else {return}
    
    cell.animeAvatar()
    
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
        self.performSegue(withIdentifier: self.fromFriendsToFriendSegue, sender: user)
    }
    
}

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == fromFriendsToFriendSegue {
            guard let user = sender as? User,
                  let destenation = segue.destination as? FotoCollectionViewController
            else { return }
            destenation.user = user
        }
    
}

override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: friendTableViewCellReuse, for: indexPath) as? MyTableViewCell else {return UITableViewCell()}
    
//
//    let myFriendKey = myFriendsSectionTitles[indexPath.section]
//    if let myFriendValues = myFriendsDict[myFriendKey] {
        
        cell.configureWithUser(user: DataStorage.shared.myFriendsArray[indexPath.row])
        
//    }
    
    return cell
}

override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 100
}
    
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if operation == .push {
            self.interactiveTransition.viewController = toVC
            return PushAnimation()
        }
        else if operation == .pop {
            if navigationController.viewControllers.first != toVC {
                self.interactiveTransition.viewController = toVC
            }
            return PopAnimation()
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        return interactiveTransition.isStarted ? interactiveTransition : nil

    }
    
    func createMyFriendsArray() {
//        print("\(friends!) xxx")
//        if let friendsUnwrap = friends {
        for item in friensInfo {
            if item.firstName != "DELETED" {
            friend.name = "\(item.lastName) \(item.firstName)"

            if let url = URL(string: item.photo200_Orig) {
                let data = try? Data(contentsOf: url)
                let image = UIImage(data: data!)
                friend.avatar = image
            }
                friend.userID = item.id
        }
            usersArray.append(friend)
            DataStorage.shared.myFriendsArray = usersArray
        }
      }
//    }
    
//    func createMyFriendsDict() {
//
////      print(DataStorage.shared.myFriendsArray)
//
//        for friend in DataStorage.shared.myFriendsArray {
//            let firstLetterIndex = friend.name.index(friend.name.startIndex, offsetBy: 1)
//            let friendKey = String(friend.name[..<firstLetterIndex])
//
//            if  var myFriendValue = myFriendsDict[friendKey] {
//                myFriendValue.append(friend)
//                myFriendsDict[friendKey] = myFriendValue
//            } else {
//                myFriendsDict[friendKey] = [friend]
//
//            }
//        }
//
//        myFriendsSectionTitles = [String](myFriendsDict.keys)
//        myFriendsSectionTitles = myFriendsSectionTitles.sorted(by: { $0 < $1 })
//
////        print(myFriendsDict)
//    }
    
    func loadDataFromRealm() {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL as Any)
            let friends = realm.objects(UserJSON.self)
            self.friensInfo = Array(friends)
        } catch {
            print(error.localizedDescription)
        }
        self.tableView.reloadData()
        self.createMyFriendsArray()
//        self.createMyFriendsDict()
    }
    

}

extension FriendsTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        DataStorage.shared.myFriendsArray = []
        
        if searchText == "" {
            DataStorage.shared.myFriendsArray = usersArray
        } else {
            for group in usersArray {
                if group.name.lowercased().contains(searchText.lowercased()) {
                    DataStorage.shared.myFriendsArray.append(group)
                }
            }
        }
        self.tableView.reloadData()
    }
}
    

