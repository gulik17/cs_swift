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

class LoginController: UIViewController {
    
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
                                   URLQueryItem(name: "scope", value: "wall,friends"),
                                   URLQueryItem(name: "response_type", value: "token"),
                                   URLQueryItem(name: "v", value: "5.103"),]
        let request = URLRequest(url: urlComponent.url!)
        webView.load(request)
        view = webView
    }

    func showAlert(title: String, message: String, titleAction: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: titleAction, style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
}
