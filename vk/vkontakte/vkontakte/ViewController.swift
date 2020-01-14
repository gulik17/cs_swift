//
//  ViewController.swift
//  vkontakte
//
//  Created by Администратор on 23.11.2019.
//  Copyright © 2019 Home. All rights reserved.
//

import UIKit

class Session {
    static let shared = Session()
    private init() {}
    
    var token: String = ""
    var userId: Int = 0
}

class ViewController: UIViewController {

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
        registerForKeyboardNotifications()
        let hideAction = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(hideAction)
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

