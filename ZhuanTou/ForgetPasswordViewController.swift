//
//  ForgetPasswordViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/7/1.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class ForgetPasswordViewController: UIViewController{
    var vCodeSuccess = false
    var textVCodeIsSent = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view1.layer.borderColor = UIColor.lightGrayColor().CGColor
        view1.layer.borderWidth = 1
        view2.layer.borderColor = UIColor.lightGrayColor().CGColor
        view2.layer.borderWidth = 1
        view3.layer.borderColor = UIColor.lightGrayColor().CGColor
        view3.layer.borderWidth = 1
        view4.layer.borderColor = UIColor.lightGrayColor().CGColor
        view4.layer.borderWidth = 1
        view5.layer.borderColor = UIColor.lightGrayColor().CGColor
        view5.layer.borderWidth = 1
//        var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
//        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath!)
//        var apiValue: AnyObject? = settingPlist?.valueForKey("API")
//        var api = apiValue as! String
//        var url:NSURL = NSURL(string: "\(api)/account")!
//        var requrst:NSURLRequest?
//        var conn:NSURLConnection?
//        requrst=NSURLRequest(URL:url)
//        conn=NSURLConnection(request: requrst!,delegate: self)
//        
//        var data = NSData(contentsOfURL: url)
//        let json = JSON(data: data!)
//        var phone = json["mobilePhone"].string!
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
        var keyValue: AnyObject? = settingPlist?.valueForKey("WithoutAPI")
        var withoutAPI = keyValue as! String
        phoneNumber.text = settingPlist?.valueForKey("Phone") as! String
        var imageData:NSData? = NSData(contentsOfURL: NSURL(string: "\(withoutAPI)/Account/GetValidateCode")!)
        if imageData != nil {
            validateCodeImage.image = UIImage(data: imageData!)
        }
        else{
            var addView:UIAlertController = UIAlertController(title: "", message: "网络异常", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                NSLog("OK button")
                self.performSegueWithIdentifier("backToLogin", sender: AnyObject?())
            }
            addView.addAction(actionOK)
        }
        newPassword.enabled = false
        confirmPassword.enabled = false
    }
    
    func verifyVCode(){
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
                self.newPassword.enabled = true
                self.confirmPassword.enabled = true
            }
            else{
                self.vCodeSuccess = false
                self.newPassword.enabled = false
                self.confirmPassword.enabled = false
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

        if(textVCodeIsSent == false){
            var addView:UIAlertController = UIAlertController(title: "", message: "未验证的手机", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                NSLog("OK button")
            }
            addView.addAction(actionOK)
            presentViewController(addView, animated: true, completion: nil)
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
            println("\(api)/account/forgetPassword/\(new)/\(vCode)")
            request.POST("\(api)/account/forgetPassword/\(new)/\(vCode)", parameters: nil, completionHandler: {(response:HTTPResponse) -> Void in
                var detailJSON = JSON(data: (response.responseObject as? NSData)!, options: NSJSONReadingOptions.AllowFragments, error: nil)
                if(detailJSON["errorMessage"].string! == "当前用户未被授权执行当前操作"){
                    var addView:UIAlertController = UIAlertController(title: "", message: "您已登录，请先退出", preferredStyle:.Alert)
                    let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                        self.performSegueWithIdentifier("backToLogin", sender: AnyObject?())
                    }
                    addView.addAction(actionOK)
                    dispatch_async(dispatch_get_main_queue()) {
                        self.presentViewController(addView, animated: true, completion: nil)
                    }
                }
                if(detailJSON["isSuccess"].bool! == true){
                    var addView:UIAlertController = UIAlertController(title: "", message: "修改成功", preferredStyle:.Alert)
                    let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                        self.performSegueWithIdentifier("backToLogin", sender: AnyObject?())
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

        let home = NSHomeDirectory() as NSString
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
        let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
        //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
        var apiValue: AnyObject? = settingPlist?.valueForKey("API")
        var api = apiValue as! String
        //println("\(params as! Dictionary<String, AnyObject>)")
        //println(params)
        var phone = phoneNumber.text
        var imageVCode = imageVCodeTextfield.text
        if(phone == ""){
            var addView:UIAlertController = UIAlertController(title: "", message: "请输入手机号码", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                NSLog("OK button")
            }
            addView.addAction(actionOK)
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(addView, animated: true, completion: nil)
            }
            return
        }
        if(imageVCode == ""){
            var addView:UIAlertController = UIAlertController(title: "", message: "请输入图片验证码", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                NSLog("OK button")
            }
            addView.addAction(actionOK)
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(addView, animated: true, completion: nil)
            }
            return
        }
        var request = HTTPTask()
        request.POST("\(api)/account/sendSmsCodeForResetPassword/\(phone)/\(imageVCode)", parameters: nil, completionHandler: {(response:HTTPResponse) -> Void in
            var detailJSON = JSON(data: (response.responseObject as? NSData)!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            println("\(detailJSON)")
            if(detailJSON["isSuccess"].bool! == true){
                self.textVCodeIsSent = true
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
    
    @IBAction func hidekeyboard(sender: AnyObject) {
        self.resignFirstResponder()
        verifyVCode()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.resignFirstResponder()
        verifyVCode()
    }
    
    @IBOutlet var validateCodeImage: UIImageView!
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var imageVCodeTextfield: UITextField!
    @IBOutlet var confirmPassword: UITextField!
    @IBOutlet var newPassword: UITextField!
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var view4: UIView!
    @IBOutlet var view5: UIView!
    @IBOutlet var vCodetextField: UITextField!
}
