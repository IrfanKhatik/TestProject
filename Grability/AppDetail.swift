//
//  AppDetail.swift
//  Grability
//
//  Created by Irfan Khatik on 2/24/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

import UIKit

public class AppDetail: NSObject {
    
    var appName: String
    var appImage: String
    var appSummary: String
    var appRights: String
    var appLink: String
    var appId: String
    var appArtist: String
    var appArtistURL: String
    var appCategoryId: String
    var appReleaseDate: String
    var appCategory : CategoryType
    
    init(appName: String?, appImage: String?, appSummary: String?, appRights: String?, appLink: String?, appId: String?, appArtist: String?, appArtistURL: String?, appCategoryId: String?, appReleaseDate: String?, appCategory: CategoryType?)
    {
        self.appName = appName!
        self.appImage = appImage!
        self.appSummary = appSummary!
        self.appRights = appRights!
        self.appLink = appLink!
        self.appId = appId!
        self.appArtist = appArtist!
        self.appArtistURL = appArtistURL!
        self.appCategoryId = appCategoryId!
        self.appReleaseDate = appReleaseDate!
        self.appCategory = appCategory!
    }
    
    convenience override init() {
        self.init(appName: "", appImage: "", appSummary: "", appRights: "", appLink: "", appId: "", appArtist: "", appArtistURL: "", appCategoryId: "", appReleaseDate: "", appCategory: CategoryType.None)
    }
}
