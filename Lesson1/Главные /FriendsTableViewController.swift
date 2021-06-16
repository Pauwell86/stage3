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

    
    var myFriendsDict = [String: [User]]()
    var myFriendsSectionTitles = [String]()
    
    var friend = User(name: "")
    var friensInfo = [UserJSON]()
    var friendsService = VKService()
    var usersArray = [User]()
    var token: NotificationToken?
    var friends: Results<UserJSON>?
    

        
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.delegate = self
        self.tableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: friendTableViewCellReuse)
        mySearchBar.delegate = self

        friendsService.getFriends()

        let realm = try! Realm()
        friends = realm.objects(UserJSON.self)
        print("\(String(describing: friends)) xxx")
        
        token = friends!.observe { [weak self] changes in

            switch changes {
                       case .initial:
                        self?.tableView.reloadData()

                       case .update(_, let deletions, let insertions, let modifications):                        
                        self?.tableView.beginUpdates()
                         self?.tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                             with: .automatic)
                         self?.tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                             with: .automatic)
                         self?.tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                             with: .automatic)
                        self?.tableView.endUpdates()
                        
                       case .error(let error):
                        print(error)
                   }
            print("данные изменились")
        }
}
    
    deinit {
        token?.invalidate()
    }
        
    
override func numberOfSections(in tableView: UITableView) -> Int {
    return 1
}

override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

    return friends!.count
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
    
    
    let friend = friends![indexPath.row]
    cell.configureWithUser(user: friend)
    
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
    

