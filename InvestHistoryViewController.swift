//
//  InvestHistoryViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/21.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class InvestHistoryViewController: UIViewController, UITableViewDelegate, UITabBarControllerDelegate{
    
    var productCode:String = String()
    var createOnList:NSMutableArray = NSMutableArray()
    var investorList:NSMutableArray = NSMutableArray()
    var amountList:NSMutableArray = NSMutableArray()
    var isLogin = false
    
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
        var url:NSURL = NSURL(string: "\(api)/product/seniorInvestments/\(productCode)")!
        var requrst:NSURLRequest?
        var conn:NSURLConnection?
        requrst=NSURLRequest(URL:url)
        conn=NSURLConnection(request: requrst!,delegate: self)
        //println(conn)
        if((conn) != nil){
            println("http连接成功!")
        }else{
            println("http连接失败!")
        }
        //var url2 = NSURL(string: "http://www.pujintianxia.com/api/product/orderedAll")
        
        var data = NSData(contentsOfURL: url)
        var str = NSString(data: data!, encoding: NSUTF8StringEncoding)
        //var json : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        let json = JSON(data: data!)
        var count = json.count
        println("\(count)")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
//        createOn = json[""]
//        investor
//        amount
        
        //println("investHistory:\(json)")
        for(var i = 0; i < count; i++){
            createOnList.addObject(json[i]["createdOn"].string!)
            investorList.addObject(json[i]["investorUsername"].string!)
            amountList.addObject(json[i]["amount"].float!)
        }
        time.layer.borderColor = UIColor.lightGrayColor().CGColor
        time.layer.borderWidth = 1
        people.layer.borderColor = UIColor.lightGrayColor().CGColor
        people.layer.borderWidth = 1
        money.layer.borderColor = UIColor.lightGrayColor().CGColor
        money.layer.borderWidth = 1
    }
    
    func checkLogin(){
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
        var url:NSURL = NSURL(string: "\(api)/auth/checkLogin")!
        var requrst:NSURLRequest?
        var conn:NSURLConnection?
        requrst=NSURLRequest(URL:url)
        conn=NSURLConnection(request: requrst!,delegate: self)
        
        var data = NSData(contentsOfURL: url)
        var str = NSString(data: data!, encoding: NSUTF8StringEncoding)
        //var json : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        let json = JSON(data: data!)
        isLogin = json["isAuthenticated"].bool!
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
        var cell = investCell(reuseIdentifier:"investCell")
        if((indexPath.row)%2 == 1){
            cell.backgroundColor = UIColor.whiteColor()
        }
        cell.addDate(createOnList[indexPath.row] as! String)
        cell.addInvestor(investorList[indexPath.row] as! String)
        cell.addAmount(amountList[indexPath.row] as! Float)
        return cell
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        checkLogin()
        if tabBar.selectedItem == Home {
            performSegueWithIdentifier("InvestToHome", sender: AnyObject?())
        }
        else if tabBar.selectedItem == Account{
            if(isLogin){
                performSegueWithIdentifier("InvestToAccount", sender: AnyObject?())
            }
            else{
                performSegueWithIdentifier("ToLogin", sender: AnyObject?())
            }
        }
        else if tabBar.selectedItem == More{
            if(isLogin){
                performSegueWithIdentifier("InvestToMore", sender: AnyObject?())
            }
            else{
                performSegueWithIdentifier("ToLogin", sender: AnyObject?())
            }
        }
    }
    
    @IBOutlet var time: UILabel!
    @IBOutlet var people: UILabel!
    @IBOutlet var money: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var Home: UITabBarItem!
    @IBOutlet var Account: UITabBarItem!
    @IBOutlet var More: UITabBarItem!

}