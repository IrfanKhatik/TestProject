//
//  ServiceManager.swift
//  Grability
//
//  Created by Irfan Khatik on 2/24/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

import Foundation

public class ServiceManager: NSURLSession {
    
    private var session: NSURLSession?
    static let sharedInstance = ServiceManager()
    
    private override init(){
        // initializer code here
        session = NSURLSession.sharedSession()
    }
    
    func baseURL() -> String {
        return "https://itunes.apple.com/us/rss/topfreeapplications/limit=20/"
    }
    
    enum ParseError: ErrorType {
        case Empty
        case Short
        case Dirty
    }
    
    func data_request(genre: CategoryType, completion: (Array<AppDetail>?, NSError?) -> Void)
    {
        let genreVal:Int = evaluate(genre)
        
        //https://itunes.apple.com/us/rss/topfreeapplications/limit=10/xml
        
        var urlString:String? = self.baseURL()
        
        if genreVal > 0 {
            urlString! += "genre=\(genreVal)/json"
        } else {
            urlString! += "json"
        }
        
        let url:NSURL = NSURL(string: urlString!)!
        let session = NSURLSession.sharedSession()
        
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "GET"
        request.cachePolicy = NSURLRequestCachePolicy.ReloadIgnoringCacheData
        
        let task = session.dataTaskWithRequest(request) {
            (let data, let response, let error) in
                guard
                    let _:NSData = data,
                    let _:NSURLResponse = response  where error == nil else
                {
                    print("error : \(error?.localizedDescription)")
                    completion(nil,error)
                    return
                }
            
                do {
                    if data!.length == 0 {
                        throw ParseError.Empty
                    }
                    guard let json = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? [String:AnyObject] else{
                        throw ParseError.Dirty
                    }
                    guard let feed = json["feed"] as? [String:AnyObject] else
                    {
                        throw ParseError.Short
                    }
                    guard let entry:NSArray! = feed["entry"] as? NSArray else
                    {
                        throw ParseError.Short
                    }
                    
                    Parser.parseJsonListToAppDetailModelList(genre, responseList: entry!, withCompletion: { (appList, error) -> Void in
                        completion(appList, error)
                    })
                }
                catch let error as NSError
                {
                    print("json error: \(error.localizedDescription)")
                    completion(nil, error)
                }
        }
        
        task.resume()
        
    }
    
    func evaluate(category: CategoryType) -> Int {
        switch category {
        case .Books:
            return 6018
        case .Business:
            return 6000
        case .Catalogs:
            return 6022
        case .Education:
            return 6017
        case .Entertainment:
            return 6016
        case .Finance:
            return 6015
        case .FoodANDDrink:
            return 6023
        case .Games:
            return 6014
        case .HeathANDFitness:
            return 6013
        case .Lifestyle:
            return 6012
        case .Medical:
            return 6020
        case .Music:
            return 6011
        case .Navigation:
            return 6010
        case .News:
            return 6009
        case .Newsstand:
            return 6021
        case .PhotoANDVideo:
            return 6008
        case .Productivity:
            return 6007
        case .Reference:
            return 6006
        case .Shopping:
            return 6024
        case .Social_Networking:
            return 6005
        case .Sports:
            return 6004
        case .Travel:
            return 6003
        case .Utilities:
            return 6002
        case .Weather:
            return 6001
        default :
            return 0
        }
    }
}
