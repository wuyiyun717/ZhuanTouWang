//
//  ForgetTradePasswordViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/28.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class ForgetTradePasswordViewController: UIViewController{
    var vCodeSuccess = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view1.layer.borderColor = UIColor.lightGrayColor().CGColor
        view1.layer.borderWidth = 1
        view2.layer.borderColor = UIColor.lightGrayColor().CGColor
        view2.layer.borderWidth = 1
        
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
    
    func verifyVCode(){
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
        var vcode = vCodetextField.text
        if(vcode == ""){
            return
        }
        var request = HTTPTask()
        request.POST("\(api)/account/validateSmsCode/\(vcode)", parameters: nil, completionHandler: {(response:HTTPResponse) -> Void in
            var detailJSON = JSON(data: (response.responseObject as? NSData)!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            println("\(detailJSON)")
            if(detailJSON["isSuccess"].bool! == true){
                self.vCodeSuccess = true
            }
        })

        return
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
        if(newPassword.text != confirmPassword.text){
            var addView:UIAlertController = UIAlertController(title: "", message: "两次密码不一致", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                NSLog("OK button")
            }
            addView.addAction(actionOK)
            presentViewController(addView, animated: true, completion: nil)
            return
        }
        else{
            let home = NSHomeDirectory() as NSString;
            let docPath = home.stringByAppendingPathComponent("Documents") as NSString
            let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
            //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
            var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
            var apiValue: AnyObject? = settingPlist?.valueForKey("API")
            var api = apiValue as! String
            var vCode = vCodetextField.text
            var new = newPassword.text
            //println("\(params as! Dictionary<String, AnyObject>)")
            //println(params)
            var request = HTTPTask()
            request.POST("\(api)/account/setTradePassword/\(new)?loginPassword=\(vCode)", parameters: nil, completionHandler: {(response:HTTPResponse) -> Void in
            var detailJSON = JSON(data: (response.responseObject as? NSData)!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            println("\(detailJSON)")
            if(detailJSON["isSuccess"].bool! == true){
                var addView:UIAlertController = UIAlertController(title: "", message: "修改成功", preferredStyle:.Alert)
                let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
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
    
    @IBAction func getVCode(sender: AnyObject) {
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
        verifyVCode()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.resignFirstResponder()
        verifyVCode()
    }
    
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var newPassword: UITextField!
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var vCodetextField: UITextField!
    @IBOutlet var phoneLabel: UILabel!
}
