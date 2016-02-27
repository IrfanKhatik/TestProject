//
//  Image_UrlLoading.swift
//  Grability
//
//  Created by Irfan Khatik on 2/26/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadedFrom(link url:NSURL, appId appID:String, categoryId categoryID:String, contentMode mode: UIViewContentMode) {
        contentMode = mode
        let format = ".png"
        
        let tmpPath = NSTemporaryDirectory() + categoryID + appID + format
        print("filePath: \(tmpPath)")
        
        let fileManager = NSFileManager.defaultManager()
        if fileManager.fileExistsAtPath(tmpPath)
        {
            self.image = UIImage(contentsOfFile: tmpPath)
            self.layer.cornerRadius = CGFloat(24.0)
            self.layer.borderWidth = CGFloat(0.3)
            self.layer.borderColor = UIColor.lightGrayColor().CGColor
            self.layer.masksToBounds = true
            return
        }
        
        NSURLSession.sharedSession().dataTaskWithURL(url, completionHandler: { (data, response, error) -> Void in
            guard
                let httpURLResponse = response as? NSHTTPURLResponse where httpURLResponse.statusCode == 200,
                let mimeType = response?.MIMEType where mimeType.hasPrefix("image"),
                let data = data where error == nil,
                let image = UIImage(data: data)
                else {
                    dispatch_async(dispatch_get_main_queue())
                        { () -> Void in
                            self.image = UIImage.init(named: "TempImage")
                    }
                    return }
            dispatch_async(dispatch_get_main_queue()) { () -> Void in
                data.writeToFile(tmpPath, atomically: true)
                self.image = image
                self.layer.cornerRadius = CGFloat(24.0)
                self.layer.borderWidth = CGFloat(0.3)
                self.layer.borderColor = UIColor.lightGrayColor().CGColor
                self.layer.masksToBounds = true
            }
        }).resume()
    }
}