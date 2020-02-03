//
//  FriendSource.swift
//  vkontakte
//
//  Created by Администратор on 03.02.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import RealmSwift

protocol FriendSource {
    func getAllUsers() throws -> Results<FriendRealm>
    func addUsers(users: [Friend])
    func searchFriends(firstName: String) throws -> Results<FriendRealm>
}

class FriendRepository: FriendSource {

    // Получим всех пользователей из Realm
    func getAllUsers() throws -> Results<FriendRealm> {
        do {
            let realm = try Realm()
            return realm.objects(FriendRealm.self)
        } catch {
            throw error
        }
    }

    // Добавляем все пользователей в Realm DB
    func addUsers(users: [Friend]) {
        do {
            let realm = try! Realm()
            try realm.write() {
                var usersToAdd = [FriendRealm]()
                users.forEach { user in
                    let userRealm = FriendRealm()
                    userRealm.id = user.id
                    userRealm.firstName = user.firstName
                    userRealm.lastName = user.lastName
                    userRealm.photo = user.photo
                    userRealm.online = user.online
                    usersToAdd.append(userRealm)
                }
                // Добавляем созданный массив пользователей в репозиторий
                realm.add(usersToAdd, update: .modified)
            }
        } catch {
            print(error)
        }
    }

    // Поиск по друзьям
    func searchFriends(firstName: String) throws -> Results<FriendRealm> {
        do {
            let realm = try Realm()
            return realm.objects(FriendRealm.self).filter("firstName CONTAINS[c] %@", firstName)
        } catch {
            throw error
        }
    }
}
