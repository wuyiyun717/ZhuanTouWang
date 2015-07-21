//
//  MoreViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/5/31.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController, UITabBarDelegate, UITableViewDelegate{
   
    var moreViewTableList:NSArray = ["实名认证","绑定手机","登录密码","交易密码","站内信","关于专投网"]
    var moreViewDetailList:NSMutableArray = ["未认证","1370****7982","修改","修改","0封未读",""]
    var gestureOn:Bool = true
    var unread = 0
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
        //Home.setTitleTextAttributes(<#attributes: [NSObject : AnyObject]!#>, forState: <#UIControlState#>)
        tabBar.selectedItem = More
        
        
        if(!IJReachability.isConnectedToNetwork()){
            var addView:UIAlertController = UIAlertController(title: "", message: "请检查网络状态", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
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
        var keyValue: AnyObject? = settingPlist?.valueForKey("gestureOn")
        gestureOn = keyValue as! Bool
        var apiValue: AnyObject? = settingPlist?.valueForKey("API")
        var api = apiValue as! String
        var url:NSURL = NSURL(string: "\(api)/account")!
        var requrst:NSURLRequest?
        var conn:NSURLConnection?
        requrst=NSURLRequest(URL:url)
        conn=NSURLConnection(request: requrst!,delegate: self)
        
        var data = NSData(contentsOfURL: url)
        let json = JSON(data: data!)
        if(json["idCard"].string == nil){
            moreViewDetailList[0] = "未认证"
        }
        else{
            moreViewDetailList[0] = json["idCard"].string!
        }
        moreViewDetailList[1] = json["mobilePhone"].string!
        var url2:NSURL = NSURL(string: "\(api)/account/allMessages/1")!
        var requrst2:NSURLRequest?
        var conn2:NSURLConnection?
        requrst2=NSURLRequest(URL:url2)
        conn2=NSURLConnection(request: requrst2!,delegate: self)
        
        var data2 = NSData(contentsOfURL: url2)
        let json2 = JSON(data: data2!)
        var count = json2["dataList"].count
        //println("\(json2)")
        for(var i = 0;i < json2["dataList"].count;i++){
            if(json2["dataList"][i]["status"].string! == "未查看"){
                unread++
            }
        }
        moreViewDetailList[4] = "\(unread)封未读"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return moreViewTableList.count
    }
    
    func tableView(tableView:UITableView!, numberOfRowsInSection: Int) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        //let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell
        //var cell2 = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        //cell2.backgroundColor = UIColor.lightGrayColor()
        //cell2.bounds.size.height = 50
        var cell:UITableViewCell
//        if(indexPath.section != (moreViewTableList.count - 1)){
            cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
            cell.textLabel!.text = "\(moreViewTableList[indexPath.section])"
            cell.detailTextLabel?.text = "\(moreViewDetailList[indexPath.section])"
//            if(indexPath.section == 4){
//                var switchView = UISwitch(frame: CGRectZero)
//                //switchView.setOn(true, animated: false)
//                if(gestureOn == false){
//                    switchView.setOn(false, animated: true)
//                    switchView.addTarget(self, action: "switchOn", forControlEvents: UIControlEvents.ValueChanged)
//                }
//                else{
//                    switchView.setOn(true, animated: true)
//                    switchView.addTarget(self, action: "switchOff", forControlEvents: UIControlEvents.ValueChanged)
//                }
//                cell.accessoryView = switchView
//            }
//            else{
                cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
//            }
            cell.detailTextLabel?.text = "\(moreViewDetailList[indexPath.section])"
            cell.imageView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            cell.imageView?.contentMode = UIViewContentMode.ScaleAspectFit
//        }
//        else{
//            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
//            cell.textLabel!.text = "\(moreViewTableList[indexPath.section])"
//            cell.textLabel?.textAlignment = NSTextAlignment.Center
//        }
//        cell.backgroundColor = UIColor.whiteColor()
//        cell.layer.borderColor = UIColor.lightGrayColor().CGColor
//        cell.layer.borderWidth = 1
//        if(indexPath.section >= 4){
//            cell.textLabel?.textColor = UIColor.redColor()
//        }
        switch (indexPath.section) {
        case 0:
            if(moreViewDetailList[0] as! String != "未认证"){
                cell.selectionStyle = UITableViewCellSelectionStyle.None
            }
            cell.imageView?.image = UIImage(named: "realname.png")
        case 1:
            cell.imageView?.image = UIImage(named: "bindphone.png")
        case 2:
            cell.imageView?.image = UIImage(named: "password.png")
        case 3:
            cell.imageView?.image = UIImage(named: "tradecode.png")
        case 4:
            cell.imageView?.image = UIImage(named: "mail.png")
        case 5:
            cell.imageView?.image = UIImage(named: "LOGO.png")
        default:
            println("default")
        }

//        var cell2 = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
//        cell2.bounds.size.height = cell.bounds.size.height + 5
//        cell2.addSubview(cell)
//        cell2.backgroundColor = UIColor.lightGrayColor()
//
//        return cell2
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if (section == 0 || section == 1 || section >= 4 ){
//            return 5
//        }
//        else{
//            return 0
//        }
        return 5
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch (indexPath.section) {
        case 0:
            if(moreViewDetailList[0] as! String == "未认证"){
                performSegueWithIdentifier("ToRealName", sender: AnyObject?())
            }
            println("实名认证")
        case 1:
            performSegueWithIdentifier("ToBinding", sender: AnyObject?())
            println("绑定手机")
        case 2:
            performSegueWithIdentifier("ToLoginPassword", sender: AnyObject?())
            println("登录密码")
        case 3:
            performSegueWithIdentifier("ToTradePassword", sender: AnyObject?())
            println("交易密码")
//        case 4:
//            performSegueWithIdentifier("ToGesture", sender: AnyObject?())
//            println("开启手势密码")
        case 4:
            performSegueWithIdentifier("ToMessage", sender: AnyObject?())
            println("站内信")
        case 5:
            performSegueWithIdentifier("ToAbout", sender: AnyObject?())
            println("关于专投网")
        default:
            println("default")
        }
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if tabBar.selectedItem == Home {
            performSegueWithIdentifier("MoreToHome", sender: AnyObject?())
        }
        else if tabBar.selectedItem == Account{
            performSegueWithIdentifier("MoreToAccount", sender: AnyObject?())
        }
    }
    
    func switchOn(){
        dispatch_async(dispatch_get_main_queue()) {
            self.gestureOn = true
            let home = NSHomeDirectory() as NSString;
            let docPath = home.stringByAppendingPathComponent("Documents") as NSString
            let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
            //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
            var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
            settingPlist?.setValue(self.gestureOn, forKey: "gestureOn")
            settingPlist?.writeToFile(plistPath, atomically: true)
            self.tableView.reloadData()
            self.view.setNeedsDisplay()
        }
        println("SwitchOn")
    }
    
    func switchOff(){
        dispatch_async(dispatch_get_main_queue()) {
            self.gestureOn = false
            let home = NSHomeDirectory() as NSString;
            let docPath = home.stringByAppendingPathComponent("Documents") as NSString
            let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
            //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
            var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
            settingPlist?.setValue(self.gestureOn, forKey: "gestureOn")
            settingPlist?.writeToFile(plistPath, atomically: true)
            self.tableView.reloadData()
            self.view.setNeedsDisplay()
        }
        println("SwitchOff")
    }
    
    @IBAction func logout(sender: AnyObject) {
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
        var request = HTTPTask()
        let home = NSHomeDirectory() as NSString;
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
        let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
        //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
        var keyValue: AnyObject? = settingPlist?.valueForKey("WithoutAPI")
        var apiadd = keyValue as! String
        request.GET("\(apiadd)/Account/SignOut", parameters: nil, completionHandler: {(response:HTTPResponse) -> Void in
            println("log out")
            var login:Bool = false
            settingPlist?.setValue(login, forKey: "Login")
            settingPlist?.writeToFile(plistPath, atomically: true)
            
        })
        performSegueWithIdentifier("MoreToHome", sender: AnyObject?())
    }
    
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var Home: UITabBarItem!
    @IBOutlet var Account: UITabBarItem!
    @IBOutlet var More: UITabBarItem!
    
}