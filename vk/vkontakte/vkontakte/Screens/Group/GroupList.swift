//
//  GroupList.swift
//  vkontakte
//
//  Created by Администратор on 03.12.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import RealmSwift

protocol GroupsListView: class {
    func updateTable()
}

class GroupList: UITableViewController {
    @IBOutlet weak var groupsSearchBar: UISearchBar!
    
    let api = VKApi()
    var groupRefreshControl = UIRefreshControl()
    var groupDB = GroupRepository()
    
    var groupResult: Results<GroupRealm>?
    var token: NotificationToken?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupRefreshControl.attributedTitle = NSAttributedString(string: "Идет обновление...")
        groupRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(groupRefreshControl)
        
        groupsSearchBar.delegate = self
        loadGroups()
        loadAPIData()
    }
    
    deinit {
        token?.invalidate()
    }
    
    @objc func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.loadGroups()
            self.groupRefreshControl.endRefreshing()
        }
    }
    
    func loadAPIData() {
        api.getGroupList(token: Session.shared.token) { result in
            switch result {
                case .success(let groups):
                    self.groupDB.addGroups(groups: groups)
                case .failure(let error):
                    print("Ошибка getGroupList: \(error)")
            }
        }
    }
    
    func loadGroups() {
        do {
            groupResult = try groupDB.getAllGroups()
            token = groupResult?.observe { [weak self] results in
                switch results {
                case .error(let error):
                    print(error)
                case .initial:
                    self?.tableView.reloadData()
                case let .update(_, deletions, insertions, modifications):
                    self?.tableView.beginUpdates()
                    self?.tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) }, with: .none)
                    self?.tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) }, with: .none)
                    self?.tableView.reloadRows(at: modifications.map { IndexPath(row: $0, section: 0) }, with: .none)
                    self?.tableView.endUpdates()
                }
            }
        } catch {
            print(error)
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupResult?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTemplate", for: indexPath) as! GroupCell
        cell.groupName.text = groupResult?[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            groupDB.removeGroup(groupId: groupResult?[indexPath.row].id)
            loadGroups()
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension GroupList: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        do {
            self.groupResult = searchText.isEmpty ?
                try groupDB.getAllGroups() :
                try groupDB.searchGroups(name: searchText.lowercased())
        } catch { print("searchBar ERROR: \(error)") }
        self.updateTable()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension GroupList: GroupsListView {
    func updateTable() {
        tableView.reloadData()
    }
}
