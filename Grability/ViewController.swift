//
//  ViewController.swift
//  Grability
//
//  Created by Irfan Khatik on 2/24/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, myProtocol {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var selectedApp : AppDetail!
    
    private let detailSegueIdentifier = "detailSegue"
    
    private let transition = AnimateController()
    private var selectedImage : UIImageView?
    
    private let reuseIdentifier = "AppCell"
    
    private var appList : [AppDetail]?
    
    private let isIpad = Utils.runningDeviceIsIpad()
    private let screenSize:CGSize = Utils.screenSize()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //self.collectionView.registerClass(MyCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.navigationItem.title = "iTunes Store: Top Free Apps"
        
        self.appList = DatabaseManager.sharedInstance.fetchAppDetailsForCategory(CategoryType.None)
        self.collectionView.reloadData()
        
        let loadingView : LoadingOverlayView = LoadingOverlayView(superview: self.view)
        
        ServiceManager.sharedInstance.data_request(CategoryType.None) { (apps, error) -> Void in
            if apps != nil {
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
                        self.displayError(error!)
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
        
        flowLayout.itemSize = isIpad ? CGSizeMake(screenSize.width/4.2, (screenSize.width/4.5)+60) : CGSizeMake(screenSize.width/3.5, (screenSize.width/3.3)+37)
        
        flowLayout.invalidateLayout()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == detailSegueIdentifier {
            
            let detailViewController = segue.destinationViewController as! AppDetailViewController
            detailViewController.transitioningDelegate = self;
            detailViewController.selectedApp = selectedApp
        }
    }
    
    // MARK: Toggle Menu
    @IBAction func toggleMenu(){
        let container : ContainerViewController = self.navigationController!.parentViewController as! ContainerViewController
        container.menuShown ? container.hideMenu() : container.showMenu()
    }
    
    // MARK: Display Error
    private func displayError(error: NSError) {
        if #available(iOS 8, *){
            let alert = UIAlertController(title: "Grability",
                message: error.localizedDescription,
                preferredStyle: .Alert)
            
            let okAction = UIAlertAction(title: "Ok", style: .Cancel) { (alert: UIAlertAction) in
            }
            alert.addAction(okAction)
            
            presentViewController(alert, animated: true, completion: nil)
        } else {
            UIAlertView(title: "Grability", message: error.localizedDescription, delegate: nil, cancelButtonTitle: "Ok").show()
        }
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
        cell.label.font = isIpad ? Utils.myFont(CGFloat(20.0)) : Utils.myFont(CGFloat(16.0))
        
        guard let checkedUrl = NSURL(string: appDetail.appImage) else {
            return cell
        }
        
        cell.imageView?.downloadedFrom(link: checkedUrl, appId: appDetail.appId, categoryId: appDetail.appCategoryId, contentMode: .ScaleAspectFit)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        let container : ContainerViewController = self.navigationController!.parentViewController as! ContainerViewController
        if container.menuShown {
            container.hideMenu()
        }
        guard
            let appList = appList, appDetail = appList[indexPath.row] as? AppDetail else{
                return
        }
        selectedApp = appDetail
        selectedImage = (self.collectionView.cellForItemAtIndexPath(indexPath) as? MyCollectionViewCell)?.imageView
        self.performSegueWithIdentifier(detailSegueIdentifier, sender: self)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return isIpad ? CGSizeMake(screenSize.width/4.2, (screenSize.width/4.5)+60) : CGSizeMake(screenSize.width/3.5, (screenSize.width/3.3)+37)
    }
    
    // MARK: My Custom protocol
    func updateForCategory(category:CategoryType) {
        self.appList = DatabaseManager.sharedInstance.fetchAppDetailsForCategory(category)
        self.collectionView.reloadData()
                
        let loadingView : LoadingOverlayView = LoadingOverlayView(superview: self.view)
        ServiceManager.sharedInstance.data_request(category) { (apps, error) -> Void in
            if apps != nil {
                self.appList = apps
                dispatch_async(dispatch_get_main_queue())
                    { () -> Void in
                        self.collectionView.reloadData()
                        loadingView.removeLoadingOverlay()
                }
            } else {
                dispatch_async(dispatch_get_main_queue())
                    { () -> Void in
                        loadingView.removeLoadingOverlay()
                        self.displayError(error!)
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