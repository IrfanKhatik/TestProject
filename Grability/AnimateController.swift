//
//  AnimateController.swift
//  Grability
//
//  Created by Irfan Khatik on 2/26/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//


import UIKit

class AnimateController: NSObject, UIViewControllerAnimatedTransitioning {
    
    let duration    = 0.4
    var originFrame = CGRectZero
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning?)-> NSTimeInterval {
        return duration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView()!
        
        let toView = transitionContext.viewForKey(UITransitionContextToViewKey)!
        
        let herbView = toView
        
        let initialFrame = originFrame
        let finalFrame = herbView.frame
        
        let xScaleFactor = initialFrame.width / finalFrame.width
        
        let yScaleFactor = initialFrame.height / finalFrame.height
        
        let scaleTransform = CGAffineTransformMakeScale(xScaleFactor, yScaleFactor)
        
       
        herbView.transform = scaleTransform
        herbView.center = CGPoint(x: CGRectGetMidX(initialFrame), y: CGRectGetMidY(initialFrame))
        herbView.clipsToBounds = true
    
        
        containerView.addSubview(toView)
        containerView.bringSubviewToFront(herbView)
        
        UIView.animateWithDuration(duration, animations: { () -> Void in
            herbView.transform = CGAffineTransformIdentity
            
            herbView.center = CGPoint(x: CGRectGetMidX(finalFrame), y: CGRectGetMidY(finalFrame))
            }, completion: {(finished: Bool) -> Void in
            transitionContext.completeTransition(true)})
        
        let round = CABasicAnimation(keyPath: "cornerRadius")
        round.fromValue = 25.0/xScaleFactor
        round.toValue =  0.0
        round.duration = duration / 2
        herbView.layer.addAnimation(round, forKey: nil)
        herbView.layer.cornerRadius = 0.0
        
    }
}
