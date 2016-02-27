//
//  Utils.swift
//  Grability
//
//  Created by Irfan Khatik on 2/26/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

import UIKit

class Utils {
    static func screenSize() -> CGSize {
        return UIScreen.mainScreen().bounds.size
    }
    
    static func myFont(size : CGFloat ) -> UIFont? {
        return UIFont(name:"Chalkboard SE", size:size)
    }
}