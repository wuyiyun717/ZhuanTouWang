//
//  AllInvestViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/7/3.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class CurrentInvestViewController: UIViewController,UITableViewDelegate, UITableViewDataSource{
    
    var productCode:String = String()
    var productNameList:NSMutableArray = NSMutableArray()
    var amountList:NSMutableArray = NSMutableArray()
    var paidInterestList:NSMutableArray = NSMutableArray()
    var todaysSharedList:NSMutableArray = NSMutableArray()
    var totalInterestAmountList:NSMutableArray = NSMutableArray()
    var isPosteriorShareList:NSMutableArray = NSMutableArray()
    var shareRatioList:NSMutableArray = NSMutableArray()
    var paidShareAmountList:NSMutableArray = NSMutableArray()
    var productStatusList:NSMutableArray = NSMutableArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        //        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor()], forState: UIControlState.Selected)
        //        tabBar.barTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        //
        //        Home.image = UIImage(named: "home.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        //        Home.selectedImage = UIImage(named: "home-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        //        Account.image = UIImage(named: "account.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        //        Account.selectedImage = UIImage(named: "account-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        //        More.image = UIImage(named: "more.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        //        More.selectedImage = UIImage(named: "more-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        let home = NSHomeDirectory() as NSString;
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
        let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
        //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
        var apiValue: AnyObject? = settingPlist?.valueForKey("API")
        var api = apiValue as! String
        var url:NSURL = NSURL(string: "\(api)/product/myInvests/0/1")!
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
        
        println("CurrentInvest:\(json)")
        for(var i = 0; i < count; i++){
            productNameList.addObject(json["dataList"][i]["productName"].string!)
            amountList.addObject(json["dataList"][i]["amount"].float!)
            paidInterestList.addObject(json["dataList"][i]["paidInterestAmount"].float!)
            todaysSharedList.addObject(json["dataList"][i]["todaysSharedPL"].float!)
            totalInterestAmountList.addObject(json["dataList"][i]["totalInterestAmount"].float!)
            isPosteriorShareList.addObject(json["dataList"][i]["isPosteriorShare"].bool!)
            shareRatioList.addObject(json["dataList"][i]["shareRatio"].float!)
            paidShareAmountList.addObject(json["dataList"][i]["paidShareAmount"].float!)
            productStatusList.addObject(json["dataList"][i]["productStatus"].string!)
        }
        //        time.layer.borderColor = UIColor.lightGrayColor().CGColor
        //        time.layer.borderWidth = 1
        //        type.layer.borderColor = UIColor.lightGrayColor().CGColor
        //        type.layer.borderWidth = 1
        //        money.layer.borderColor = UIColor.lightGrayColor().CGColor
        //        money.layer.borderWidth = 1
        //        restMoney.layer.borderColor = UIColor.lightGrayColor().CGColor
        //        restMoney.layer.borderWidth = 1
        investTable = UITableView()
        investTable.delegate = self
        investTable.dataSource = self
        investTable.frame = CGRect(x: 10, y: 70, width: UIScreen.mainScreen().applicationFrame.width - 20, height: UIScreen.mainScreen().applicationFrame.height - 70)
        investTable.bounces = false
        investTable.separatorStyle = UITableViewCellSeparatorStyle.None
        self.view.addSubview(investTable)

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return productNameList.count
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection: Int) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = myInvestCell(reuseIdentifier:"myInvestCell")
        cell.backgroundColor = UIColor.whiteColor()
        cell.addProductName(productNameList[indexPath.section] as! String)
        cell.addAmount(amountList[indexPath.section] as! Float)
        if(totalInterestAmountList[indexPath.section] as! Float == 0){
            cell.addPaidInterest("无派息")
        }
        else{
            cell.addPaidInterest("\(paidInterestList[indexPath.section] as! Float)")
        }
        if(isPosteriorShareList[indexPath.section] as! Bool || shareRatioList[indexPath.section] as! Float != 0){
            var number:Float = Float()
            if(productStatusList[indexPath.section] as! String == "操盘中"){
                number = todaysSharedList[indexPath.section] as! Float
            }
            else if(productStatusList[indexPath.section] as! String == "已完结"){
                number = paidShareAmountList[indexPath.section] as! Float
            }
            var str = String(format: "%.2f",number)
            cell.addTodaysShared("\(str)")
        }
        else{
            cell.addTodaysShared("无分成")
        }
        return cell
    }

    
    //    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
    //        if tabBar.selectedItem == Home {
    //            performSegueWithIdentifier("InvestDetailToHome", sender: AnyObject?())
    //        }
    //        else if tabBar.selectedItem == Account{
    //            performSegueWithIdentifier("InvestDetailToAccount", sender: AnyObject?())
    //        }
    //        else if tabBar.selectedItem == More{
    //            performSegueWithIdentifier("InvestDetailToMore", sender: AnyObject?())
    //        }
    //    }
    //
    //    @IBOutlet var restMoney: UILabel!
    //    @IBOutlet var time: UILabel!
    //    @IBOutlet var type: UILabel!
    //    @IBOutlet var money: UILabel!
    //    @IBOutlet var tableView: UITableView!
    //    @IBOutlet var tabBar: UITabBar!
    //    @IBOutlet var Home: UITabBarItem!
    //    @IBOutlet var Account: UITabBarItem!
    //    @IBOutlet var More: UITabBarItem!
    @IBOutlet var investTable: UITableView!
    
}