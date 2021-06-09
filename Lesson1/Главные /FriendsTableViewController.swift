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
    
    let interactiveTransition = InteractiveTransitionClass()

    
    var myFriendsDict = [String: [User]]()
    var myFriendsSectionTitles = [String]()
    
      var friend = User(name: "")
      var friensInfo = [UserJSON]()
      var friendsService = VKService()
      var usersArray = [User]()

        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.delegate = self
        self.tableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: friendTableViewCellReuse)
        
        loadDataFromRealm()
    
        friendsService.getFriends { [weak self] _ in
            DispatchQueue.main.async {
                self?.loadDataFromRealm()
            }
        }
        self.tableView.reloadData()
}
        
    override func numberOfSections(in tableView: UITableView) -> Int {
        return myFriendsSectionTitles.count
    }
    

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = CustomLabel()
        view.text = myFriendsSectionTitles[section]
        view.backgroundColor = UIColor.blue.withAlphaComponent(0.2)
        

        return view
    }
        
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return myFriendsSectionTitles
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let myFriendKey = myFriendsSectionTitles[section]
        guard let myFriendValues = myFriendsDict[myFriendKey] else { return 0 }
        
        return myFriendValues.count
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
        

        let myFriendKey = myFriendsSectionTitles[indexPath.section]
        if let myFriendValues = myFriendsDict[myFriendKey] {
            
            cell.configureWithUser(user: myFriendValues[indexPath.row])
            
        }
        
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
        for item in friensInfo {
            if item.firstName != "DELETED" {
            friend.name = "\(item.lastName) \(item.firstName)"

            if let url = URL(string: item.photo200_Orig) {
                let data = try? Data(contentsOf: url)
                let image = UIImage(data: data!)
                friend.avatar = image
            }
        }

            usersArray.append(friend)
            DataStorage.shared.myFriendsArray = usersArray
        }
        
    }
    
    func createMyFriendsDict() {
        
//      print(DataStorage.shared.myFriendsArray)

        for friend in DataStorage.shared.myFriendsArray {
            let firstLetterIndex = friend.name.index(friend.name.startIndex, offsetBy: 1)
            let friendKey = String(friend.name[..<firstLetterIndex])
            
            if  var myFriendValue = myFriendsDict[friendKey] {
                myFriendValue.append(friend)
                myFriendsDict[friendKey] = myFriendValue
            } else {
                myFriendsDict[friendKey] = [friend]
                
            }
        }
        
        myFriendsSectionTitles = [String](myFriendsDict.keys)
        myFriendsSectionTitles = myFriendsSectionTitles.sorted(by: { $0 < $1 })
                
//        print(myFriendsDict)
    }
    
    func loadDataFromRealm() {
        do {
            let realm = try Realm()
            print(realm.configuration.fileURL as Any)
            let friends = realm.objects(UserJSON.self)
            self.friensInfo = Array(friends)
        } catch {
            print(error.localizedDescription)
        }
        self.createMyFriendsArray()
        self.createMyFriendsDict()
    }
    
    
}
