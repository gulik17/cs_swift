//
//  NewList.swift
//  vkontakte
//
//  Created by Администратор on 18.12.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import SwiftyJSON

class NewsList: UITableViewController {
    var newsJson: JSON = ""
    var newsRefreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        newsRefreshControl.attributedTitle = NSAttributedString(string: "Идет обновление...")
        newsRefreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        tableView.addSubview(newsRefreshControl)
        
        updateNews()
    }
    
    @objc func refresh() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.updateNews()
            self.newsRefreshControl.endRefreshing()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsJson.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let title = newsJson[indexPath.row]["text"].stringValue
        let comments = newsJson[indexPath.row]["comments"]["count"].stringValue
        let likes = newsJson[indexPath.row]["likes"]["count"].stringValue
        let reposts = newsJson[indexPath.row]["reposts"]["count"].stringValue
        let views = newsJson[indexPath.row]["views"]["count"].stringValue
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTemplate", for: indexPath) as? NewsCell else {
            return UITableViewCell()
        }
        
        cell.newsImage.kf.indicatorType = .activity
        let attType = newsJson[indexPath.row]["attachments"][0]["type"]
        switch attType {
        case "photo":
            let lastPhotoCount = newsJson[indexPath.row]["attachments"][0]["photo"]["sizes"].count - 1
            let link = newsJson[indexPath.row]["attachments"][0]["photo"]["sizes"][lastPhotoCount]["url"].stringValue
            cell.newsImage.kf.setImage(with: URL(string: link), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        case "link":
            let lastPhotoCount = newsJson[indexPath.row]["attachments"][0]["link"]["photo"]["sizes"].count - 1
            let link = newsJson[indexPath.row]["attachments"][0]["link"]["photo"]["sizes"][lastPhotoCount]["url"].stringValue
            cell.newsImage.kf.setImage(with: URL(string: link), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
        default:
            cell.newsImage.image = UIImage(named: "not_found")
        }

        cell.newsTitle.text = title
        cell.newsLike.setTitle(likes, for: .normal)
        cell.newsComments.setTitle(comments, for: .normal)
        cell.newsRepost.setTitle(reposts, for: .normal)
        cell.newsViews.setTitle(views, for: .normal)
        
        return cell
    }
    
    func updateNews() {
        let api = VKApi()
        api.getNewsList(token: Session.shared.token) { (data: Swift.Result<Any, Error>) in
            switch data {
            case .failure(let error):
                print(error)
            case .success(let resData):
                self.newsJson = JSON(resData)["response"]["items"]
                self.tableView.reloadData()
            }
        }
    }

}
