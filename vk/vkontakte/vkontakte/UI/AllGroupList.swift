//
//  GroupList.swift
//  vkontakte
//
//  Created by Администратор on 03.12.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class AllGroupList: UITableViewController {
    
    var groupList = ["Объявления Сочи", "Недвижимость Сочи", "Фильмы 2019", "Новинки музыки"]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AllGroupTemplate", for: indexPath) as! GroupCell
        cell.allGroupName.text = groupList[indexPath.row]
        return cell
    }
}
