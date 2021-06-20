//
//  LoginFormController.swift
//  VK
//
//  Created by Pauwell on 06.04.2021.
//

import UIKit
import WebKit
import SwiftKeychainWrapper
import FirebaseAuth


class LoginFormController: UIViewController, WKNavigationDelegate {


    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    private var handle: AuthStateDidChangeListenerHandle!

    
    @IBOutlet weak var webView: WKWebView! {
    didSet{
        webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let token = KeychainWrapper.standard.string(forKey: "vkToken") {
            DataStorage.shared.tokenVk = token
            return
        }
        
        authorizateToVK()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.handle = Auth.auth().addStateDidChangeListener { [weak self] auth, user in
            if user != nil {
                self?.showMainTabBar()
                self?.loginTextField.text = nil
                self?.passwordTextField.text = nil
            }
        }

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        Auth.auth().removeStateDidChangeListener(handle)
    }
    
    //MARK: - Private
    
 private func authorizateToVK() {
        var urlComponents = URLComponents()
                urlComponents.scheme = "https"
                urlComponents.host = "oauth.vk.com"
                urlComponents.path = "/authorize"
                urlComponents.queryItems = [
                    URLQueryItem(name: "client_id", value: "7868384"),
                    URLQueryItem(name: "display", value: "mobile"),
                    URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
                    URLQueryItem(name: "scope", value: "262150"),
                    URLQueryItem(name: "response_type", value: "token"),
                    URLQueryItem(name: "v", value: "5.131")
                ]
                let request = URLRequest(url: urlComponents.url!)
                webView.load(request)
    }
    
    //MARK: - WKNavigationDelegate
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        
        guard let url = navigationResponse.response.url,
              url.path == "/blank.html",
              let fragment = url.fragment  else {
            decisionHandler(.allow)
            return
        }
        
        let params = fragment
            .components(separatedBy: "&")
            .map { $0.components(separatedBy: "=") }
            .reduce([String: String]()) { result, param in
                var dict = result
                let key = param[0]
                let value = param[1]
                dict[key] = value
                return dict
        }
                
        if let token = params["access_token"] {
            print(token as Any)

            KeychainWrapper.standard.set(token, forKey: "vkToken")
            DataStorage.shared.tokenVk = token
        }
        
        decisionHandler(.cancel)
    }


    @IBAction func pressSignButton(_ sender: UIButton) {
        
        guard
               let email = loginTextField.text,
               let password = passwordTextField.text,
               !email.isEmpty,
               !password.isEmpty
               else {
                   self.showAlert(title: "Error", message: "Login/password is not entered")
                   return
               }

           Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
               if let error = error,
                      user == nil {
                self?.showAlert(title: "Error", message: error.localizedDescription)
                   }
               }
     }
    
    @IBAction func signupButtonPressed(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Sign up",
                                      message: "Enter your credentials",
                                      preferredStyle: .alert)
        
        alert.addTextField { textEmail in
                textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
                textPassword.isSecureTextEntry = true
                textPassword.placeholder = "Enter your password"
        }
    
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
              guard let emailField = alert.textFields?[0],
                    let passwordField = alert.textFields?[1],
                    let password = passwordField.text,
                    let email = emailField.text else { return }
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] user, error in
                if let error = error {
                    self?.showAlert(title: "Error", message: error.localizedDescription)
                } else {
                    Auth.auth().signIn(withEmail: email, password: password)
                }
            }
        }

        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }

    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(ok)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func signOut(_ seg: UIStoryboardSegue){
        do {
            try Auth.auth().signOut()
            self.dismiss(animated: true, completion: nil)
        } catch (let error) {
            print("Auth sign out failed: \(error)")
        }

    }
    
    func showMainTabBar() {
        performSegue(withIdentifier: "fromFirstPageToSecondSegue", sender: nil)
    }
    
 }
    

    
