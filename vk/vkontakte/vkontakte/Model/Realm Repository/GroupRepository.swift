//
//  GroupSource.swift
//  vkontakte
//
//  Created by Администратор on 03.02.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import RealmSwift

class GroupRepository {
    func getAllGroups() throws -> Results<GroupRealm> {
        do {
            let realm = try Realm()
            return realm.objects(GroupRealm.self)
        } catch {
            throw error
        }
    }

    func addGroups(groups: [Group]) {
        do {
            let realm = try! Realm()
            try realm.write() {
                var groupsToAdd = [GroupRealm]()
                groups.forEach { group in
                    let groupRealm = GroupRealm()
                    groupRealm.id = group.id
                    groupRealm.name = group.name
                    groupRealm.screenName = group.screenName
                    groupRealm.isClosed = group.isClosed
                    groupRealm.type = group.type
                    groupRealm.isAdmin = group.isAdmin ?? 0
                    groupRealm.isMember = group.isMember ?? 0
                    groupRealm.isAdvertiser = group.isAdvertiser ?? 0
                    groupRealm.photo50 = group.photo50
                    groupRealm.photo100 = group.photo100
                    groupRealm.photo200 = group.photo200
                    groupsToAdd.append(groupRealm)
                }
                // Добавляем созданный массив групп в репозиторий
                realm.add(groupsToAdd, update: .modified)
            }
        } catch {
            print(error)
        }
    }

    func searchGroups(name: String) throws -> Results<GroupRealm> {
        do {
            let realm = try Realm()
            return realm.objects(GroupRealm.self).filter("name CONTAINS[c] %@", name)
        } catch {
            throw error
        }
    }
}
