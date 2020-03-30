//
//  GroupList.swift
//  vkontakte
//
//  Created by Администратор on 03.12.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

protocol GroupsListView: class {
    func updateTable()
}

class GroupList: UITableViewController {
    @IBOutlet weak var groupsSearchBar: UISearchBar!
    
    let api = VKApi()
    var groupRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupRefreshControl.attributedTitle = NSAttributedString(string: "Идет обновление...")
        groupRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(groupRefreshControl)
        
        groupsSearchBar.delegate = self
    }
    
    @objc func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
           // self.loadGroups()
            self.groupRefreshControl.endRefreshing()
        }
    }


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GroupTemplate", for: indexPath) as! GroupCell
       // cell.groupName.text = groupResult?[indexPath.row].name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            //tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
}

extension GroupList: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

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
