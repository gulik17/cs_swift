//
//  GroupRealm.swift
//  vkontakte
//
//  Created by Администратор on 28.01.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RealmSwift

class GroupRealm: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var screenName = ""
    @objc dynamic var isClosed = 0
    @objc dynamic var type = ""
    @objc dynamic var isAdmin = 0
    @objc dynamic var isMember = 0
    @objc dynamic var isAdvertiser = 0
    @objc dynamic var photo50 = ""
    @objc dynamic var photo100 = ""
    @objc dynamic var photo200 = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    // Конвертация типа Realm к обычной модели
    func toModel() -> Group {
        return Group(
            id: id,
            name: name,
            screenName: screenName,
            isClosed: isClosed,
            type: type,
            isAdmin: isAdmin,
            isMember: isMember,
            isAdvertiser: isAdvertiser,
            photo50: photo50,
            photo100: photo100,
            photo200: photo200)
    }
}
