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
    let isClosed: Int
    let type: String
    let isMember: Int?
    let photo50: String
    
    enum CodingKeys: String, CodingKey {
        case id, name, type
        case isClosed = "is_closed"
        case isMember = "is_member"
        case photo50 = "photo_50"
    }
}

extension GroupRequest {
    func toGroups() -> [Group] {
        var groups = [Group]()
        request.items.forEach { (groupItem) in
            guard let subscription = groupItem.isMember else {
                return
            }
            groups.append(Group(id: groupItem.id,
                                name: groupItem.name,
                                type: groupItem.type,
                                isClosed: groupItem.isClosed,
                                isMember: groupItem.isMember,
                                photo50: groupItem.photo50))
        }
        return groups
    }
}
