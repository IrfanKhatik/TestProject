//
//  Parser.swift
//  Grability
//
//  Created by Irfan Khatik on 2/25/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

import Foundation

class Parser: NSObject {
    class func parseJsonListToAppDetailModelList(appCategory: CategoryType, responseList: NSArray, withCompletion: (Array<AppDetail>?) -> Void){
        var resultArray : [AppDetail] = [AppDetail]()
        
        for appDict in responseList{
            
            let appDetail = AppDetail()
            
            if let title = ((appDict as? [String:AnyObject])?["im:name"] as? [String:AnyObject])?["label"] as? String {
                appDetail.appName = title
            }
            
            if let image = (((appDict as? [String:AnyObject])?["im:image"] as? NSArray)![2] as? NSDictionary)?["label"] as? String {
                appDetail.appImage = image
            }
            
            if let summary = ((appDict as? [String:AnyObject])?["summary"] as? [String:AnyObject])?["label"] as? String {
                appDetail.appSummary = summary
            }
            
            if let rights = ((appDict as? [String:AnyObject])?["rights"] as? [String:AnyObject])?["label"] as? String {
                appDetail.appRights = rights
            }
            
            if let link = (((appDict as? [String:AnyObject])?["link"] as? [String:AnyObject])?["attributes"] as? NSDictionary)?["href"] as? String {
                appDetail.appLink = link
            }
            
            if let artist = ((appDict as? [String:AnyObject])?["im:artist"] as? [String:AnyObject])?["label"] as? String {
                appDetail.appArtist = artist
            }
            
            if let artistLink = (((appDict as? [String:AnyObject])?["im:artist"] as? [String:AnyObject])?["attributes"] as? NSDictionary)?["href"] as? String {
                appDetail.appArtistURL = artistLink
            }
            
            
            if let categoryID = (((appDict as? [String:AnyObject])?["category"] as? [String:AnyObject])?["attributes"] as? NSDictionary)?["im:id"] as? String {
                appDetail.appCategoryId = categoryID
            }
            
            
            if let releaseDate = (((appDict as? [String:AnyObject])?["im:releaseDate"] as? [String:AnyObject])?["attributes"] as? NSDictionary)?["label"] as? String {
                appDetail.appReleaseDate = releaseDate
            }
            
            appDetail.appCategory = appCategory
            
            if let appID = (((appDict as? [String:AnyObject])?["id"] as? [String:AnyObject])?["attributes"] as? NSDictionary)?["im:id"] as? String {
                appDetail.appId = appID
                resultArray.append(appDetail)
            }
        }
        
        DatabaseManager.sharedInstance.saveAppDetails(resultArray, forCategory: appCategory)
        
        resultArray.sortInPlace { (element1, element2) -> Bool in
            return element1.appId < element2.appId
        }
        
        withCompletion(resultArray)
    }
}
