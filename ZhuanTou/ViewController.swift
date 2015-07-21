//
//  ViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/5/31.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITabBarDelegate, UITableViewDelegate{
    var productCount:Int = 0
    var productCodeList:NSMutableArray! = NSMutableArray()
    var productNameList:NSMutableArray! = NSMutableArray()
    var productStatusList:NSMutableArray! = NSMutableArray()
    var productBenefitList:NSMutableArray! = NSMutableArray()
    var productPeriodList:NSMutableArray! = NSMutableArray()
    var productFundList:NSMutableArray! = NSMutableArray()
    var productPercentList:NSMutableArray! = NSMutableArray()
    var productStyle = "稳健型"
    var isLogin = false
    var typeSelected:Int = 0
    var newStockCode = ""
    var activityInd:UIActivityIndicatorView! = UIActivityIndicatorView()
    var activityView:UIView! = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        activityView.frame = self.view.frame
        activityView.backgroundColor = UIColor.whiteColor()
        activityView.alpha = 0.8
        activityInd.frame.size = CGSizeMake(50, 50)
        activityInd.center = self.view.center
        activityInd.startAnimating()
        activityInd.color = UIColor.redColor()
        activityView.addSubview(activityInd)
        self.view.addSubview(activityView)
        activityView.hidden = false
        // Do any additional setup after loading the view, typically from a nib.

        
        //typeSegment.layer.masksToBounds = true
        //typeSegment.layer.cornerRadius = 0
        //        typeSegment.tintColor = UIColor.clearColor()
//        var att = [NSFontAttributeName:UIFont.boldSystemFontOfSize(16), NSForegroundColorAttributeName:UIColor(red: 230, green: 126, blue: 34, alpha: 1)]
//        typeSegment.setTitleTextAttributes(att, forState: UIControlState.Selected)
//        typeSegment.setTitleTextAttributes(att, forState: UIControlState.Normal)
//        NSString *htmlPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"index.htm"];
//        NSString *htmlString = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
//        [self.myWebView loadHTMLString:htmlString baseURL:[NSURL fileURLWithPath:htmlPath]];
//        var htmlPath = NSBundle(path: "index.html")
        //Home.image = UIImage(named: "home.png")
        //var barItemSize = CGSize(width: 20, height: 20)
        //var homeIcon = UIImage(named: "home.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        //Home.image?.size.height = 20
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor()], forState: UIControlState.Selected)
        tabBar.barTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        Home.image = UIImage(named: "home.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        Home.selectedImage = UIImage(named: "home-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        Account.image = UIImage(named: "account.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        Account.selectedImage = UIImage(named: "account-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        More.image = UIImage(named: "more.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        More.selectedImage = UIImage(named: "more-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        //Home.setTitleTextAttributes(<#attributes: [NSObject : AnyObject]!#>, forState: <#UIControlState#>)
        tabBar.selectedItem = Home
        
        newStockFund.layer.borderColor = UIColor(red: 205/255, green: 54/255, blue: 46/255, alpha: 1.0).CGColor
        newStockFund.layer.borderWidth = 2
        
        //newStockFund.frame = CGRectMake(0, 50, 100, 0)
        //self.view.addSubview(newStockFund)
        //stButtonSelected.frame = CGRectMake(0, 50, 0, 2)
        //coButtonSelected
        //enButtonSelected
        
        self.automaticallyAdjustsScrollViewInsets = false

        stButtonSelected.hidden = false
        coButtonSelected.hidden = true
        enButtonSelected.hidden = true
        
        typeSelected = 1
        clearList()
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
        else{
            println("OK")
        }
//        var waitcount = 0
//        do{
//            println("Block")
//            waitcount++
//        }while(!IJReachability.isConnectedToNetwork() && waitcount < 20)
//        
//        if(waitcount == 20){
//            println("Block")
//            var addView:UIAlertController = UIAlertController(title: "", message: "请检查网络状态", preferredStyle:.Alert)
//            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
//                self.performSegueWithIdentifier("ToLogin", sender: AnyObject?())
//
//            }
//            addView.addAction(actionOK)
//            dispatch_async(dispatch_get_main_queue()) {
//
//                self.presentViewController(addView, animated: true, completion: nil)
//            }
//            return
//        }
        
//        var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
//        //println(plistPath)
//        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath!)
//        let home = NSHomeDirectory() as NSString;
//        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
//        let filePath = docPath.stringByAppendingPathComponent("Setting.plist")
//        settingPlist!.writeToFile(filePath, atomically: true)
//        var keyValue: AnyObject? = settingPlist?.valueForKey("API")
//        var api = keyValue as! String
//        var url:NSURL = NSURL(string: "\(api)/product/orderedAll")!
//        var requrst:NSURLRequest?
//        var conn:NSURLConnection?
//        requrst=NSURLRequest(URL:url)
//        conn=NSURLConnection(request: requrst!,delegate: self)
//        var data = NSData(contentsOfURL: url)
//        var json = JSON(data: data!)
//        var count = json["dataList"].count
//        for(var i = 0; i < count; i++){
//            var style = json["dataList"][i]["style"].string
//            if(style == "稳健型"){
//                var productName:String = json["dataList"][i]["productName"].string!
//                //println("\nName:\(productName)")
//                productNameList.addObject(productName)
//                productCodeList.addObject(json["dataList"][i]["productCode"].string!)
//                productStatusList.addObject(json["dataList"][i]["status"].string!)
//                productBenefitList.addObject(json["dataList"][i]["interestRate"].int!)
//                productPeriodList.addObject(json["dataList"][i]["noOfDays"].int!)
//                productPercentList.addObject(json["dataList"][i]["investProgress"].int!)
//                productCount++
//            }
//        }
//        //productCount = json["dataList"].count
//        println("\n稳健型:\(productCount)")
//        println("\nName:\(productNameList)")
//        println("\nStatus:\(productStatusList)")
//        println("\nBenefit:\(productBenefitList)")
//        println("\nPeriod:\(productPeriodList)")
//        println("\nPercent:\(productPercentList)")
//        //println("\n\(json)")
//        productStyle = "稳健型"
//        settingPlist?.setValue(productStyle, forKey: "ProductStyle")
//        settingPlist?.writeToFile(filePath, atomically: true)
//        getStockCode()
        //var str = NSString(data: data!, encoding: NSUTF8StringEncoding)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
        //println(plistPath)
        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath!)
        let home = NSHomeDirectory() as NSString;
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
        let filePath = docPath.stringByAppendingPathComponent("Setting.plist")
        settingPlist!.writeToFile(filePath, atomically: true)
        var keyValue: AnyObject? = settingPlist?.valueForKey("API")
        var api = keyValue as! String
        var url:NSURL = NSURL(string: "\(api)/product/orderedAll")!
        var requrst:NSURLRequest?
        var conn:NSURLConnection?
        requrst=NSURLRequest(URL:url)
        conn=NSURLConnection(request: requrst!,delegate: self)
        var data = NSData(contentsOfURL: url)
        var json = JSON(data: data!)
        var count = json["dataList"].count
        for(var i = 0; i < count; i++){
            var style = json["dataList"][i]["style"].string
            if(style == "稳健型"){
                var productName:String = json["dataList"][i]["productName"].string!
                //println("\nName:\(productName)")
                productNameList.addObject(productName)
                productCodeList.addObject(json["dataList"][i]["productCode"].string!)
                productStatusList.addObject(json["dataList"][i]["status"].string!)
                productBenefitList.addObject(json["dataList"][i]["interestRate"].int!)
                productPeriodList.addObject(json["dataList"][i]["noOfDays"].int!)
                productPercentList.addObject(json["dataList"][i]["investProgress"].int!)
                productCount++
            }
        }
        //productCount = json["dataList"].count
        println("\n稳健型:\(productCount)")
        println("\nName:\(productNameList)")
        println("\nStatus:\(productStatusList)")
        println("\nBenefit:\(productBenefitList)")
        println("\nPeriod:\(productPeriodList)")
        println("\nPercent:\(productPercentList)")
        //println("\n\(json)")
        productStyle = "稳健型"
        settingPlist?.setValue(productStyle, forKey: "ProductStyle")
        settingPlist?.writeToFile(filePath, atomically: true)
        getStockCode()
        tableView.reloadData()
        activityInd.stopAnimating()
        activityView.hidden = true

    }
    
    func upMove()// 调用向上移动的方法
    {
        newStockFund.hidden = true
        var c:CGFloat = 110.0
        stableButton.frame.origin.y = stableButton.frame.origin.y - c
        compButton.frame.origin.y = compButton.frame.origin.y - c
        enterprisingButton.frame.origin.y = enterprisingButton.frame.origin.y - c
        stButtonSelected.frame.origin.y = stButtonSelected.frame.origin.y - c
        coButtonSelected.frame.origin.y = coButtonSelected.frame.origin.y - c
        enButtonSelected.frame.origin.y = enButtonSelected.frame.origin.y - c
        tableView.frame.origin.y = tableView.frame.origin.y - c
        tableView.frame.size.height = tableView.frame.size.height + c
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
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
        var login:Bool = isLogin
        settingPlist?.setValue(login, forKey: "Login")
        settingPlist?.writeToFile(plistPath, atomically: true)
        if tabBar.selectedItem == Account {
//            var detailedViewController:AccountViewController = AccountViewController()
//            self.navigationController!.pushViewController(detailedViewController, animated: true)
            if(isLogin == false){
                performSegueWithIdentifier("ToLogin", sender: AnyObject?())
            }
            else{
                performSegueWithIdentifier("HomeToAccount", sender: AnyObject?())
            }
        }
        else if tabBar.selectedItem == More{
//            var detailedViewController = AccountViewController()
//            self.navigationController!.pushViewController(detailedViewController, animated: true)
            if(isLogin == false){
                performSegueWithIdentifier("ToLogin", sender: AnyObject?())
            }
            else{
                performSegueWithIdentifier("HomeToMore", sender: AnyObject?())
            }
        }
    }
    
    func getStockCode(){
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
        var keyValue: AnyObject? = settingPlist?.valueForKey("API")
        var api = keyValue as! String
        var url:NSURL = NSURL(string: "\(api)/product/newStockFund")!
        var requrst:NSURLRequest?
        var conn:NSURLConnection?
        requrst=NSURLRequest(URL:url)
        conn=NSURLConnection(request: requrst!,delegate: self)
        var data = NSData(contentsOfURL: url)
        var dataString:NSString = NSString()
        if(data != nil){
            dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
        }
        if (data == nil || dataString == "null" || dataString == ""){
            dispatch_async(dispatch_get_main_queue()) {
                self.upMove()
            }
        }
        else{
            var json = JSON(data: data!)
            newStockLabel.text = json["productName"].string!
            newStockCode = json["productCode"].string!
        }

    }
    
    @IBAction func GetInfo(sender: AnyObject) {
        var url:NSURL = NSURL(string: "http://test.pujintianxia.com/api/product/orderedAll")!
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
        //println(str!)
        let json = JSON(data: data!)
        if let productCode = json["dataList"][0]["productCode"].string{
            let home = NSHomeDirectory() as NSString;
            let docPath = home.stringByAppendingPathComponent("Documents") as NSString
            let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
            //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
            var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
            var keyValue: AnyObject? = settingPlist?.valueForKey("ProductCode")
            settingPlist?.setValue(productCode, forKey: "ProductCode")
            settingPlist?.writeToFile(plistPath, atomically: true)
            println(productCode)
            //Now you got your value
        }
    }
    
    @IBAction func stableChosen(sender: AnyObject) {
        stButtonSelected.hidden = false
        coButtonSelected.hidden = true
        enButtonSelected.hidden = true
        typeSelected = 1
        clearList()
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
        var keyValue: AnyObject? = settingPlist?.valueForKey("API")
        var api = keyValue as! String
        var url:NSURL = NSURL(string: "\(api)/product/orderedAll")!
        var requrst:NSURLRequest?
        var conn:NSURLConnection?
        requrst=NSURLRequest(URL:url)
        conn=NSURLConnection(request: requrst!,delegate: self)
        var data = NSData(contentsOfURL: url)
        var json = JSON(data: data!)
        var count = json["dataList"].count
        for(var i = 0; i < count; i++){
            var style = json["dataList"][i]["style"].string
            if(style == "稳健型"){
                var productName:String = json["dataList"][i]["productName"].string!
                //println("\nName:\(productName)")
                productNameList.addObject(productName)
                productCodeList.addObject(json["dataList"][i]["productCode"].string!)
                productStatusList.addObject(json["dataList"][i]["status"].string!)
                productBenefitList.addObject(json["dataList"][i]["interestRate"].int!)
                productPeriodList.addObject(json["dataList"][i]["noOfDays"].int!)
                productPercentList.addObject(json["dataList"][i]["investProgress"].int!)
                productCount++
            }
        }
        println("\n稳健型:\(productCount)")
        productStyle = "稳健型"
        settingPlist?.setValue(productStyle, forKey: "ProductStyle")
        settingPlist?.writeToFile(plistPath, atomically: true)
        
        tableView.reloadData()
    }
    
    @IBAction func compChosen(sender: AnyObject) {
        stButtonSelected.hidden = true
        coButtonSelected.hidden = false
        enButtonSelected.hidden = true
        tableView.reloadData()
        typeSelected = 2
        clearList()
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
        var keyValue: AnyObject? = settingPlist?.valueForKey("API")
        var api = keyValue as! String
        var url:NSURL = NSURL(string: "\(api)/product/orderedAll")!
        var requrst:NSURLRequest?
        var conn:NSURLConnection?
        requrst=NSURLRequest(URL:url)
        conn=NSURLConnection(request: requrst!,delegate: self)
        var data = NSData(contentsOfURL: url)
        var json = JSON(data: data!)
        var count = json["dataList"].count
        for(var i = 0; i < count; i++){
            var style = json["dataList"][i]["style"].string
            if(style == "综合型"){
                var productName:String = json["dataList"][i]["productName"].string!
                //println("\nName:\(productName)")
                productNameList.addObject(productName)
                productCodeList.addObject(json["dataList"][i]["productCode"].string!)
                productStatusList.addObject(json["dataList"][i]["status"].string!)
                productBenefitList.addObject(json["dataList"][i]["interestRate"].int!)
                productFundList.addObject(json["dataList"][i]["shareRatio"].int!)
                productPeriodList.addObject(json["dataList"][i]["noOfDays"].int!)
                productPercentList.addObject(json["dataList"][i]["investProgress"].int!)
                productCount++
            }
        }
        println("\n综合型:\(productCount)")
        productStyle = "综合型"
        settingPlist?.setValue(productStyle, forKey: "ProductStyle")
        settingPlist?.writeToFile(plistPath, atomically: true)
        
        tableView.reloadData()
    }
    
    @IBAction func enterChosen(sender: AnyObject) {
        stButtonSelected.hidden = true
        coButtonSelected.hidden = true
        enButtonSelected.hidden = false
        tableView.reloadData()
        typeSelected = 3
        clearList()
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
        var keyValue: AnyObject? = settingPlist?.valueForKey("API")
        var api = keyValue as! String
        var url:NSURL = NSURL(string: "\(api)/product/orderedAll")!
        var requrst:NSURLRequest?
        var conn:NSURLConnection?
        requrst=NSURLRequest(URL:url)
        conn=NSURLConnection(request: requrst!,delegate: self)
        var data = NSData(contentsOfURL: url)
        var json = JSON(data: data!)
        var count = json["dataList"].count
        for(var i = 0; i < count; i++){
            var style = json["dataList"][i]["style"].string
            if(style == "进取型"){
                var productName:String = json["dataList"][i]["productName"].string!
                //println("\nName:\(productName)")
                productNameList.addObject(productName)
                productCodeList.addObject(json["dataList"][i]["productCode"].string!)
                productStatusList.addObject(json["dataList"][i]["status"].string!)
                productBenefitList.addObject(json["dataList"][i]["shareRatio"].int!)
                productFundList.addObject(json["dataList"][i]["guaranteedRatio"].int!)
                productPeriodList.addObject(json["dataList"][i]["noOfDays"].int!)
                productPercentList.addObject(json["dataList"][i]["investProgress"].int!)
                productCount++
            }
        }
        println("\n进取型:\(productCount)")
        productStyle = "进取型"
        settingPlist?.setValue(productStyle, forKey: "ProductStyle")
        settingPlist?.writeToFile(plistPath, atomically: true)
        tableView.reloadData()
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 2
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return productCount
    }
    
    func tableView(tableView:UITableView!, numberOfRowsInSection: Int) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        self.automaticallyAdjustsScrollViewInsets = false
        //var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
//        cell.imageView?.image = UIImage(named: "onTrade.png")
//        cell.textLabel?.numberOfLines = 0
//        cell.textLabel?.text = "双子座1.0\n 15% 30天\n 固定收益 投资期限"
//        var percent: KDGoalBar = KDGoalBar(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
//        percent.setPercent(33, animated: false)
//        
//        cell.autoresizesSubviews = true
//        
//        cell.accessoryView = percent
//        cell.accessoryView!.autoresizingMask = UIViewAutoresizing.FlexibleWidth
//        cell.accessoryView!.autoresizingMask = UIViewAutoresizing.FlexibleHeight
        var outCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
        switch (typeSelected){
        case 1:
            var cell = stableCell(reuseIdentifier:"stableCell")
            if (productStatusList[indexPath.section] as! String == "操盘中"){
                cell.addStatus(UIImage(named: "onTrade.png"))
            }
            else if (productStatusList[indexPath.section] as! String == "已完结"){
                cell.addStatus(UIImage(named: "afterTrade.png"))
            }
            else{
                cell.addStatus(UIImage(named: "newTrade.png"))
            }
            cell.addTitle(productNameList[indexPath.section] as! String)
            cell.addBenefit(productBenefitList[indexPath.section] as! Int)
            cell.addPeriod(productPeriodList[indexPath.section] as! Int)
            cell.addPercent(productPercentList[indexPath.section] as! Int)
            return cell
        case 2:
            var cell = compCell(reuseIdentifier:"compCell")
            if (productStatusList[indexPath.section] as! String == "操盘中"){
                cell.addStatus(UIImage(named: "onTrade.png"))
            }
            else if (productStatusList[indexPath.section] as! String == "已完结"){
                cell.addStatus(UIImage(named: "afterTrade.png"))
            }
            else{
                cell.addStatus(UIImage(named: "newTrade.png"))
            }
            cell.addTitle(productNameList[indexPath.section] as! String)
            cell.addBenefit(productBenefitList[indexPath.section] as! Int)
            cell.addFund(productFundList[indexPath.section] as! Int)
            cell.addPeriod(productPeriodList[indexPath.section] as! Int)
            cell.addPercent(productPercentList[indexPath.section] as! Int)
            return cell
        case 3:
            var cell = enterCell(reuseIdentifier:"enterCell")
            if (productStatusList[indexPath.section] as! String == "操盘中"){
                cell.addStatus(UIImage(named: "onTrade.png"))
            }
            else if (productStatusList[indexPath.section] as! String == "已完结"){
                cell.addStatus(UIImage(named: "afterTrade.png"))
            }
            else if(productStatusList[indexPath.section] as! String == "预约中"){
                cell.addStatus(UIImage(named: "appointing.png"))
            }
            else{
                cell.addStatus(UIImage(named: "newTrade.png"))
            }
            cell.addTitle(productNameList[indexPath.section] as! String)
            cell.addBenefit(productBenefitList[indexPath.section] as! Int)
            cell.addFund(productFundList[indexPath.section] as! Int)
            cell.addPeriod(productPeriodList[indexPath.section] as! Int)
            cell.addPercent(productPercentList[indexPath.section] as! Int)
            return cell
        default:
            println("default")
            var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "cell")
            return cell
        }
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
        var productCode = productCodeList[indexPath.section] as! String
        settingPlist?.setValue(productCode, forKey: "ProductCode")
        settingPlist?.writeToFile(plistPath, atomically: true)
        var keyValue: AnyObject? = settingPlist?.valueForKey("ProductCode")
        var prod = keyValue as! String
        println("\(prod)")
        performSegueWithIdentifier("showDetail", sender: AnyObject?())
        
    }
    
    func clearList(){
        productNameList.removeAllObjects()
        productCodeList.removeAllObjects()
        productStatusList.removeAllObjects()
        productBenefitList.removeAllObjects()
        productFundList.removeAllObjects()
        productPeriodList.removeAllObjects()
        productPercentList.removeAllObjects()
        productCount = 0
    }
    
    @IBAction func showNewStockDetail(sender: AnyObject) {
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
        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
        println("StockCode:\(newStockCode)")
        settingPlist?.setValue(newStockCode, forKey: "ProductCode")
        settingPlist?.writeToFile(plistPath, atomically: true)
        productStyle = "打新基金"
        settingPlist?.setValue(productStyle, forKey: "ProductStyle")
        settingPlist?.writeToFile(plistPath, atomically: true)
        performSegueWithIdentifier("showDetail", sender: AnyObject?())
    }
    
    @IBOutlet var newStockLabel: UILabel!
    @IBOutlet var newStockFund: UIView!
    //@IBOutlet var webView: UIWebView!
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet var typeSegment: UISegmentedControl!

    @IBOutlet weak var Home: UITabBarItem!
    @IBOutlet weak var Account: UITabBarItem!
    @IBOutlet weak var More: UITabBarItem!

    @IBOutlet var stableButton: UIButton!
    @IBOutlet var compButton: UIButton!
    @IBOutlet var enterprisingButton: UIButton!
    @IBOutlet var stButtonSelected: UIImageView!
    @IBOutlet var coButtonSelected: UIImageView!
    @IBOutlet var enButtonSelected: UIImageView!
    
    @IBOutlet var tableView: UITableView!
    
}

