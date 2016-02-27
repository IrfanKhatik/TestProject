//
//  AppDetailViewController.swift
//  Grability
//
//  Created by Irfan Khatik on 2/26/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

import UIKit
import Social

class AppDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var selectedApp: AppDetail!
    
    @IBOutlet private weak var tblAppDetail: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.collectionView.registerClass(MyCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.title = selectedApp.appName
        tblAppDetail.estimatedRowHeight = CGFloat(44.0)
        tblAppDetail.rowHeight = UITableViewAutomaticDimension
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        tblAppDetail.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
    }
    
    func goBack(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction private func showAppMenu(sender:UIButton) {
        
        let actionSheetController = UIAlertController(title: selectedApp.appName, message: "What do you want to do?", preferredStyle: .ActionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            //Just dismiss the action sheet
        }
        actionSheetController.addAction(cancelAction)
        
        //Create and add a first option action
        let copyLinkAction: UIAlertAction = UIAlertAction(title: "Copy Link", style: .Default) { action -> Void in
            //Code for copy link goes here
            guard let checkedUrl = NSURL(string: self.selectedApp.appLink) else {
                return
            }
            UIPasteboard.generalPasteboard().URL = checkedUrl
        }
        
        actionSheetController.addAction(copyLinkAction)
        
        //Create and add second option action
        let twitterAction: UIAlertAction = UIAlertAction(title: "Share on Twitter", style: .Default) { action -> Void in
            //Code for twitter share goes here
            let vc = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            vc.setInitialText("Look at this App!")
            vc.addURL(NSURL(string: self.selectedApp.appLink))
            self.presentViewController(vc, animated: true, completion: nil)
        }
        actionSheetController.addAction(twitterAction)
        
        //Create and add a third option action
        let facebookAction: UIAlertAction = UIAlertAction(title: "Share on Facebook", style: .Default) { action -> Void in
            //Code for facebook share goes here
            let vc = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            vc.setInitialText("Look at this App!")
            vc.addURL(NSURL(string: self.selectedApp.appLink))
            self.presentViewController(vc, animated: true, completion: nil)
        }
        actionSheetController.addAction(facebookAction)
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
    }
    
    // MARK: TableView Protocols
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(70.0)
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let screenSize:CGSize = Utils.screenSize()
        
        let headerView = UIView(frame:CGRectMake(0, 0, screenSize.width, CGFloat(70.0)))
        headerView.backgroundColor = UIColor.greenValidationColor()
        
        let backButton = UIButton(type:UIButtonType.Custom)
        backButton.frame = CGRectMake(10, 25, 40, 40)
        backButton.addTarget(self, action: "goBack", forControlEvents: UIControlEvents.TouchUpInside)
        backButton.setImage(UIImage(named: "Close"), forState: UIControlState.Normal)
        headerView.addSubview(backButton)
        
        let lblTitle = UILabel(frame: CGRectMake(70, 25,screenSize.width-140, 40))
        lblTitle.text = selectedApp.appName
        lblTitle.textColor = UIColor.whiteColor()
        lblTitle.numberOfLines = 0
        lblTitle.textAlignment = NSTextAlignment.Center
        lblTitle.lineBreakMode = NSLineBreakMode.ByWordWrapping
        lblTitle.font = Utils.myFont(CGFloat(18.0))
        headerView.addSubview(lblTitle)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, estimatedHeightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.row{
        case 0:
            return CGFloat(150.0)
        default:
            return CGFloat(44.0)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        switch indexPath.row{
        case 0:
            return imageCell()
        case 1:
            let cell = defaultCell()
            cell.textLabel?.text = selectedApp.appSummary
            return cell
        case 2:
            let cell = titleCell()
            cell.textLabel?.text = selectedApp.appArtist
            cell.detailTextLabel?.text = "Developer"
            return cell
        case 3:
            let cell = titleCell()
            var categoryName = selectedApp.appCategory.rawValue
            categoryName = categoryName.stringByReplacingOccurrencesOfString("AND", withString: " & ")
            categoryName = categoryName.stringByReplacingOccurrencesOfString("_", withString: " ")
            cell.textLabel?.text = "\(categoryName)"
            cell.detailTextLabel?.text = "Category"
            return cell
        case 4:
            let cell = titleCell()
            cell.textLabel?.text = selectedApp.appRights
            cell.detailTextLabel?.text = "Rights"
            return cell
        case 5:
            let cell = titleCell()
            cell.textLabel?.text = selectedApp.appReleaseDate
            cell.detailTextLabel?.text = "Release date"
            return cell
        default:
            let cell = defaultCell()
            return cell
        }
    }
    
    private func imageCell() -> DetailImageCell {
        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
        let cell : DetailImageCell = self.tblAppDetail.dequeueReusableCellWithIdentifier("detailCell", forIndexPath: indexPath) as! DetailImageCell
        guard let checkedUrl = NSURL(string: selectedApp.appImage) else {
            cell.appIcon.image = UIImage(named: "TempImage")
            return cell
        }
        
        cell.appIcon.downloadedFrom(link: checkedUrl, appId: selectedApp.appId, categoryId: selectedApp.appCategoryId, contentMode: .ScaleAspectFit)
        
        return cell
    }
    
    private func defaultCell() -> UITableViewCell {
        let cell : UITableViewCell = self.tblAppDetail.dequeueReusableCellWithIdentifier("normalCell")!
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        cell.textLabel?.font = Utils.myFont(15)
        
        return cell
    }
    
    private func titleCell() -> UITableViewCell {
        let cell : UITableViewCell = self.tblAppDetail.dequeueReusableCellWithIdentifier("TitleCell")!
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        return cell
    }
}

