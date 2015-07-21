//
//  MyCouponViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/26.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class myCouponViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate{
    var couponCodeList:NSMutableArray = NSMutableArray()
    var faceValueList:NSMutableArray = NSMutableArray()
    var thresholdList:NSMutableArray = NSMutableArray()
    var expireList:NSMutableArray = NSMutableArray()
    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor()], forState: UIControlState.Selected)
        tabBar.barTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        Home.image = UIImage(named: "home.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        Home.selectedImage = UIImage(named: "home-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        Account.image = UIImage(named: "account.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        Account.selectedImage = UIImage(named: "account-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        More.image = UIImage(named: "more.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        More.selectedImage = UIImage(named: "more-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
        if(!IJReachability.isConnectedToNetwork()){
            var addView:UIAlertController = UIAlertController(title: "", message: "请检查网络状态", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                self.viewDidLoad()
            }
            addView.addAction(actionOK)
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(addView, animated: true, completion: nil)
            }
            return
        }
        
        let home = NSHomeDirectory() as NSString;
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
        let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
        //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
        var apiValue: AnyObject? = settingPlist?.valueForKey("API")
        var api = apiValue as! String
        var url:NSURL = NSURL(string: "\(api)/account/MyCoupons")!
        var requrst:NSURLRequest?
        var conn:NSURLConnection?
        requrst=NSURLRequest(URL:url)
        conn=NSURLConnection(request: requrst!,delegate: self)
      
        var data = NSData(contentsOfURL: url)
        var str = NSString(data: data!, encoding: NSUTF8StringEncoding)
        let json = JSON(data: data!)
        println("\(json)")
        
        count = json.count
        println("\(count)")
        
        for(var i = 0; i < count; i++){
            couponCodeList.addObject(json[i]["couponCode"].string!)
            faceValueList.addObject(json[i]["faceValue"].float!)
            thresholdList.addObject(json[i]["thresholdValue"].float!)
            expireList.addObject(json[i]["expireTime"].string!)
        }
        var tableHeight = count > 0 ? CGFloat(count * 100 - 5) : 0
        couponTable = UITableView()
        couponTable.delegate = self
        couponTable.dataSource = self
        couponTable.frame = CGRect(x: 10, y: 70, width: UIScreen.mainScreen().applicationFrame.width - 20, height: tableHeight)
        couponTable.bounces = false
        couponTable.separatorStyle = UITableViewCellSeparatorStyle.None
        
        ruleTitle = UILabel()
        ruleTitle.frame = CGRect(x: 10, y: 70+tableHeight, width: 110, height: 30)
        ruleTitle.text = "红包使用规则"
        ruleImage = UIImageView()
        ruleImage.frame = CGRect(x: 10, y: 98+tableHeight, width: 110, height: 2)
        ruleImage.image = UIImage(named: "page-selected.png")
        ruleText = UITextView()
        ruleText.frame = CGRect(x: 10, y: 100+tableHeight, width: UIScreen.mainScreen().applicationFrame.width - 20, height: 150)
        ruleText.text = "1. 红包可在投资中使用。 举例说明：您如果想投资1万元，这时您只需要充值9950元到第三方支付账户中，就可以给这个标投资1万元了。等项目期满结束后，您可以连本带息把红包一起提现。\n2. 根据专投网平台相关规定，专投网的红包是不可以直接提现的，红包只能用于直接投资，不能用于购买债权，不能兑现、提现或转让。"
        ruleText.backgroundColor = UIColor.clearColor()
        

        self.view.addSubview(couponTable)
        self.view.addSubview(ruleTitle)
        self.view.addSubview(ruleImage)
        self.view.addSubview(ruleText)

    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return count
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection: Int) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 4
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 90
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = couponCell(reuseIdentifier:"couponCell")
        cell.addCouponID(couponCodeList[indexPath.section] as! String)
        cell.addFaceValue(faceValueList[indexPath.section] as! Float)
        cell.addthreshold(thresholdList[indexPath.section] as! Float)
        cell.addExpire(expireList[indexPath.section] as! String)
        return cell
        
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if tabBar.selectedItem == Home {
            performSegueWithIdentifier("CouponToHome", sender: AnyObject?())
        }
        else if tabBar.selectedItem == Account{
            performSegueWithIdentifier("CouponToAccount", sender: AnyObject?())
        }
        else if tabBar.selectedItem == More{
            performSegueWithIdentifier("CouponToMore", sender: AnyObject?())
        }
    }
    
    @IBOutlet var couponTable: UITableView!
    @IBOutlet var ruleText: UITextView!
    @IBOutlet var ruleTitle: UILabel!
    @IBOutlet var ruleImage: UIImageView!
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var Home: UITabBarItem!
    @IBOutlet var Account: UITabBarItem!
    @IBOutlet var More: UITabBarItem!

    
}