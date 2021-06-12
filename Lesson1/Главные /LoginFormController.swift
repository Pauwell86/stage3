//
//  LoginFormController.swift
//  VK
//
//  Created by Pauwell on 06.04.2021.
//

import UIKit
import WebKit
import SwiftKeychainWrapper


class LoginFormController: UIViewController, WKNavigationDelegate {

   
    @IBOutlet weak var webView: WKWebView! {
    didSet{
        webView.navigationDelegate = self
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let token = KeychainWrapper.standard.string(forKey: "vkToken") {
            DataStorage.shared.tokenVk = token
            showMainTabBar()
            return
        }
        
        authorizateToVK()        
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
//            print(token as Any)

            KeychainWrapper.standard.set(token, forKey: "vkToken")
            DataStorage.shared.tokenVk = token
            showMainTabBar()
        }
        
        decisionHandler(.cancel)
    }


    func showMainTabBar() {
        performSegue(withIdentifier: "fromFirstPageToSecondSegue", sender: nil)
    }
    
 }
    

    
