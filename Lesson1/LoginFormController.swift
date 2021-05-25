//
//  LoginFormController.swift
//  VK
//
//  Created by Pauwell on 06.04.2021.
//

import UIKit

class LoginFormController: UIViewController {

   
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var gradientView: UIView!
        
    @IBOutlet weak var firstPoint: UIView!
    @IBOutlet weak var secondPoint: UIView!
    @IBOutlet weak var thirdPoint: UIView!
    
    let fromFirstPageToSecondSegue = "fromFirstPageToSecondSegue"
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        firstPoint.layer.cornerRadius = 5
        secondPoint.layer.cornerRadius = 5
        thirdPoint.layer.cornerRadius = 5
        firstPoint.alpha = 0
        secondPoint.alpha = 0
        thirdPoint.alpha = 0
        
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
    }

