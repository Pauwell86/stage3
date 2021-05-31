//
//  LoginFormController.swift
//  VK
//
//  Created by Pauwell on 06.04.2021.
//

import UIKit
import Alamofire
import WebKit

class LoginFormController: UIViewController {

   
    @IBOutlet weak var webView: WKWebView! {
    didSet{
        webView.navigationDelegate = self
        }
    }
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var gradientView: UIView!
        
    @IBOutlet weak var firstPoint: UIView!
    @IBOutlet weak var secondPoint: UIView!
    @IBOutlet weak var thirdPoint: UIView!
    
    let fromFirstPageToSecondSegue = "fromFirstPageToSecondSegue"
//    let weatherService = WeatherService()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstPoint.layer.cornerRadius = 5
        secondPoint.layer.cornerRadius = 5
        thirdPoint.layer.cornerRadius = 5
        firstPoint.alpha = 0
        secondPoint.alpha = 0
        thirdPoint.alpha = 0
        
//        weatherService.loadWeatherData(city: "Moscow")

//       firstRequest()
//        let gradientLayer = CAGradientLayer()
//        gradientLayer.colors = [UIColor.white.cgColor, UIColor.blue.cgColor]
//        gradientLayer.locations = [0, 1]
//        gradientLayer.startPoint = CGPoint.zero
//        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
//        gradientLayer.frame = gradientView.bounds
//
//        gradientView.layer.addSublayer(gradientLayer)
//
//
       }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
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
                    URLQueryItem(name: "v", value: "5.68")
                ]
                
                let request = URLRequest(url: urlComponents.url!)
                
        webView.load(request)
    }
    
    @IBAction func switchFillLogun(_ sender: Any) {
        loginTextField.text = "admin"
        passwordTextField.text = "123456"
    }
   
    @IBAction func signOut(_ seg: UIStoryboardSegue){
        self.loginTextField.text = ""
        self.passwordTextField.text = ""
    
    }
    
    @IBAction func pressSignButton(_ sender: UIButton) {
        if self.loginTextField.text == "admin",
           self.passwordTextField.text == "123456" {
            
            UIView.animate(withDuration: 0.2,
                           delay: 0,
                           options: [.autoreverse],
                           animations: {[weak self] in
                            self?.firstPoint.alpha = 1
                           },
                           completion:{_ in
                            self.firstPoint.alpha = 0
                            UIView.animate(withDuration: 0.2,
                                           delay: 0,
                                           options: [.autoreverse],
                                           animations: {[weak self] in
                                            self?.secondPoint.alpha = 1
                                           },
                                           completion:{_ in
                                            self.secondPoint.alpha = 0
                                            UIView.animate(withDuration: 0.2,
                                                           delay: 0,
                                                           options: [.autoreverse],
                                                           animations: {[weak self] in
                                                            self?.thirdPoint.alpha = 1
                                                           },
                                                           completion:{_ in
                                                            self.thirdPoint.alpha = 0
                                                            UIView.animate(withDuration: 0.2,
                                                                           delay: 0,
                                                                           options: [.autoreverse],
                                                                           animations: {[weak self] in
                                                                            self?.firstPoint.alpha = 1
                                                                           },
                                                                           completion:{_ in
                                                                            self.firstPoint.alpha = 0
                                                                            UIView.animate(withDuration: 0.2,
                                                                                           delay: 0,
                                                                                           animations: {[weak self] in
                                                                                            self?.secondPoint.alpha = 0.5
                                                                                           },
                                                                                           completion:{_ in
                                                                                            self.secondPoint.alpha = 0
                                                                                            self.performSegue(withIdentifier: self.fromFirstPageToSecondSegue, sender: self)
                                      })
                                 })
                          })
                    })
           })
            
            

            
        } else {
            let alert = UIAlertController(title: "Error", message: "Entered wrong login or password", preferredStyle: .alert)

            let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)

            alert.addAction(action)

            present(alert, animated: true, completion: nil)
        }
    }
    
//    func firstRequest() {
//        // Конфигурация по умолчанию
//                let configuration = URLSessionConfiguration.default
//        // собственная сессия
//                let session =  URLSession(configuration: configuration)
//
//        // создаем url из строки
//                let url = URL(string: "http://samples.openweathermap.org/data/2.5/forecast?q=Moscow,DE&appid=b1b15e88fa797225412429c1c50c122a1")
//
//        // задача для запуска
//        let task = session.dataTask(with: url!) { (data, response, error) in
//        // в замыкании данные, полученные от сервера, мы преобразуем в json
//                    let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
//        // выводим в консоль
//                    print(json as Any)
//                }
//        // запускаем задачу
//                task.resume()
//    }
    
    // Конфигурация по умолчанию
//    func firstRequest() {
//            let configuration = URLSessionConfiguration.default
//
//            // собственная сессия
//            let session =  URLSession(configuration: configuration)
//
//            // создаем конструктор для url
//            var urlConstructor = URLComponents()
//            // устанавливаем схему
//            urlConstructor.scheme = "http"
//            // устанавливаем хост
//            urlConstructor.host = "jsonplaceholder.typicode.com"
//            // путь
//            urlConstructor.path = "/posts"
//            // параметры для запроса
//            urlConstructor.queryItems = [
//                URLQueryItem(name: "title", value: "foo"),
//                URLQueryItem(name: "body", value: "bar"),
//                URLQueryItem(name: "userId", value: "1")
//            ]
//
//            // создаем запрос
//            var request = URLRequest(url: urlConstructor.url!)
//            // указываем метод
//            request.httpMethod = "POST"
//
//            // задача для запуска
//            let task = session.dataTask(with: request) { (data, response, error) in
//            // в замыкании данные, полученные от сервера, мы преобразуем в json
//                let json = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments)
//            // выводим в консоль
//                print(json as Any)
//            }
//            // запускаем задачу
//            task.resume()
//    }

//    func firstRequest() {
//        AF.request("http://samples.openweathermap.org/data/2.5/forecast?q=Moscow,DE&appid=b1b15e88fa797225412429c1c50c122a1").responseJSON { response in
//
//                    print(response.value as Any)
//
//                }
//
//    }
}

extension LoginFormController: WKNavigationDelegate {
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
        
        guard let token = params["access_token"] else { return }
        
        performSegue(withIdentifier: fromFirstPageToSecondSegue, sender: Any?.self)
        DataStorage.shared.tokenVk = token

        print("TOKEN")
        print(token as Any)
        print("TOKEN")
        
        
        decisionHandler(.cancel)
    }
}
