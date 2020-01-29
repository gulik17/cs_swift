//
//  NewsRequest.swift
//  vkontakte
//
//  Created by Администратор on 28.01.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

struct News: Decodable {
    var type: String
    var sourceId: Int?
    var date: Int
    var postId: Int?
    var postType: String?
    var text: String
    var markedAsAds: Int?
    var attachments: [Attachment]?
    var comments: Comments
    var likes: Likes
    var reposts: Reposts
    var views: Views
    
    enum CodingKeys: String, CodingKey {
        case type
        case sourceId = "source_id"
        case date
        case postId = "post_id"
        case postType = "post_type"
        case text
        case markedAsAds = "marked_as_ads"
        case attachments
        case comments
        case likes
        case reposts
        case views
    }
}

struct Attachment: Codable {
    var type: String?
    var link: Link?
}

struct Link: Codable {
    var url: String
    var title: String
    var caption: String?
    var description: String
    var photo: NewsPhoto?
}

struct NewsPhoto: Codable {
    var id: Int
    var albumId: Int
    var ownerId: Int
    var photo75: String
    var photo130: String
    var photo604: String
    var width: Int
    var height: Int
    var text: String
    var date: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case albumId = "album_id"
        case ownerId = "owner_id"
        case photo75 = "photo_75"
        case photo130 = "photo_130"
        case photo604 = "photo_604"
        case width
        case height
        case text
        case date
    }
}

struct Comments: Codable {
    var count: Int
    var canPost: Int
    
    enum CodingKeys: String, CodingKey {
        case count
        case canPost = "can_post"
    }
}

struct Likes: Codable {
    var count: Int
    var userLikes: Int
    var canLike: Int
    var canPublish: Int
    
    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
        case canLike = "can_like"
        case canPublish = "can_publish"
    }
}

struct Reposts: Codable {
    var count: Int
    var userReposted: Int
    
    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}

struct Views: Codable {
    var count: Int
}
