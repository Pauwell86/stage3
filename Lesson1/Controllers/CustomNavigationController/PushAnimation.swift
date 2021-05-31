//
//  PushAnimation.swift
//  VK
//
//  Created by Pauwell on 06.05.2021.
//

import UIKit

class PushAnimation: NSObject {

}

extension PushAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let sourceViewController = transitionContext.viewController(forKey: .from),
              let destinationViewController = transitionContext.viewController(forKey: .to) else {return}
        
        // let containerViewFrame = transitionContext.containerView.frame
        
        transitionContext.containerView.addSubview(destinationViewController.view)
 //     destinationViewController.view.frame = sourceViewController.view.frame
        destinationViewController.view.frame = CGRect(x: destinationViewController.view.frame.width, y: 50, width: destinationViewController.view.frame.width, height: destinationViewController.view.frame.height)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModeCubicPaced,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.6,
                                                       animations: {
                                                        let translation = CGAffineTransform(translationX: -200, y: 50)
                                                        let scale = CGAffineTransform(scaleX: 1, y: 1)
                                                        sourceViewController.view.transform = translation.concatenating(scale)
                                                       })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.2,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                        let translation = CGAffineTransform(translationX: sourceViewController.view.frame.width, y: 0)
                                                        let scale = CGAffineTransform(scaleX: 1, y: 1)
                                                        destinationViewController.view.transform = translation.concatenating(scale)
                                                       })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.6,
                                                       relativeDuration: 0.4,
                                                       animations: {
                                                            destinationViewController.view.frame = CGRect(x: 0, y: 0, width: destinationViewController.view.frame.width, height: destinationViewController.view.frame.height)
                                                        
                                                       })
                                },
                                completion: {finished in
                                    let tempFlag = finished && (!transitionContext.transitionWasCancelled)
                                    if tempFlag {
                                        sourceViewController.view.transform = .identity
                                    }
                                    transitionContext.completeTransition(tempFlag)
                                })
        
        
        
//        destinationViewController.view.frame.origin.x += 50
//        destinationViewController.view.frame.origin.y += 100
//
//  //      destinationViewController.view.transform = destinationViewController.view.transform.rotated(by: -.pi / 2)
//
//
//
//
//        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
//                       animations: {
//                        sourceViewController.view.frame = CGRect(x: -containerViewFrame.width, y: 100, width: containerViewFrame.width, height: containerViewFrame.height)
//                       },
//                       completion: nil)
//
//        UIView.animate(withDuration: self.transitionDuration(using: transitionContext),
//                       animations: {
//                            destinationViewController.view.frame = CGRect(x: 0,
//                                                                      y: 0,
//                                                                      width: containerViewFrame.width,
//                                                                      height: containerViewFrame.height)
//                                    },
//                       completion: {secondFinished in
//                                        transitionContext.completeTransition(secondFinished)
//                                    })
//    }
    }
}
