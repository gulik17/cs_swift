//
//  GroupList.swift
//  vkontakte
//
//  Created by Администратор on 03.12.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class GroupList: UITableViewController {
    @IBOutlet weak var groupsSearchBar: UISearchBar!
    
    struct Section<T> {
        var title: String
        var items: [T]
    }
    
    var groupSection = [Section<Group>]()
    var groupSectionTitles = [String]()
    
    var groups = [Group]()

    override func viewDidLoad() {
        super.viewDidLoad()
        let api = VKApi()
        api.getGroupList(token: Session.shared.token) { (data: Swift.Result<[Group], Error>) in
            switch data {
            case .failure(let error):
                print(error)
            case .success(let resData):
                self.groups = resData
                self.groupsSearchBar.delegate = self
                let groupedDictionary = Dictionary(grouping: self.groups, by: {$0.name.prefix(1)})
                self.groupSection = groupedDictionary.map{ Section(title: String($0.key), items: $0.value) }
                self.groupSection.sort { $0.title < $1.title }
                self.tableView.reloadData()
            }
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return groupSection.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupSection[section].items.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return groupSection[section].title
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTemplate", for: indexPath) as! GroupCell
        cell.groupName.text = groupSection[indexPath.section].items[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groupSection.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension GroupList: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let groupDictionary = Dictionary.init(grouping: groups.filter { (group) -> Bool in
        return searchText.isEmpty ? true : group.name.lowercased().contains(searchText.lowercased())
        }) { $0.name.prefix(1) }
        groupSection = groupDictionary.map { Section(title: String($0.key), items: $0.value) }
        groupSection.sort { $0.title < $1.title }
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
