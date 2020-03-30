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
    var profiles: JSON = ""
    var groups: JSON = ""
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
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return newsJson.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row == 2) {
            
            

        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTplHeader", for: indexPath) as? NewsCell else {
                return UITableViewCell()
            }
            let sourceId = newsJson[indexPath.section]["source_id"].intValue
            if (sourceId < 0) {
                if let items = groups.array {
                    for item in items {
                        if item["id"].intValue == sourceId*(-1) {
                            cell.NewsOwnerImage.kf.indicatorType = .activity
                            let link = item["photo_50"].stringValue
                            cell.NewsOwnerImage.kf.setImage(with: URL(string: link), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
                            cell.NewsOwnerLabel.text = item["name"].stringValue
                        }
                    }
                }
            }
            return cell
        }
        if (indexPath.row == 1) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTplText", for: indexPath) as? NewsCell else {
                return UITableViewCell()
            }
            cell.newsTitle.text = newsJson[indexPath.section]["text"].stringValue
            return cell
        }
        
        if (indexPath.row == 2) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTplMore", for: indexPath) as? NewsCell else {
                return UITableViewCell()
            }
            
            if newsJson[indexPath.section]["text"].stringValue.count > 100 {
                cell.isHidden = false
            } else {
                cell.isHidden = true
            }

            return cell
        }
        
        if (indexPath.row == 3) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTplImg", for: indexPath) as? NewsCell else {
                return UITableViewCell()
            }
            cell.newsImage.kf.indicatorType = .activity
            let attType = newsJson[indexPath.section]["attachments"][0]["type"]
            switch attType {
            case "photo":
                let lastPhotoCount = newsJson[indexPath.section]["attachments"][0]["photo"]["sizes"].count - 1
                let link = newsJson[indexPath.section]["attachments"][0]["photo"]["sizes"][lastPhotoCount]["url"].stringValue
                cell.newsImage.kf.setImage(with: URL(string: link), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
            case "link":
                let lastPhotoCount = newsJson[indexPath.section]["attachments"][0]["link"]["photo"]["sizes"].count - 1
                let link = newsJson[indexPath.section]["attachments"][0]["link"]["photo"]["sizes"][lastPhotoCount]["url"].stringValue
                cell.newsImage.kf.setImage(with: URL(string: link), placeholder: nil, options: [.transition(.fade(0.7))], progressBlock: nil)
            default:
                cell.newsImage.image = UIImage(named: "not_found")
            }
            return cell
        }
        
        if (indexPath.row == 4) {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "NewsTplFooter", for: indexPath) as? NewsCell else {
                return UITableViewCell()
            }
            let comments = newsJson[indexPath.section]["comments"]["count"].stringValue
            let likes = newsJson[indexPath.section]["likes"]["count"].stringValue
            let reposts = newsJson[indexPath.section]["reposts"]["count"].stringValue
            let views = newsJson[indexPath.section]["views"]["count"].stringValue
            cell.newsLike.setTitle(likes, for: .normal)
            cell.newsComments.setTitle(comments, for: .normal)
            cell.newsRepost.setTitle(reposts, for: .normal)
            cell.newsViews.setTitle(views, for: .normal)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func updateNews() {
        let api = VKApi()
        api.getNewsList(token: Session.shared.token) { (data: Swift.Result<Any, Error>) in
            switch data {
            case .failure(let error):
                print(error)
            case .success(let resData):
                self.newsJson = JSON(resData)["response"]["items"]
                self.profiles = JSON(resData)["response"]["profiles"]
                self.groups = JSON(resData)["response"]["groups"]
                self.tableView.reloadData()
            }
        }
    }

}
