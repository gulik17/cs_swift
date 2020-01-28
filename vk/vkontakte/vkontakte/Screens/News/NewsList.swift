//
//  NewList.swift
//  vkontakte
//
//  Created by Администратор on 18.12.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class NewsList: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTemplate", for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        return cell
    }

}
