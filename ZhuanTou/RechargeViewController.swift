//
//  RechargeViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/25.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class RechargeViewController: UIViewController, UITabBarDelegate{

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
        //Home.setTitleTextAttributes(<#attributes: [NSObject : AnyObject]!#>, forState: <#UIControlState#>)
        
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
        var url:NSURL = NSURL(string: "\(api)/account")!
        var requrst:NSURLRequest?
        var conn:NSURLConnection?
        requrst=NSURLRequest(URL:url)
        conn=NSURLConnection(request: requrst!,delegate: self)
        
        var data = NSData(contentsOfURL: url)
        let json = JSON(data: data!)
        println("\(json)")
        var fund = json["fundsAvailable"].float!
        var str = String(format:"%.2f", fund)
        //var str = "10000000000000.00"
        println("\(str)")
        println("\(str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))")
        fundAvailable.text = "\(str)"
        var title1 = "当前可用余额："
        for(var i = 2; i < str.lengthOfBytesUsingEncoding(NSUTF8StringEncoding); i++){
            title1 = title1 + "  "
        }
        title1 = title1 + " 元"
        println("\(title1)")
        fundTitle.text = title1
        
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if tabBar.selectedItem == Home {
            performSegueWithIdentifier("RechargeToHome", sender: AnyObject?())
        }
        else if tabBar.selectedItem == Account{
            performSegueWithIdentifier("RechargeToAccount", sender: AnyObject?())
        }
        else if tabBar.selectedItem == More{
            performSegueWithIdentifier("RechargeToMore", sender: AnyObject?())
        }
    }
    
    @IBAction func nextStep(sender: AnyObject) {
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
        var amount = (fundTextField.text as NSString).floatValue
        var account = accountTextField.text
        var params:Dictionary<String,AnyObject> = ["ChargeChannel":"0","Amount":amount,"TransferAccount":"\(account)"]
        //println("\(params as! Dictionary<String, AnyObject>)")
        println(params)
        var request = HTTPTask()
        request.POST("\(api)/charge/initiateCharge", parameters: params, completionHandler: {(response:HTTPResponse) -> Void in
            //println("\nresponse:\(response)")
            //let json = JSON(response.headers!)
            //println("\nresponseHeader:\(json)")
            //var pragma = json["Pragma"].string!
            //println("\n\(pragma)")
            //let success = JSON(response.text!)
            //println("\(success)")
            //println("\(response.responseObject)")
            //println("\(response.description)")

            var detailJSON = JSON(data: (response.responseObject as? NSData)!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            println("\(detailJSON)")
            

            //var jsonData = response.text?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            //let json = JSON(data:jsonData!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            //var errMessage = json["errorMessage"].string
            //println("\nresponseHeader:\(json)")
            //println("\(errMessage!)")
            
            //NSNotificationCenter.defaultCenter().postNotificationName("errorMessageGet", object: errMessage)
            //self.errorMessage.text = errMessage!
            //self.errorMessage.setNeedsDisplay()
            //self.errorMessage.setNeedsLayout()
            //dispatch_async(dispatch_get_main_queue()) {
            //    self.performSegueWithIdentifier("ToRegFinal", sender: AnyObject?())
            //}
        })
        settingPlist?.setValue(self.fundTextField.text, forKey: "RechargeAmount")
        settingPlist?.writeToFile(plistPath, atomically: true)
        settingPlist?.setValue(self.accountTextField.text, forKey: "AlipayAccount")
        settingPlist?.writeToFile(plistPath, atomically: true)
        performSegueWithIdentifier("ToAlipay", sender: AnyObject?())
    }

    @IBAction func hidekeyboard(sender: AnyObject) {
        self.resignFirstResponder()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.resignFirstResponder()
    }
    
    @IBOutlet var fundTitle: UILabel!
    @IBOutlet var fundTextField: UITextField!
    @IBOutlet var accountTextField: UITextField!
    @IBOutlet var fundAvailable: UILabel!
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var Home: UITabBarItem!
    @IBOutlet var Account: UITabBarItem!
    @IBOutlet var More: UITabBarItem!

}