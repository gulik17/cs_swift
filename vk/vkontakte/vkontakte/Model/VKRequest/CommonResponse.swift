//
//  CommonResponse.swift
//  vkontakte
//
//  Created by Администратор on 27.01.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation

struct CommonResponse<T: Decodable>: Decodable {
    var response: CommonResponseArray<T>
}

struct CommonResponseArray<T: Decodable>: Decodable {
    var count: Int
    var items: [T]
}
