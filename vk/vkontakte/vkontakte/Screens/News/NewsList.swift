//
//  NewList.swift
//  vkontakte
//
//  Created by Администратор on 18.12.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class NewsList: UITableViewController {
    var news = [News]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let api = VKApi()
        api.getNewsList(token: Session.shared.token) { (data: Swift.Result<[News], Error>) in
            switch data {
            case .failure(let error):
                print(error)
            case .success(let resData):
                self.news = resData
                self.tableView.reloadData()
            }
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = news[indexPath.row].text
        let link = news[indexPath.row].attachments?.first?.link?.photo?.photo130 ?? "https://sun1-24.userapi.com/UGWcXKo0ob95KbL8YSioQ30xwFxawPUzLqIRQg/ow7STC5TvWk.jpg"
        let photo = URL(string: link)
        
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTemplate", for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        
        cell.newsTitle.text = title
        if let data = try? Data(contentsOf: photo!) {
            cell.newsImage.image = UIImage(data: data)
        }
        return cell
    }

}
