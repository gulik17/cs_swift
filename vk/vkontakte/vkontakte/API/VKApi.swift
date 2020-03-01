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

    func getFriendList(token: String, completion: @escaping (Swift.Result<[Friend], Error>) -> Void) {
        let request = vkURL + "friends.get"

        let params: [String: Any] = [
            "access_token": token,
            "order": "name",
            "fields": "photo_50",
            "v": "5.103"
        ]

        getData(requestURL: request, parameters: params) { completion($0) }
    }
    
    func getFriendPhotoList(token: String, ownerId: Int, completion: @escaping (Swift.Result<[Photo], Error>) -> Void) {
        let request = vkURL + "photos.getAll"
        
        let params: [String: Any] = [
            "access_token": token,
            "owner_id": ownerId,
            "extended": 1,
            "v": "5.103"
        ]

        getData(requestURL: request, parameters: params) { completion($0) }
    }
    
    func getNewsList(token: String, completion: @escaping (Swift.Result<[News], Error>) -> Void) {
        let request = vkURL + "newsfeed.get"

        let params: [String: Any] = [
            "access_token": token,
            "filters": "post",
            "count": 5,
            "v": "5.103"
        ]

        getData(requestURL: request, parameters: params) { completion($0) }
    }
    
    func getGroupList(token: String, completion: @escaping (Swift.Result<[Group], Error>) -> Void) {
        let request = vkURL + "groups.get"

        let params: [String: Any] = [
            "access_token": token,
            "extended": "1",
            "v": "5.103"
        ]

        getData(requestURL: request, parameters: params) { completion($0) }
    }
    
    func searchGroups(token: String, query: String, completion: @escaping (Swift.Result<[Group], Error>) -> Void) {
        let request = vkURL + "groups.search"

        let params: [String: Any] = [
            "access_token": token,
            "q": query,
            "v": "5.103"
        ]

        getData(requestURL: request, parameters: params) { completion($0) }
    }
    
    func getData<T: Decodable>(requestURL: String, parameters: Parameters, completion: @escaping (Swift.Result<[T], Error>) -> Void) {
        AF.request(requestURL,
                          method: .post,
                          parameters: parameters)
            .responseData{ (result) in
                guard let data = result.value else { return }
                let output = String(data: data, encoding: String.Encoding.utf8)
                print(output! as Any)
                let response = try! JSONDecoder().decode(CommonResponse<T>.self, from: data)
                do {
                    let result = try JSONDecoder().decode(CommonResponse<T>.self, from: data)
                    completion(.success(result.response.items))
                } catch {
                    completion(.failure(HTTPError.decodableError))
                }
        }
    }
}
