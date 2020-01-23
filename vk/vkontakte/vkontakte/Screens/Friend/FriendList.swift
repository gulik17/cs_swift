//
//  FriendList.swift
//  vkontakte
//
//  Created by Администратор on 03.12.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class FriendList: UITableViewController {
    @IBOutlet weak var friendsSearchBar: UISearchBar!
    
    struct Section<T> {
        var title: String
        var items: [T]
    }
    
    struct User {
        var name: String
        var surname: String
        var isOnline: Bool
        var avatarPath: String
    }
    
    var friendSection = [Section<User>]()
    var friendSectionTitles = [String]()
    
    var friends = [
        User(name: "Артем", surname: "Аверин", isOnline: false, avatarPath: "user1"),
        User(name: "Сидор", surname: "Сидоров", isOnline: false, avatarPath: "user2"),
        User(name: "Василий", surname: "Кошкин", isOnline: true, avatarPath: "user3"),
        User(name: "Александр", surname: "Стаценко", isOnline: false, avatarPath: "user1"),
        User(name: "Аскар", surname: "Аитов", isOnline: false, avatarPath: "user3"),
        User(name: "Борис", surname: "Борисов", isOnline: false, avatarPath: "user1"),
        User(name: "Виктор", surname: "Баранов", isOnline: true, avatarPath: "user3"),
        User(name: "Иван", surname: "Иванов", isOnline: false, avatarPath: "user2"),
        User(name: "Петр", surname: "Петров", isOnline: false, avatarPath: "user1"),
        User(name: "Василий", surname: "Пупкин", isOnline: false, avatarPath: "user2"),
        User(name: "Антон", surname: "Колесов", isOnline: false, avatarPath: "user3"),
        User(name: "Иван", surname: "Вдовин", isOnline: false, avatarPath: "user1"),
        User(name: "Денис", surname: "Ларионов", isOnline: false, avatarPath: "user2")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        friendsSearchBar.delegate = self
        let groupedDictionary = Dictionary(grouping: friends, by: {$0.surname.prefix(1)})
        friendSection = groupedDictionary.map{ Section(title: String($0.key), items: $0.value) }
        friendSection.sort { $0.title < $1.title }
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return friendSection.count
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        //view.tintColor = UIColor(displayP3Red: 255, green: 255, blue: 255, alpha: 0.8)
        view.tintColor = UIColor.white
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.label
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friendSection[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return friendSection[section].title
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let name = friendSection[indexPath.section].items[indexPath.row].name
        let surname = friendSection[indexPath.section].items[indexPath.row].surname
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTemplate", for: indexPath) as? FriendCell else {
            return UITableViewCell()
        }
        cell.userName.text = surname + " " + name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = friendSection[indexPath.section].items[indexPath.row].name
        let surname = friendSection[indexPath.section].items[indexPath.row].surname
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "FriendPhotoController") as! FriendPhotoList
        vc.user = name + " " + surname
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendSectionTitles
    }
}
extension FriendList: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let friendDictionary = Dictionary.init(grouping: friends.filter { (user) -> Bool in
            if ( user.name.lowercased().contains(searchText.lowercased()) ) {
                return user.name.lowercased().contains(searchText.lowercased())
            } else {
                return searchText.isEmpty ? true : user.surname.lowercased().contains(searchText.lowercased())
            }
        }) { $0.surname.prefix(1) }
        friendSection = friendDictionary.map { Section(title: String($0.key), items: $0.value) }
        friendSection.sort { $0.title < $1.title }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
