//
//  VKApi.swift
//  vkontakte
//
//  Created by Администратор on 23.01.2020.
//  Copyright © 2020 Home. All rights reserved.
//

import Foundation
import Alamofire

enum HTTPError {
    case failedRequest(Message: String)
    case decodableError
}

class VKApi {
    private let vkURL = "https://api.vk.com/method/"

    func getFriendList(token: String) {
        let request = vkURL + "friends.get"

        let params: [String: Any] = [
            "access_token": token,
            "order": "name",
            "fields": "city,domain",
            "v": "5.103"
        ]

        //getData(requestURL: request, parameters: params, token: token, finished: { result in
        //    do {
        //        let response = try JSONDecoder().decode(FriendRequest.self, from: result)
        //    } catch let error {
        //        print(error)
        //    }
        //})
    }
    
    func getFriendPhotos(token: String, ownerId: String, result: @escaping (Swift.Result<[T], Error>)) {
        let request = vkURL + "photos.get"

        let params: [String: Any] = [
            "access_token": token,
            "owner_id": ownerId,
            "album_id": "wall",
            "v": "5.103"
        ]

        getData(requestURL: request, parameters: params) { (users: FriendRequest) in
            <#code#>
        }
    }
    
    func getMyGroups(token: String) {
        let request = vkURL + "groups.get"

        let params: [String: Any] = [
            "access_token": token,
            "extended": "1",
            "v": "5.103"
        ]

        //getData(requestURL: request, parameters: params, token: token, finished: { result in
        //    print("Получение своих групп")
        //    print(result)
        //})
    }
    
    func searchGroups(token: String, query: String) {
        let request = vkURL + "groups.search"

        let params: [String: Any] = [
            "access_token": token,
            "q": query,
            "v": "5.103"
        ]

        //getData(requestURL: request, parameters: params, token: token, finished: { result in
        //    print("Поиск группы на названию")
       //     print(result)
       // })
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
                    do {
                        let response = try JSONDecoder().decode(T.self, from: data)
                        finished(.success(response))
                    } catch let error {
                        finished(.failure(HTTPError.decodableError))
                    }
                }
        }
        
        
        var res: String?
        let url = URL(string: requestURL)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        request.httpBody = parameters.percentEncoded()

        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) in
            guard let data = data,
                let response = response as? HTTPURLResponse,
                error == nil else {
                    print("error", error ?? "Unknown error")
                    return
            }

            guard (200 ... 299) ~= response.statusCode else {
                print("statusCode should be 2xx, but is \(response.statusCode) \r response = \(response)")
                return
            }

            res = String(data: data, encoding: .utf8)!
            finished(res ?? "")

        })

        task.resume()
    }
}
