//
//  AllGroupController.swift
//  VK
//
//  Created by Pauwell on 15.04.2021.
//

import UIKit
import RealmSwift

class AllGroupController: UITableViewController {
    
    let friendTableViewCellReuse = "MyTableViewCell"
    let groupsService = VKService()
    var token: NotificationToken?
    var groups: Results<GroupsJSON>?
    var selectedGroup: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(UINib(nibName: "MyTableViewCell", bundle: nil), forCellReuseIdentifier: friendTableViewCellReuse)
        
        let realm = try! Realm()
        groups = realm.objects(GroupsJSON.self)
        token = groups!.observe { [weak self] changes in

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
        
        groupsService.getGroups()

}
    
    deinit {
        token?.invalidate()
    }
        

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: friendTableViewCellReuse, for: indexPath) as? MyTableViewCell else {return UITableViewCell()}

        let group = groups![indexPath.row]
    
        cell.configureWithGroup(group: group)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? MyTableViewCell,
              let group = cell.saveGroup
        else {return}
       
        if !group.name.isEmpty {
        selectedGroup = group.name
        }
        
        groupsService.saveToFirestore(DataStorage.shared.myFavoriteGroups, group: selectedGroup!)
        
        var isEnableItem = false
        
        for item in DataStorage.shared.myFavoriteGroups {
            if item.name == group.name {
                isEnableItem = true
            }
        }
        
        if !isEnableItem {
            DataStorage.shared.myFavoriteGroups.append(group)
        }
                
        self.navigationController?.popViewController(animated: true)
        
    }

}
