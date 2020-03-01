//
//  FriendRealm.swift
//  vkontakte
//
//  Created by Администратор on 28.01.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RealmSwift

class FriendRealm: Object {
    @objc dynamic var id = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var photo = ""
    @objc dynamic var online = 0
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo = "photo_50"
        case online
    }
    
    // Проверка для перезаписи
    override class func primaryKey() -> String? {
        return "id"
    }
    
    // Индексируем нужные свойства, для ускорения работы по фильтрации
    override class func indexedProperties() -> [String] {
        return ["lastname", "name", "online"]
    }
    
    // Конвертация типа Realm к обычной модели
    func toModel() -> Friend {
        return Friend(id: id,
                      firstName: firstName,
                      lastName: lastName,
                      photo: photo,
                      online: online)
    }
}
