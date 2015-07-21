//
//  InvestNowViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/29.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class AppointNowViewController: UIViewController, UIWebViewDelegate, UITabBarControllerDelegate{
    var productCode:String = String()
    var isLogin = false
    
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
        checkLogin()
        let home = NSHomeDirectory() as NSString;
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
        let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
        //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
        var apiValue: AnyObject? = settingPlist?.valueForKey("API")
        var productValue: AnyObject? = settingPlist?.valueForKey("ProductCode")
        productCode = productValue as! String
        var api = apiValue as! String
        var url:NSURL = NSURL(string: "\(api)/account")!
        var requrst:NSURLRequest?
        var conn:NSURLConnection?
        requrst=NSURLRequest(URL:url)
        conn=NSURLConnection(request: requrst!,delegate: self)
        
        var data = NSData(contentsOfURL: url)
        let json = JSON(data: data!)
        var remain = json["fundsAvailable"].float!
        amountLabel.text = String(format:"%.2f元", remain)
    }
    
    @IBAction func submit(sender: AnyObject) {
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

        if(investTextField.text == ""){
            var addView:UIAlertController = UIAlertController(title: "", message: "请输入预约投资金额", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                NSLog("OK button")
            }
            addView.addAction(actionOK)
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(addView, animated: true, completion: nil)
            }
        }
        else if(investTextField.text == ""){
            var addView:UIAlertController = UIAlertController(title: "", message: "请输入交易密码", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                NSLog("OK button")
            }
            addView.addAction(actionOK)
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(addView, animated: true, completion: nil)
            }
        }
        else{
            let home = NSHomeDirectory() as NSString;
            let docPath = home.stringByAppendingPathComponent("Documents") as NSString
            let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
            //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
            var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
            var apiValue: AnyObject? = settingPlist?.valueForKey("API")
            var api = apiValue as! String
            var investAmount = (investTextField.text as NSString).floatValue
            var tradePassword = tradePasswordTextField.text
            var params:Dictionary<String, AnyObject> = ["idOrCode":productCode, "investAmount":investAmount, "tradePassword":tradePassword, "coupons":""]
            //println("\(params as! Dictionary<String, AnyObject>)")
            //println(params)
            var request = HTTPTask()
            request.POST("\(api)/product/appoint", parameters: params, completionHandler: {(response:HTTPResponse) -> Void in
                var detailJSON = JSON(data: (response.responseObject as? NSData)!, options: NSJSONReadingOptions.AllowFragments, error: nil)
                println("\(detailJSON)")
                if(detailJSON["isSuccess"].bool! == true){
                    var addView:UIAlertController = UIAlertController(title: "", message: "预约成功", preferredStyle:.Alert)
                    let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                        self.performSegueWithIdentifier("ToDetail", sender: AnyObject?())
                        NSLog("OK button")
                    }
                    addView.addAction(actionOK)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.presentViewController(addView, animated: true, completion: nil)
                    }
                }
                else{
                    var message = detailJSON["errorMessage"].string!
                    var addView:UIAlertController = UIAlertController(title: "", message: message, preferredStyle:.Alert)
                    let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                        NSLog("OK button")
                    }
                    addView.addAction(actionOK)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.presentViewController(addView, animated: true, completion: nil)
                    }
                }
            })
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
    
    @IBAction func hidekeyboard(sender: AnyObject) {
        self.resignFirstResponder()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.resignFirstResponder()
    }
    
    @IBOutlet var tradePasswordTextField: UITextField!
    @IBOutlet var investTextField: UITextField!
    @IBOutlet var amountLabel: UILabel!
}
