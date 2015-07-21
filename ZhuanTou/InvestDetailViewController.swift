//
//  InvestHistoryViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/21.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class InvestDetailViewController: UIViewController, UITableViewDelegate, UITabBarControllerDelegate{
    
    var productCode:String = String()
    var createOnList:NSMutableArray = NSMutableArray()
    var subkindList:NSMutableArray = NSMutableArray()
    var debitList:NSMutableArray = NSMutableArray()
    var balanceList:NSMutableArray = NSMutableArray()
    
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
        var keyValue: AnyObject? = settingPlist?.valueForKey("ProductCode")
        productCode = keyValue as! String
        var apiValue: AnyObject? = settingPlist?.valueForKey("API")
        var api = apiValue as! String
        var url:NSURL = NSURL(string: "\(api)/account/catetoryTransaction/%E6%8A%95%E8%B5%84%E6%98%8E%E7%BB%86/1")!
        var requrst:NSURLRequest?
        var conn:NSURLConnection?
        requrst=NSURLRequest(URL:url)
        conn=NSURLConnection(request: requrst!,delegate: self)
        
        var data = NSData(contentsOfURL: url)
        var str = NSString(data: data!, encoding: NSUTF8StringEncoding)
        //var json : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        let json = JSON(data: data!)
        var count = json["dataList"].count
        println("\(count)")
        //tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //        createOn = json[""]
        //        investor
        //        amount
        
        println("investHistory:\(json)")
        for(var i = 0; i < count; i++){
            createOnList.addObject(json["dataList"][i]["createdOn"].string!)
            subkindList.addObject(json["dataList"][i]["subkind"].string!)
            debitList.addObject(json["dataList"][i]["debit"].float!)
            balanceList.addObject(json["dataList"][i]["balance"].float!)
        }
        time.layer.borderColor = UIColor.lightGrayColor().CGColor
        time.layer.borderWidth = 1
        type.layer.borderColor = UIColor.lightGrayColor().CGColor
        type.layer.borderWidth = 1
        money.layer.borderColor = UIColor.lightGrayColor().CGColor
        money.layer.borderWidth = 1
        restMoney.layer.borderColor = UIColor.lightGrayColor().CGColor
        restMoney.layer.borderWidth = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection: Int) -> Int{
        return createOnList.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        var cell = historyCell(reuseIdentifier:"historyCell")
        cell.backgroundColor = UIColor.whiteColor()
        cell.addDate(createOnList[indexPath.row] as! String)
        cell.addType(subkindList[indexPath.row] as! String)
        cell.addAmount(debitList[indexPath.row] as! Float)
        cell.addRest(balanceList[indexPath.row] as! Float)
        return cell
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if tabBar.selectedItem == Home {
            performSegueWithIdentifier("InvestDetailToHome", sender: AnyObject?())
        }
        else if tabBar.selectedItem == Account{
            performSegueWithIdentifier("InvestDetailToAccount", sender: AnyObject?())
        }
        else if tabBar.selectedItem == More{
            performSegueWithIdentifier("InvestDetailToMore", sender: AnyObject?())
        }
    }
    
    @IBOutlet var restMoney: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var type: UILabel!
    @IBOutlet var money: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var Home: UITabBarItem!
    @IBOutlet var Account: UITabBarItem!
    @IBOutlet var More: UITabBarItem!
    
}