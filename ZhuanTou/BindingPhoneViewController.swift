//
//  BindingPhoneViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/2.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class BindingPhoneViewController: UIViewController{
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
        var phone = json["mobilePhone"].string!
        phoneLabel.text = "您的手机号码：\(phone)"
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
        var vcode = vCodeTextField.text
        if (vcode == ""){
            var addView:UIAlertController = UIAlertController(title: "", message: "请输入验证码", preferredStyle:.Alert)
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
            var request = HTTPTask()
            request.POST("\(api)/account/validateSmsCode/\(vcode)", parameters: nil, completionHandler: {(response:HTTPResponse) -> Void in
                var detailJSON = JSON(data: (response.responseObject as? NSData)!, options: NSJSONReadingOptions.AllowFragments, error: nil)
                println("\(detailJSON)")
                if(detailJSON["isSuccess"].bool! == true){
                    dispatch_async(dispatch_get_main_queue()) {
                        self.performSegueWithIdentifier("ToStep2", sender: AnyObject?())
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
    
    @IBAction func getVcode(sender: AnyObject) {
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
        //println("\(params as! Dictionary<String, AnyObject>)")
        //println(params)
        var request = HTTPTask()
        request.POST("\(api)/account/sendSmsCodeForResetMobile", parameters: nil, completionHandler: {(response:HTTPResponse) -> Void in
            var detailJSON = JSON(data: (response.responseObject as? NSData)!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            println("\(detailJSON)")
            
        })

    }
    
    @IBAction func hidekeyboard(sender: AnyObject) {
        self.resignFirstResponder()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.resignFirstResponder()
    }
    
    @IBOutlet var vCodeTextField: UITextField!
    @IBOutlet var phoneLabel: UILabel!
}