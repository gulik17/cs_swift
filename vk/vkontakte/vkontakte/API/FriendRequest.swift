//
//  FriendRequest.swift
//  vkontakte
//
//  Created by Администратор on 23.01.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

struct FriendRequest: Decodable {
    let request: FriendData
}

struct FriendData: Decodable {
    let items: [FriendItem]
}

struct FriendItem: Decodable {
    let id: Int
    let firstName: String
    let lastName: String
    let photo50: String
    let online: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo50 = "photo_50"
        case online
    }
}

extension FriendRequest {
    func toFriends() -> [Friend] {
        var friends = [Friend]()
        request.items.forEach { (item) in
            friends.append(Friend(id: item.id,
                                firstName: item.firstName,
                                lastName: item.lastName,
                                photo50: item.photo50,
                                online: item.online))
        }
        return friends
    }
}
