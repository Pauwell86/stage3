//
//  PopAnimation.swift
//  VK
//
//  Created by Pauwell on 07.05.2021.
//

import UIKit

class PopAnimation: NSObject {

}

extension PopAnimation: UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.6
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        guard let sourceViewController = transitionContext.viewController(forKey: .from),
              let destinationViewController = transitionContext.viewController(forKey: .to) else {return}
        
        // let containerViewFrame = transitionContext.containerView.frame
        
        transitionContext.containerView.addSubview(destinationViewController.view)
        transitionContext.containerView.sendSubviewToBack(destinationViewController.view)
        destinationViewController.view.frame = sourceViewController.view.frame
        
        let traslation = CGAffineTransform(translationX: -200, y: 0)
        let scale = CGAffineTransform(scaleX: 0.8, y: 0.8)
        destinationViewController.view.transform = traslation.concatenating(scale)
        
        UIView.animateKeyframes(withDuration: self.transitionDuration(using: transitionContext),
                                delay: 0,
                                options: .calculationModeCubicPaced,
                                animations: {
                                    UIView.addKeyframe(withRelativeStartTime: 0,
                                                       relativeDuration: 0.5,
                                                       animations: {
                                                            sourceViewController.view.frame = CGRect(x: sourceViewController.view.frame.width, y: 0, width: sourceViewController.view.frame.width, height: sourceViewController.view.frame.height)
                                                       })
                                    
                                    UIView.addKeyframe(withRelativeStartTime: 0.25,
                                                       relativeDuration: 0.0,
                                                       animations: {                                     
                                                        destinationViewController.view.transform = .identity
                                                       })
                                },
                                completion: {finished in
                                    let tempFlag = finished && (!transitionContext.transitionWasCancelled)
                                    if tempFlag {
                                        sourceViewController.removeFromParent()
                                    }
                                    transitionContext.completeTransition(tempFlag)
                                })
    }
}
