//
//  Utils.swift
//  Grability
//
//  Created by Irfan Khatik on 2/26/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

import UIKit

class Utils {
    class func screenSize() -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    class func myFont(size : CGFloat ) -> UIFont? {
        return UIFont(name:"Chalkboard SE", size:size)
    }
    
    class func runningDeviceIsIpad() -> Bool {
        switch UIDevice.currentDevice().userInterfaceIdiom{
        case .Pad:
            return true
        default:
            return false
        }
    }
}