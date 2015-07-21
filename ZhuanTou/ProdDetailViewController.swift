//
//  ProdDetailViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/7.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class ProductDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITabBarControllerDelegate{
    
    var ProdDetailViewTableList:NSArray = ["投资记录","产品业绩展示"]
    var ProdDetailViewDetailList:NSArray = ["已有0人投资",""]
    var productCode:String = String()
    var rules:UIView = UIView()
    var table:UITableView = UITableView()
    var ruleTitle1:UILabel = UILabel()
    var ruleDetail1:UILabel = UILabel()
    var ruleTitle2:UILabel = UILabel()
    var ruleDetail2:UILabel = UILabel()
    var ruleTitle3:UILabel = UILabel()
    var ruleDetail3:UILabel = UILabel()
    var sepLine:UIImageView = UIImageView()
    var sepLine2:UIImageView = UIImageView()
    var investButton:UIButton = UIButton()
    var isLogin = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        RuleLabel1.layer.borderColor = UIColor.grayColor().CGColor
//        RuleLabel1.layer.borderWidth = 1
//        RuleLabel2.layer.borderColor = UIColor.grayColor().CGColor
//        RuleLabel2.layer.borderWidth = 1
//        RuleLabel3.layer.borderColor = UIColor.grayColor().CGColor
//        RuleLabel3.layer.borderWidth = 1
//        InstructionLabel1.layer.borderColor = UIColor.grayColor().CGColor
//        InstructionLabel1.layer.borderWidth = 1
//        InstructionLabel2.layer.borderColor = UIColor.grayColor().CGColor
//        InstructionLabel2.layer.borderWidth = 1
//        InstructionLabel3.layer.borderColor = UIColor.grayColor().CGColor
//        InstructionLabel3.layer.borderWidth = 1
        
        //subView2.layer.borderColor = UIColor.orangeColor().CGColor
        //subView2.layer.borderWidth = 1
        //subView2.layer.cornerRadius = 5
        //subLabel.layer.masksToBounds = true
        //subLabel.layer.cornerRadius = 10
        //subLabel2.layer.cornerRadius = 5
        //subLabel.lineBreakMode =
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor()], forState: UIControlState.Selected)
        tabBar.barTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        Home.image = UIImage(named: "home.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        Home.selectedImage = UIImage(named: "home-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        Account.image = UIImage(named: "account.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        Account.selectedImage = UIImage(named: "account-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        More.image = UIImage(named: "more.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        More.selectedImage = UIImage(named: "more-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

        
        detailView.layer.borderColor = UIColor.lightGrayColor().CGColor
        detailView.layer.borderWidth = 1
        
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
        println("ProductCode:\(productCode)")
        var apiValue: AnyObject? = settingPlist?.valueForKey("API")
        var api = apiValue as! String
        var url:NSURL = NSURL(string: "\(api)/product/GetProductByCode/\(productCode)")!
        var requrst:NSURLRequest?
        var conn:NSURLConnection?
        requrst=NSURLRequest(URL:url)
        conn=NSURLConnection(request: requrst!,delegate: self)
        //println(conn)


        var data = NSData(contentsOfURL: url)
        var dataString:NSString = NSString()
        if(data != nil){
            dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
        }
        
        if (data == nil || dataString == "null" || dataString == ""){
        }
        else{
        let json = JSON(data: data!)
        println("\(json)")
        var productStyle: AnyObject? = settingPlist?.valueForKey("ProductStyle")
        var style = productStyle as! String
        var totalAmount = json["totalAmount"].intValue
        println("totalAmount:\(totalAmount)")
        var bidableSeniorAmount = json["bidableSeniorAmount"].intValue
        println("bidableSeniorAmount:\(bidableSeniorAmount)")
        productName.text = json["productName"].string
        subLabel.text = "融资金额\(totalAmount/10000)万元"
        subLabel2.text = "可投金额\(bidableSeniorAmount/10000)万元"
        var noOfDays = json["noOfDays"].intValue
        periodLabel.numberOfLines = 0
        periodLabel.text = "\(noOfDays)天\n投资期限"
        println("style:\(style)")
        
        ruleTitle1 = UILabel(frame: CGRect(x: 0, y: 220, width: 60, height: 30))
        ruleDetail1 = UILabel(frame: CGRect(x: 60, y: 220, width: UIScreen.mainScreen().applicationFrame.width - 60, height: 30))
        ruleTitle2 = UILabel(frame: CGRect(x: 0, y: 251, width: 60, height: 30))
        ruleDetail2 = UILabel(frame: CGRect(x: 60, y: 251, width: UIScreen.mainScreen().applicationFrame.width - 60, height: 30))
        ruleTitle3 = UILabel(frame: CGRect(x: 0, y: 282, width: 60, height: 30))
        ruleDetail3 = UILabel(frame: CGRect(x: 60, y: 282, width: UIScreen.mainScreen().applicationFrame.width - 60, height: 30))
        ruleTitle1.text = "规则1："
        ruleTitle1.backgroundColor = UIColor.whiteColor()
        ruleTitle1.textColor = UIColor.blackColor()
        ruleTitle1.font = UIFont.systemFontOfSize(14)
        ruleTitle1.textAlignment = NSTextAlignment.Right
        ruleTitle2.text = "规则2："
        ruleTitle2.backgroundColor = UIColor.whiteColor()
        ruleTitle2.textColor = UIColor.blackColor()
        ruleTitle2.font = UIFont.systemFontOfSize(14)
        ruleTitle2.textAlignment = NSTextAlignment.Right
        ruleTitle3.text = "规则3："
        ruleTitle3.backgroundColor = UIColor.whiteColor()
        ruleTitle3.textColor = UIColor.blackColor()
        ruleTitle3.font = UIFont.systemFontOfSize(14)
        ruleTitle3.textAlignment = NSTextAlignment.Right
        ruleDetail1.backgroundColor = UIColor.whiteColor()
        ruleDetail1.textColor = UIColor.darkGrayColor()
        ruleDetail1.font = UIFont.systemFontOfSize(14)
        ruleDetail1.textAlignment = NSTextAlignment.Left
        ruleDetail2.backgroundColor = UIColor.whiteColor()
        ruleDetail2.textColor = UIColor.darkGrayColor()
        ruleDetail2.font = UIFont.systemFontOfSize(14)
        ruleDetail2.textAlignment = NSTextAlignment.Left
        ruleDetail3.backgroundColor = UIColor.whiteColor()
        ruleDetail3.textColor = UIColor.darkGrayColor()
        ruleDetail3.font = UIFont.systemFontOfSize(14)
        ruleDetail3.textAlignment = NSTextAlignment.Left
        sepLine = UIImageView(frame: CGRect(x: 10, y: 250, width: UIScreen.mainScreen().applicationFrame.width - 20, height: 1))
        sepLine2 = UIImageView(frame: CGRect(x: 10, y: 281, width: UIScreen.mainScreen().applicationFrame.width - 20, height: 1))
        sepLine.image = UIImage(named: "lineHori.png")
        sepLine2.image = UIImage(named: "lineHori.png")
        table.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        
        switch (style){
        case "稳健型":
            var interestRate = json["interestRate"].intValue
            
            proceedLabel.numberOfLines = 0
            proceedLabel.text = "\(interestRate)%\n固定收益"
            subLabelLeft.text = ""
            subLabelRight.text = ""
//            subLabelLeft.text = ""
//            subLabelRight.text = ""
//            
//            InstructionLabel3.hidden = true
//            RuleLabel3.hidden = true
//            println(ruleView.frame)
//            println(ruleView.layer.bounds)
//
//            ruleView.frame.size.height = 61
//            println(ruleView.frame)
//            println(ruleView.layer.bounds)
            
            
            rules.frame = CGRect(x: 0, y: 220, width: UIScreen.mainScreen().applicationFrame.width, height: 61)
            rules.backgroundColor = UIColor.whiteColor()
            table.frame = CGRect(x: 0, y: 281, width: UIScreen.mainScreen().applicationFrame.width, height: 70)
            //self.view.addSubview(rules)
            self.view.addSubview(table)
            self.view.addSubview(ruleTitle1)
            self.view.addSubview(ruleTitle2)
            self.view.addSubview(ruleDetail1)
            self.view.addSubview(ruleDetail2)
            self.view.addSubview(sepLine)
            ruleDetail1.text = "投资人将获得100%的本金保障"
            ruleDetail2.text = "投资人将获得\(interestRate)%的固定年化利息"
            
        case "综合型":
            var interestRate = json["interestRate"].intValue
            var shareRatio = json["shareRatio"].intValue
            
            proceedLabel.numberOfLines = 2
            proceedLabel.text = "+\n"
            
            subLabelLeft.numberOfLines = 0
            subLabelLeft.text = "\(interestRate)%\n保本比"
            subLabelRight.numberOfLines = 0
            subLabelRight.text = "\(shareRatio)%\n盈利分成"
            
            rules.frame = CGRect(x: 0, y: 220, width: UIScreen.mainScreen().applicationFrame.width, height: 92)
            rules.backgroundColor = UIColor.whiteColor()
            table.frame = CGRect(x: 0, y: 312, width: UIScreen.mainScreen().applicationFrame.width, height: 70)
            //self.view.addSubview(rules)
            self.view.addSubview(table)
            self.view.addSubview(ruleTitle1)
            self.view.addSubview(ruleTitle2)
            self.view.addSubview(ruleTitle3)
            self.view.addSubview(ruleDetail1)
            self.view.addSubview(ruleDetail2)
            self.view.addSubview(ruleDetail3)
            self.view.addSubview(sepLine)
            self.view.addSubview(sepLine2)
            ruleDetail1.text = "投资人将获得100%的本金保障"
            ruleDetail2.text = "投资人将获得\(interestRate)%的固定年化利息"
            ruleDetail3.text = "投资人将获得\(shareRatio)%的盈利分成"

        case "进取型":
            var guaranteedRatio = json["guaranteedRatio"].intValue
            var shareRatio = json["shareRatio"].intValue
            
            proceedLabel.numberOfLines = 2
            proceedLabel.text = "+\n"
            
            subLabelLeft.numberOfLines = 0
            subLabelLeft.text = "\(guaranteedRatio)%\n保本比"
            subLabelRight.numberOfLines = 0
            subLabelRight.text = "\(shareRatio)%\n盈利分成"
            
            rules.frame = CGRect(x: 0, y: 220, width: UIScreen.mainScreen().applicationFrame.width, height: 61)
            rules.backgroundColor = UIColor.whiteColor()
            table.frame = CGRect(x: 0, y: 281, width: UIScreen.mainScreen().applicationFrame.width, height: 70)
            //self.view.addSubview(rules)
            self.view.addSubview(table)
            self.view.addSubview(ruleTitle1)
            self.view.addSubview(ruleTitle2)
            self.view.addSubview(ruleDetail1)
            self.view.addSubview(ruleDetail2)
            self.view.addSubview(sepLine)
            ruleDetail1.text = "投资人将获得\(guaranteedRatio)%的本金保障"
            ruleDetail2.text = "投资人将获得\(shareRatio)%的盈利分成"
        
        case "打新基金":
            
            proceedLabel.hidden = true
            subLabelLeft.text = ""
            subLabelRight.text = ""

            rules.frame = CGRect(x: 0, y: 220, width: UIScreen.mainScreen().applicationFrame.width, height: 61)
            rules.backgroundColor = UIColor.whiteColor()
            table.frame = CGRect(x: 0, y: 281, width: UIScreen.mainScreen().applicationFrame.width, height: 70)
            self.view.addSubview(table)
            self.view.addSubview(ruleTitle1)
            self.view.addSubview(ruleTitle2)
            self.view.addSubview(ruleDetail1)
            self.view.addSubview(ruleDetail2)
            self.view.addSubview(sepLine)
            ruleDetail1.text = "投资人将获得100%的本金保障"
            ruleDetail2.text = "投资人将获得100%的盈利"

        default:
            println("Default")
        }
        
        var status = json["status"].string
        if (status == "筹款中"){
        //if (status == "操盘中"){
            investButton.frame = CGRect(x: 10, y: table.frame.maxY+10, width: UIScreen.mainScreen().applicationFrame.width-20, height: 30)
            investButton.backgroundColor = UIColor(red: 255/255, green: 66/255, blue: 55/255, alpha: 1)
            investButton.setTitle("立即投资", forState: UIControlState.Normal)
            investButton.addTarget(self, action: "investNow:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(investButton)
        }
        else if(status == "预约中"){
            investButton.frame = CGRect(x: 10, y: table.frame.maxY+10, width: UIScreen.mainScreen().applicationFrame.width-20, height: 30)
            investButton.backgroundColor = UIColor(red: 255/255, green: 66/255, blue: 55/255, alpha: 1)
            investButton.setTitle("立即预约", forState: UIControlState.Normal)
            investButton.addTarget(self, action: "appointNow:", forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(investButton)
        }
        }
        
        table.delegate = self
        table.dataSource = self
        table.separatorStyle = UITableViewCellSeparatorStyle.None
        self.automaticallyAdjustsScrollViewInsets = false
        //detailViewTable.contentInset = UIEdgeInsets(top: -34, left: 0, bottom: 0, right: 0)
        //detailViewTable.style = UITableViewStyle.Grouped
        //detailViewTable.separatorStyle = UITableViewCellSeparatorStyle.SingleLineEtched
        //detailViewTable.separatorColor = UIColor.greenColor()
    }
    
//    override func viewWillAppear(animated: Bool) {
//        super.viewWillAppear(false)
//        var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
//        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath!)
//        var apiValue: AnyObject? = settingPlist?.valueForKey("API")
//        var api = apiValue as! String
//        var url:NSURL = NSURL(string: "\(api)/product/seniorInvestments/\(productCode)")!
//        var requrst:NSURLRequest?
//        var conn:NSURLConnection?
//        requrst=NSURLRequest(URL:url)
//        conn=NSURLConnection(request: requrst!,delegate: self)
//        //println(conn)
//        if((conn) != nil){
//            println("http连接成功!")
//        }else{
//            println("http连接失败!")
//        }
//        //var url2 = NSURL(string: "http://www.pujintianxia.com/api/product/orderedAll")
//        
//        var data = NSData(contentsOfURL: url)
//        var str = NSString(data: data!, encoding: NSUTF8StringEncoding)
//        //var json : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
//        let json = JSON(data: data!)
//        println("investHistory:\(json)")
//    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return ProdDetailViewTableList.count
    }
    
    func tableView(tableView:UITableView, numberOfRowsInSection: Int) -> Int{
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 30
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        self.automaticallyAdjustsScrollViewInsets = false
        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        cell.bounds.size.height = 30
        cell.textLabel!.text = "\(ProdDetailViewTableList[indexPath.section])"
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.imageView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
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
        switch(indexPath.section){
        case 0:
            cell.imageView?.image = UIImage(named: "invest.png")
            let home = NSHomeDirectory() as NSString;
            let docPath = home.stringByAppendingPathComponent("Documents") as NSString
            let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
            //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
            var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
            var keyValue: AnyObject? = settingPlist?.valueForKey("ProductCode")
            var localProductCode = keyValue as! String
            var apiValue: AnyObject? = settingPlist?.valueForKey("API")
            var api = apiValue as! String
            var url:NSURL = NSURL(string: "\(api)/product/seniorInvestments/\(localProductCode)")!
            var requrst:NSURLRequest?
            var conn:NSURLConnection?
            requrst=NSURLRequest(URL:url)
            conn=NSURLConnection(request: requrst!,delegate: self)
            var data = NSData(contentsOfURL: url)
            var str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            let json = JSON(data: data!)
            var count = json.count

            cell.detailTextLabel?.text = "已有\(count)人投资"
        case 1:
            cell.imageView?.image = UIImage(named: "performance.png")
        default:
            println("default")
        }
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 5
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("\(indexPath.section)")
        if(indexPath.section == 0){
            performSegueWithIdentifier("ToInvestHistory", sender: AnyObject?())

        }
        else{
            performSegueWithIdentifier("ShowAchieve", sender: AnyObject?())
        }
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
    
    func appointNow(sender: AnyObject) {
        //performSegueWithIdentifier("ToInvest", sender: AnyObject?())
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

        checkLogin()
        if(isLogin){
            performSegueWithIdentifier("ToAppoint", sender: AnyObject?())
        }
        else{
            performSegueWithIdentifier("ToLogin", sender: AnyObject?())
        }
    }
    
    func investNow(sender: AnyObject) {
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

        checkLogin()
        if(isLogin){
            performSegueWithIdentifier("ToInvest", sender: AnyObject?())
        }
        else{
            performSegueWithIdentifier("ToLogin", sender: AnyObject?())
        }
//        var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
//        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath!)
//        var keyValue: AnyObject? = settingPlist?.valueForKey("API")
//        var api = keyValue as! String
//        var params = ["idOrCode":"\(productCode)", "investAmount":"10000", "tradePassword":"huiqiquan", "coupons":""]
//
//        var request = HTTPTask()
//        request.POST("\(api)/product/invest", parameters: params, completionHandler: {(response:HTTPResponse) -> Void in
//            println("\nresponse:\(response)")
//            let json = JSON(response.headers!)
//            println("\nresponseHeader:\(json)")
//            //var pragma = json["Pragma"].string!
//            //println("\n\(pragma)")
//            let success = JSON(response.text!)
//            println("\nresponseText:\(success)")
//            var detailJSON = JSON(data: (response.responseObject as? NSData)!, options: NSJSONReadingOptions.AllowFragments, error: nil)
//            println("\ndetailJSON:\(detailJSON)")
//
//            //var isAuthenticated = detailJSON["isAuthenticated"].bool!
//        })
    }
//    func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
//        cell.bounds.size.height = 10
//        cell.backgroundColor = UIColor.grayColor()
//        return cell
//    }
//    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
//        //let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell        
//        var cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
//        //cell.bounds.size.height = 25
//        cell.textLabel!.text = "\(ProdDetailViewTableList[indexPath.row])"
//        cell.accessoryType = UITableViewCellAccessoryType.None
//        cell.detailTextLabel?.text = "\(ProdDetailViewDetailList[indexPath.row])"
//        cell.imageView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//        cell.imageView?.image = UIImage(named: "5.png")
//        cell.backgroundColor = UIColor.whiteColor()
//        var cell2 = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
//        cell2.bounds.size.height = cell.bounds.size.height + 5
//        cell2.addSubview(cell)
//        cell2.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
//        return cell2
//    }
    
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

        checkLogin()
        if tabBar.selectedItem == Home {
            performSegueWithIdentifier("DetailToHome", sender: AnyObject?())
        }
        else if tabBar.selectedItem == Account{
            if(isLogin == false){
                performSegueWithIdentifier("ToLogin", sender: AnyObject?())
            }
            else{
                performSegueWithIdentifier("DetailToAccount", sender: AnyObject?())
            }
        }
        else if tabBar.selectedItem == More{
            if(isLogin == false){
                performSegueWithIdentifier("ToLogin", sender: AnyObject?())
            }
            else{
                performSegueWithIdentifier("DetailToMore", sender: AnyObject?())
            }
        }
    }
    
    //@IBOutlet var detailViewTable: UITableView!
    @IBOutlet var detailView: UIView!
    @IBOutlet var productName: UILabel!
    @IBOutlet var subLabel: UILabel!
    @IBOutlet var subLabelLeft: UILabel!
    @IBOutlet var subLabelRight: UILabel!
    @IBOutlet var subLabel2: UILabel!
    @IBOutlet var proceedLabel: UILabel!
    @IBOutlet var periodLabel: UILabel!
    @IBOutlet var InstructionLabel1: UILabel!
    @IBOutlet var InstructionLabel2: UILabel!
    @IBOutlet var InstructionLabel3: UILabel!
    @IBOutlet var RuleLabel1: UILabel!
    @IBOutlet var RuleLabel2: UILabel!
    @IBOutlet var RuleLabel3: UILabel!
    @IBOutlet var subView2: UIView!
    @IBOutlet var subView: UIView!
    @IBOutlet var ruleView: UIView!
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var Home: UITabBarItem!
    @IBOutlet var Account: UITabBarItem!
    @IBOutlet var More: UITabBarItem!
}