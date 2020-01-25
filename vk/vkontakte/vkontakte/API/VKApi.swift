//
//  VKApi.swift
//  vkontakte
//
//  Created by Администратор on 23.01.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

enum HTTPError: Error {
    case failedRequest(Message: String)
    case decodableError
}

class VKApi {
    private let vkURL = "https://api.vk.com/method/"

    func getFriendList(token: String, result: @escaping (Swift.Result<[Friend], Error>) -> Void) {
        let request = vkURL + "friends.get"

        let params: [String: Any] = [
            "access_token": token,
            "order": "name",
            "fields": "city,domain",
            "v": "5.103"
        ]

        getData(requestURL: request, parameters: params) { (data: Swift.Result<FriendRequest, Error>) in
            switch data {
            case .failure(let error):
                result(.failure(error))
            case .success(let resData):
                result(.success(resData.toFriends()))
            }
        }
    }
    
    func getFriendPhotos(token: String, ownerId: String, result: @escaping (Swift.Result<[Photo], Error>) -> Void) {
        let request = vkURL + "photos.get"

        let params: [String: Any] = [
            "access_token": token,
            "owner_id": ownerId,
            "album_id": "wall",
            "v": "5.103"
        ]

        getData(requestURL: request, parameters: params) { (data: Swift.Result<PhotoRequest, Error>) in
            switch data {
            case .failure(let error):
                result(.failure(error))
            case .success(let resData):
                result(.success(resData.toPhotos()))
            }
        }
    }
    
    func getMyGroups(token: String, result: @escaping (Swift.Result<[Group], Error>) -> Void) {
        let request = vkURL + "groups.get"

        let params: [String: Any] = [
            "access_token": token,
            "extended": "1",
            "v": "5.103"
        ]

        getData(requestURL: request, parameters: params) { (data: Swift.Result<GroupRequest, Error>) in
            switch data {
            case .failure(let error):
                result(.failure(error))
            case .success(let resData):
                result(.success(resData.toGroups()))
            }
        }
    }
    
    func searchGroups(token: String, query: String, result: @escaping (Swift.Result<[Group], Error>) -> Void) {
        let request = vkURL + "groups.search"

        let params: [String: Any] = [
            "access_token": token,
            "q": query,
            "v": "5.103"
        ]

        getData(requestURL: request, parameters: params) { (data: Swift.Result<GroupRequest, Error>) in
            switch data {
            case .failure(let error):
                result(.failure(error))
            case .success(let resData):
                result(.success(resData.toGroups()))
            }
        }
    }
    
    func getData<T: Decodable>(requestURL: String, parameters: Parameters, finished: @escaping (Swift.Result<T, Error>) -> Void) {
        Alamofire.request(requestURL,
                          method: .post,
                          parameters: parameters)
            .responseData{ (response) in
                
                switch response.result {
                case .failure(let error):
                    finished(.failure(HTTPError.failedRequest(Message: error.localizedDescription)))
                case .success(let data):
                    //let output = String(data: data, encoding: String.Encoding.utf8)
                    //print(output! as Any)
                    do {
                        let response = try JSONDecoder().decode(T.self, from: data)
                        finished(.success(response))
                    } catch {
                        finished(.failure(HTTPError.decodableError))
                    }
                }
        }
    }
}
