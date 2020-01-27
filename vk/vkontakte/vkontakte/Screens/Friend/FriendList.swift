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
    
    var friendSection = [Section<Friend>]()
    var friendSectionTitles = [String]()
    
    var friends = [Friend]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let api = VKApi()
        api.getFriendList(token: Session.shared.token) { (data: Swift.Result<[Friend], Error>) in
            switch data {
            case .failure(let error):
                print(error)
            case .success(let resData):
                self.friends = resData
                self.friendsSearchBar.delegate = self
                let groupedDictionary = Dictionary(grouping: self.friends, by: {$0.lastName.prefix(1)})
                self.friendSection = groupedDictionary.map{ Section(title: String($0.key), items: $0.value) }
                self.friendSection.sort { $0.title < $1.title }
                self.tableView.reloadData()
            }
        }
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
        let friendItem = friendSection[indexPath.section].items[indexPath.row]
        let firstName = friendItem.firstName
        let lastName = friendItem.lastName
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FriendTemplate", for: indexPath) as? FriendCell else {
            return UITableViewCell()
        }
        cell.id = friendItem.id
        cell.firstName = friendItem.firstName
        cell.lastName = friendItem.lastName
        cell.userName.text = lastName + " " + firstName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let id = friendSection[indexPath.section].items[indexPath.row].id
        let firstName = friendSection[indexPath.section].items[indexPath.row].firstName
        let lastName = friendSection[indexPath.section].items[indexPath.row].lastName
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "FriendPhotoController") as! FriendPhotoList
        vc.user = firstName + " " + lastName
        vc.userId = id
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return friendSectionTitles
    }
}
extension FriendList: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let friendDictionary = Dictionary.init(grouping: friends.filter { (friend) -> Bool in
            if ( friend.firstName.lowercased().contains(searchText.lowercased()) ) {
                return friend.firstName.lowercased().contains(searchText.lowercased())
            } else {
                return searchText.isEmpty ? true : friend.lastName.lowercased().contains(searchText.lowercased())
            }
        }) { $0.firstName.prefix(1) }
        friendSection = friendDictionary.map { Section(title: String($0.key), items: $0.value) }
        friendSection.sort { $0.title < $1.title }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
