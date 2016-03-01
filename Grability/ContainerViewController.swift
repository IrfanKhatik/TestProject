//
//  ContainerViewController.swift
//  Grability
//
//  Created by Irfan Khatik on 2/29/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

import UIKit

class ContainerViewController: UIViewController {
    
    private let isIpad = Utils.runningDeviceIsIpad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let storyboard = self.storyboard!
        
        let mainNavigationController: UINavigationController = storyboard.instantiateViewControllerWithIdentifier("MainNavigationController") as! UINavigationController
        
        let menuViewController: MenuViewController = storyboard.instantiateViewControllerWithIdentifier("MenuViewController")as! MenuViewController
        
        let mainVC : ViewController = mainNavigationController.viewControllers[0] as! ViewController
        menuViewController.delegate = mainVC
        
        self.leftViewController = menuViewController
        self.mainViewController = mainNavigationController
        
    }
    
    var leftViewController: UIViewController? {
        willSet{
            if self.leftViewController != nil {
                if self.leftViewController!.view != nil {
                    self.leftViewController!.view!.removeFromSuperview()
                }
                self.leftViewController!.removeFromParentViewController()
            }
        }
        
        didSet{
            
            self.view!.addSubview(self.leftViewController!.view)
            self.addChildViewController(self.leftViewController!)
        }
    }
    
    var mainViewController: UIViewController? {
        willSet {
            if self.mainViewController != nil {
                if self.mainViewController!.view != nil {
                    self.mainViewController!.view!.removeFromSuperview()
                }
                self.mainViewController!.removeFromParentViewController()
            }
        }
        
        didSet{
            self.view!.addSubview(self.mainViewController!.view)
            self.addChildViewController(self.mainViewController!)
        }
    }
    
    var menuShown: Bool = false
    
    @IBAction func swipeRight(sender: UISwipeGestureRecognizer) {
        showMenu()
        
    }
    
    @IBAction func swipeLeft(sender: UISwipeGestureRecognizer) {
        hideMenu()
    }
    
    func showMenu() {
        
        let width: CGFloat = isIpad ? CGFloat(300) : CGFloat(235)
        UIView.animateWithDuration(0.3, animations: {
            self.mainViewController!.view.frame = CGRect(x: self.view.frame.origin.x + width, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
            }, completion: { (Bool) -> Void in
                self.menuShown = true
        })
    }
    
    func hideMenu() {
        UIView.animateWithDuration(0.3, animations: {
            self.mainViewController!.view.frame = CGRect(x: 0, y: self.view.frame.origin.y, width: self.view.frame.width, height: self.view.frame.height)
            }, completion: { (Bool) -> Void in
                self.menuShown = false
        })
    }
}
