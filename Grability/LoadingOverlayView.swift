//
//  LoadingOverlayView.swift
//  Grability
//
//  Created by Irfan KHatik on 2/26/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

import UIKit

public class LoadingOverlayView: UIView {
    convenience init(superview: UIView) {
        self.init()
        translatesAutoresizingMaskIntoConstraints = false
        
        setupLoadingOverlay()
        
        superview.addSubview(self)
        
        let views = ["overlay": self]
        superview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[overlay]|", options: [], metrics: nil, views: views))
        superview.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[overlay]|", options: [], metrics: nil, views: views))
        
        alpha = 0
        UIView.animateWithDuration(0.3) {
            self.alpha = 1
        }
    }
    
    func removeLoadingOverlay() {
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.alpha = 0
            }) { (finished) -> Void in
                self.removeFromSuperview()
        }
    }
    
    private func setupLoadingOverlay() {
        backgroundColor = UIColor(white: 0, alpha: 0.7)
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(indicator)
        
        addConstraint(NSLayoutConstraint(item: indicator, attribute: .CenterX, relatedBy: .Equal, toItem: self, attribute: .CenterX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: indicator, attribute: .CenterY, relatedBy: .Equal, toItem: self, attribute: .CenterY, multiplier: 1, constant: 0))
        
        indicator.startAnimating()
    }
}
