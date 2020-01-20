//
//  ViewController.swift
//  vkontakte
//
//  Created by Администратор on 23.11.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit
import WebKit

class Session {
    static let shared = Session()
    private init() {}
    
    var token: String = ""
    var userId: Int = 0
}

class ViewController: UIViewController {
    
    let VKSecret = "7287671"
    
    var webView: WKWebView!
    var vkAPI = VKApi()

    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginButtonAction(_ sender: Any) {
        if (loginTextField.text == "" && passwordTextField.text == "") {
            performSegue(withIdentifier: "loginSuccess", sender: sender)
        } else {
            showAlert(title: "Error", message: "Login or Password is wrong", titleAction: "OK")
        }
    }

    @IBOutlet weak var scrollView: UIScrollView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let webViewConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webViewConfig)
        webView.navigationDelegate = self
        
        var urlComponent = URLComponents()
        urlComponent.scheme = "https"
        urlComponent.host = "oauth.vk.com"
        urlComponent.path = "/authorize"
        urlComponent.queryItems = [URLQueryItem(name: "client_id", value: VKSecret),
                                   URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                                   URLQueryItem(name: "scope", value: "262150"),
                                   URLQueryItem(name: "response_type", value: "token"),
                                   URLQueryItem(name: "v", value: "5.103"),]
        let request = URLRequest(url: urlComponent.url!)
        webView.load(request)
        view = webView
        
        /*registerForKeyboardNotifications()
        let hideAction = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideAction)*/
    }

    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    deinit {
        removeKeyboardNotification()
    }

    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(kbWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func removeKeyboardNotification () {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func kbWillShow(_ notification: Notification) {
        let userInfo = notification.userInfo
        let kbFrameSize = (userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        scrollView.contentInset.bottom = kbFrameSize.height
    }

    @objc func kbWillHide() {
        scrollView.contentInset.bottom = 0
    }

    func showAlert(title: String, message: String, titleAction: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: titleAction, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}

class VKApi {
    let vkURL = "https://api.vk.com/method/"

    func getFriendList(token: String) {
        let request = vkURL + "friends.get"

        let params: [String: Any] = [
            "access_token": token,
            "order": "name",
            "fields": "city,domain",
            "v": "5.103"
        ]

        getData(requestURL: request, parameters: params, token: token, finished: { result in
            print("Получение списка друзей")
            print(result)
        })
    }
    
    func getFriendPhotos(token: String, ownerId: String) {
        let request = vkURL + "photos.get"

        let params: [String: Any] = [
            "access_token": token,
            "owner_id": ownerId,
            "album_id": "wall",
            "v": "5.103"
        ]

        getData(requestURL: request, parameters: params, token: token, finished: { result in
            print("Получение фотографий друга")
            print(result)
        })
    }
    
    func getMyGroups(token: String) {
        let request = vkURL + "groups.get"

        let params: [String: Any] = [
            "access_token": token,
            "extended": "1",
            "v": "5.103"
        ]

        getData(requestURL: request, parameters: params, token: token, finished: { result in
            print("Получение своих групп")
            print(result)
        })
    }
    
    func searchGroups(token: String, q: String) {
        let request = vkURL + "groups.search"

        let params: [String: Any] = [
            "access_token": token,
            "q": q,
            "v": "5.103"
        ]

        getData(requestURL: request, parameters: params, token: token, finished: { result in
            print("Поиск группы на названию")
            print(result)
        })
    }
    
    func getData(requestURL: String, parameters: [String: Any], token: String, finished: @escaping ((_ result : String)->Void)) {
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

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html", let fragment = url.fragment else {
                decisionHandler(.allow)
                return
        }
        
        let params = fragment.components(separatedBy: "&")
            .map{ $0.components(separatedBy: "=") }.reduce([String: String]()) {
                value, params in
                var dict = value
                let key = params[0]
                let value = params[1]
                dict[key] = value
                return dict
        }
        
        Session.shared.token = params["access_token"]!
        Session.shared.userId = Int(params["user_id"]!) ?? 0

        vkAPI.getFriendList(token: Session.shared.token)
        vkAPI.getFriendPhotos(token: Session.shared.token, ownerId: "-1")
        vkAPI.getMyGroups(token: Session.shared.token)
        vkAPI.searchGroups(token: Session.shared.token, q: "Music")
        
        decisionHandler(.cancel)
    }
}

extension Dictionary {
    func percentEncoded() -> Data? {
        return map { key, value in
            let escapedKey = "\(key)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            let escapedValue = "\(value)".addingPercentEncoding(withAllowedCharacters: .urlQueryValueAllowed) ?? ""
            return escapedKey + "=" + escapedValue
        }
        .joined(separator: "&")
        .data(using: .utf8)
    }
}

extension CharacterSet {
    static let urlQueryValueAllowed: CharacterSet = {
        let generalDelimitersToEncode = ":#[]@" // does not include "?" or "/" due to RFC 3986 - Section 3.4
        let subDelimitersToEncode = "!$&'()*+,;="

        var allowed = CharacterSet.urlQueryAllowed
        allowed.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        return allowed
    }()
}
