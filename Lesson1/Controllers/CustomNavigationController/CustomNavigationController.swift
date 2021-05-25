//
//  ViewController.swift
//  VK
//
//  Created by Pauwell on 10.05.2021.
//

import UIKit

class CustomNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        delegate = self
        
    }
    
    let interactiveTransition = InteractiveTransitionClass()

}


 extension CustomNavigationController: UINavigationControllerDelegate {

    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationController.Operation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {

        if operation == .push {
            self.interactiveTransition.viewController = toVC
            return PushAnimation()
        }
        else if operation == .pop {
            if navigationController.viewControllers.first != toVC {
                self.interactiveTransition.viewController = toVC
            }
            return PopAnimation()
        }
        return nil
    }

    func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {

        return interactiveTransition.isStarted ? interactiveTransition : nil

    }

}
