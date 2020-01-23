//
//  GroupRequest.swift
//  vkontakte
//
//  Created by Администратор on 23.01.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

struct GroupRequest: Decodable {
    let request: GroupData
}

struct GroupData: Decodable {
    let items: [GroupItem]
}

struct GroupItem: Decodable {
    let id: Int
    let name: String
    let screenName: String
    let isClosed: Int
    let type: String
    let isAdmin: Int?
    let isMember: Int?
    let isAdvertiser: Int?
    let photo50: String
    let photo100: String
    let photo200: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type = "type"
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case photo50  = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}

extension GroupRequest {
    func toGroups() -> [Group] {
        var groups = [Group]()
        request.items.forEach { (item) in
            guard let subscription = item.isMember else {
                return
            }
            groups.append(Group(id: item.id,
                                name: item.name,
                                screenName: item.screenName,
                                isClosed: item.isClosed,
                                type: item.type,
                                isAdmin: item.isAdmin ?? 0,
                                isMember: item.isMember ?? 0,
                                isAdvertiser: item.isAdvertiser ?? 0,
                                photo50: item.photo50,
                                photo100: item.photo100,
                                photo200: item.photo200))
        }
        return groups
    }
}
