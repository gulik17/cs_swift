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
    @objc dynamic var online = 0
}
