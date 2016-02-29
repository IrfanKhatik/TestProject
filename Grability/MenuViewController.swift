//
//  MenuViewController.swift
//  Grability
//
//  Created by Irfan Khatik on 2/29/16.
//  Copyright © 2016 BestSoft. All rights reserved.
//

import UIKit

protocol myProtocol {
    func updateForCategory(category:CategoryType) // this function the first controllers
}

class MenuViewController: UIViewController {
    @IBOutlet private weak var tblCategory: UITableView!
    
    var delegate: myProtocol?
    private let isIpad = Utils.runningDeviceIsIpad()
    
    private var categories: [CategoryType]? = [.Books, .Business, .Catalogs,
        .Education, .Entertainment, .Finance,
        .FoodANDDrink, .Games, .HeathANDFitness,
        .Lifestyle, .Medical, .Music,
        .Navigation, .News, .Newsstand,
        .PhotoANDVideo, .Productivity, .Reference,
        .Shopping, .Social_Networking, .Sports,
        .Travel, .Utilities, .Weather]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tblCategory.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: Table protocols
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let categories = categories {
            return categories.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as UITableViewCell
        
        guard let categories = categories, category = categories[indexPath.row] as? CategoryType else {
            return cell;
        }
        
        var categoryName = category.rawValue
        categoryName = categoryName.stringByReplacingOccurrencesOfString("AND", withString: " & ")
        categoryName = categoryName.stringByReplacingOccurrencesOfString("_", withString: " ")
        cell.textLabel!.text = "\(categoryName)"
        cell.textLabel!.font = isIpad ? Utils.myFont(CGFloat(20.0)) : Utils.myFont(CGFloat(16.0))
        cell.textLabel!.textColor = UIColor.greenValidationColor()
        cell.backgroundColor = UIColor.whiteColor()
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return isIpad ? CGFloat(60.0) : CGFloat(45.0)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedType = categories![indexPath.row]
        let container : ContainerViewController = self.parentViewController as! ContainerViewController
        container.hideMenu()
        if self.delegate != nil {
            self.delegate!.updateForCategory(selectedType)
        }
    }
}
