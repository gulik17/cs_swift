//
//  UserRealm.swift
//  vkontakte
//
//  Created by Администратор on 28.01.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import RealmSwift

class UserRealm: Object {
    @objc dynamic var id = 0
    @objc dynamic var name = ""
    @objc dynamic var photo50 = ""
}
