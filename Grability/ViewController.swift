//
//  ViewController.swift
//  Grability
//
//  Created by Irfan Khatik on 2/24/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, myProtocol {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    private var popoverViewController: PopoverViewController?
    private var detailViewController: AppDetailViewController?
    
    private var selectedApp : AppDetail!
    
    private let popoverSegueIdentifier = "popoverSegue"
    private let detailSegueIdentifier = "detailSegue"
    
    private let transition = AnimateController()
    private var selectedImage : UIImageView?
    
    private let reuseIdentifier = "AppCell"
    
    private var appList : [AppDetail]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.collectionView.registerClass(MyCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.navigationItem.title = "iTunes Store: Top Free Apps"
        let loadingView : LoadingOverlayView = LoadingOverlayView(superview: self.view)
        
        ServiceManager.sharedInstance.data_request(CategoryType.None) { (apps, error) -> Void in
            if apps != nil {
                print("Success : \(apps!.count)")
                self.appList = apps
                dispatch_async(dispatch_get_main_queue())
                    { () -> Void in
                        self.collectionView.reloadData()
                        loadingView.removeLoadingOverlay()
                }
            } else {
                print("Failure : \(error!)")
                self.appList = DatabaseManager.sharedInstance.fetchAppDetailsForCategory(CategoryType.None)
                dispatch_async(dispatch_get_main_queue())
                    { () -> Void in
                        self.collectionView.reloadData()
                        loadingView.removeLoadingOverlay()
                }
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        selectedImage = nil
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
            return
        }
        
        let screenSize:CGSize = Utils.screenSize()
        
        switch UIDevice.currentDevice().userInterfaceIdiom{
        case .Pad:
            flowLayout.itemSize = CGSizeMake(screenSize.width/4.2, (screenSize.width/4.5)+60)
        case .Phone:
            flowLayout.itemSize = CGSizeMake(screenSize.width/3.5, (screenSize.width/3.3)+37)
        default:
            flowLayout.itemSize = CGSizeMake(screenSize.width/3.5, (screenSize.width/3.3)+37)
        }
        
        flowLayout.invalidateLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == popoverSegueIdentifier {
            popoverViewController = (segue.destinationViewController as! PopoverViewController)
            popoverViewController!.modalPresentationStyle = UIModalPresentationStyle.Popover
            popoverViewController!.popoverPresentationController!.delegate = self
            popoverViewController!.delegate = self
        }
        
        if segue.identifier == detailSegueIdentifier {
            detailViewController = (segue.destinationViewController as! AppDetailViewController)
            detailViewController?.transitioningDelegate = self;
            detailViewController!.selectedApp = selectedApp
        }
    }
    
    func rotated()
    {
        let screenSize:CGSize = Utils.screenSize()
        print("ScreenSize: \(screenSize)")
        self.view.frame = CGRectMake(0, 0, screenSize.width, screenSize.height)
    }
    
    // MARK: Popover presentation protocol
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.None
    }
    
    // MARK: CollectionView protocols
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let appList = appList {
            return appList.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = self.collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MyCollectionViewCell
        
        guard
            let appList = appList, appDetail = appList[indexPath.row] as? AppDetail else{
                cell.imageView.image = UIImage(named: "TempImage")
            return cell
        }
        
        cell.label?.text = appDetail.appName
        
        guard let checkedUrl = NSURL(string: appDetail.appImage) else {
            return cell
        }
        
        cell.imageView?.downloadedFrom(link: checkedUrl, appId: appDetail.appId, categoryId: appDetail.appCategoryId, contentMode: .ScaleAspectFit)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        guard
            let appList = appList, appDetail = appList[indexPath.row] as? AppDetail else{
                return
        }
        selectedApp = appDetail
        selectedImage = (self.collectionView.cellForItemAtIndexPath(indexPath) as? MyCollectionViewCell)?.imageView
        self.performSegueWithIdentifier(detailSegueIdentifier, sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let screenSize:CGSize = Utils.screenSize()
        
        switch UIDevice.currentDevice().userInterfaceIdiom{
        case .Pad:
                return CGSizeMake(screenSize.width/4.2, (screenSize.width/4.5)+60)
        case .Phone:
                return CGSizeMake(screenSize.width/3.5, (screenSize.width/3.3)+37)
        default:
            return CGSizeMake(screenSize.width/3.5, (screenSize.width/3.3)+37)
        }
    }
    
    // MARK: My Custom protocol
    func updateForCategory(category:CategoryType) {
        print("Hello delegate: \(category)")
        let loadingView : LoadingOverlayView = LoadingOverlayView(superview: self.view)
        ServiceManager.sharedInstance.data_request(category) { (apps, error) -> Void in
            if apps != nil {
                print("Success : \(apps!.count)")
                self.appList = apps
                dispatch_async(dispatch_get_main_queue())
                    { () -> Void in
                        self.collectionView.reloadData()
                        loadingView.removeLoadingOverlay()
                }
            } else {
                print("Failure : \(error!)")
                dispatch_async(dispatch_get_main_queue())
                    { () -> Void in
                        loadingView.removeLoadingOverlay()
                }
            }
        }
    }
}

// MARK: UIViewController Transitioning Delegate

extension ViewController: UIViewControllerTransitioningDelegate {
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        transition.originFrame = selectedImage!.superview!.convertRect(selectedImage!.frame, toView: nil)
        
        return transition
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        return nil
    }
}