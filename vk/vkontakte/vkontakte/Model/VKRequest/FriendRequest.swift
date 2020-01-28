//
//  FriendRequest.swift
//  vkontakte
//
//  Created by Администратор on 23.01.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

struct Friend: Decodable {
    var id: Int
    var firstName: String
    var lastName: String
    var online: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case online
    }
}
