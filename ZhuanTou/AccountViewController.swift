//
//  AccountViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/5/31.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class AccountViewController: UIViewController, UITabBarDelegate, UITableViewDelegate{
    
    var accountViewTableList:NSArray = ["账户余额","投资记录","我的银行卡","我的红包"]
    var accountViewDetailList:NSMutableArray! = NSMutableArray()
    @IBOutlet var tableView: UITableView!
    
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
        
        // Do any additional setup after loading the view, typically from a nib.
        let home = NSHomeDirectory() as NSString;
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
        let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
        //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
        var keyValue: AnyObject? = settingPlist?.valueForKey("Login")
        var login = keyValue as! Bool
        if (login != false) {
            tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            tableView.reloadData()
            
            UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor()], forState: UIControlState.Selected)
            tabBar.barTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
            
            Home.image = UIImage(named: "home.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            Home.selectedImage = UIImage(named: "home-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            Account.image = UIImage(named: "account.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            Account.selectedImage = UIImage(named: "account-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            More.image = UIImage(named: "more.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            More.selectedImage = UIImage(named: "more-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
            //Home.setTitleTextAttributes(, forState: )
            tabBar.selectedItem = Account
            
            var apiValue: AnyObject? = settingPlist?.valueForKey("API")
            var api = apiValue as! String
            var url:NSURL = NSURL(string: "\(api)/account")!
            var requrst:NSURLRequest?
            var conn:NSURLConnection?
            requrst=NSURLRequest(URL:url)
            conn=NSURLConnection(request: requrst!,delegate: self)
            
            var data = NSData(contentsOfURL: url)
            let json = JSON(data: data!)
            var esset = String(format: "%.2f",json["totalEsset"].float!)
            totalEsset.text = "\(esset)"
            var invest = String(format: "%.2f",json["activeInvestTotalAmount"].float!)
            activeInvest.text = "\(invest)"
            var paidReturn = String(format: "%.2f",json["totalPaidReturnAmount"].float!)
            totalReturn.text = "\(paidReturn)"
            statusView.layer.borderColor = UIColor.lightGrayColor().CGColor
            statusView.layer.borderWidth = 1
            println("\(json)")
            var available = String(format: "%.2f",json["fundsAvailable"].float!)
            //println("\(available)")
            
            accountViewDetailList.addObject(available)
        }
        else {
            dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("AccountToLogin", sender: AnyObject?())
            }
        }
    }
    
//    override func viewWillAppear(animated: Bool) {
//        var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
//        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath!)
//        var keyValue: AnyObject? = settingPlist?.valueForKey("Login")
//        var login = keyValue as! Bool
//        if (login == false){
//            performSegueWithIdentifier("AccountToLogin", sender: AnyObject?())
//        }
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return accountViewTableList.count
    }
    
    func tableView(tableView:UITableView!, numberOfRowsInSection: Int) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        if (indexPath.row == 0){
//            println("largeCell")
//            return 100
//        }
//        else if (indexPath.row == 1 || indexPath.row == 2){
//            reurn 80
//        }
//        else  {
//            return 50
//        }
        return 50
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        //let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        //cell.textLabel!.text = "\(accountViewTableList[indexPath.row])"
        //cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        //cell.detailTextLabel?.text = "\(accountViewDetailList[indexPath.row])"
        //cell.imageView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        if (indexPath.row == 1){
            //tableView.rowHeight = 50
            //var subCell1 = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
//            var subCell1 = UITableViewCell(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
//            var subCell2 = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
//            subCell1.textLabel!.text = "\(accountViewTableList[1])"
//            subCell1.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//            subCell1.detailTextLabel?.text = "\(accountViewDetailList[1])"
//            subCell2.textLabel!.text = "\(accountViewTableList[2])"
//            subCell2.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//            subCell2.detailTextLabel?.text = "\(accountViewDetailList[2])"
//            var subView = CustomTableCell()
//            subView.addSubview(subCell1)
//            cell.addSubview(subView)
            //cell.detailTextLabel?.addSubview(subCell2)
//            println("NoImage")
//        }
//        else{
        self.automaticallyAdjustsScrollViewInsets = false
        if(!IJReachability.isConnectedToNetwork()){
            var addView:UIAlertController = UIAlertController(title: "", message: "请检查网络状态", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                self.viewDidLoad()
            }
            addView.addAction(actionOK)
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(addView, animated: true, completion: nil)
            }
            return cell
        }
        let home = NSHomeDirectory() as NSString;
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
        let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
        //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
        var keyValue: AnyObject? = settingPlist?.valueForKey("Login")
        var login = keyValue as! Bool
        if (login != false) {
            cell.textLabel!.text = "\(accountViewTableList[indexPath.section])"
            if (indexPath.section != 0){
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
            }else{
                cell.detailTextLabel?.text = "\(accountViewDetailList[indexPath.section])"
            }
            cell.imageView?.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
            switch(indexPath.section){
            case 0:
                cell.imageView?.image = UIImage(named: "balance.png")
                cell.selectionStyle = UITableViewCellSelectionStyle.None
                
            case 1:
                cell.imageView?.image = UIImage(named: "record.png")
                
            case 2:
                cell.imageView?.image = UIImage(named: "bank.png")
                
            case 3:
                cell.imageView?.image = UIImage(named: "ticket.png")
                
            default:
                println("default")
            }
        }
            //        }
        return cell
    }
    
//    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
//        if (indexPath.section == 0){
//            return nil
//        }
//        else{
//            return indexPath
//        }
//    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section){
        case 1:
            performSegueWithIdentifier("InvestDetail", sender: AnyObject?())
        case 2:
            performSegueWithIdentifier("ToBankCard", sender: AnyObject?())
        case 3:
            performSegueWithIdentifier("MyCoupon", sender: AnyObject?())
        default:
            println("default")
        }
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if tabBar.selectedItem == Home {
            performSegueWithIdentifier("AccountToHome", sender: AnyObject?())
        }
        else if tabBar.selectedItem == More{
            performSegueWithIdentifier("AccountToMore", sender: AnyObject?())
        }
    }
    
    @IBAction func allIncome(sender: AnyObject) {
        println("allIncome")
    }

    @IBAction func onInvest(sender: AnyObject) {
        println("onInvest")
    }
//    @IBAction func recharge(sender: AnyObject) {
//        var url = NSURL(string: "http://d.alipay.com")
//        UIApplication.sharedApplication().openURL(url!)
//    }
    
    @IBOutlet var totalEsset: UILabel!
    @IBOutlet var statusView: UIView!
    @IBOutlet var totalReturn: UILabel!
    @IBOutlet var activeInvest: UILabel!
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var Home: UITabBarItem!
    @IBOutlet var Account: UITabBarItem!
    @IBOutlet var More: UITabBarItem!
    
    
}