//
//  LoginViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/1.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UITabBarDelegate{
    var phoneField:UITextField! = UITextField()
    var passwordField:UITextField! = UITextField()
    
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
        login.enabled = true
        phoneView.layer.borderColor = UIColor(red: 153/255, green: 152/255, blue: 157/255, alpha: 1).CGColor
        phoneView.layer.borderWidth = 1
        passwordView.layer.borderColor = UIColor(red: 153/255, green: 152/255, blue: 157/255, alpha: 1).CGColor
        passwordView.layer.borderWidth = 1
        // Do any additional setup after loading the view, typically from a nib.
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
        if (data != nil){
            var str = NSString(data: data!, encoding: NSUTF8StringEncoding)
            //var json : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            let json = JSON(data: data!)
            var isLogin = json["isAuthenticated"].bool!
            if(isLogin == true){
                var addView:UIAlertController = UIAlertController(title: "", message: "您已登录", preferredStyle:.Alert)
                let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                    self.performSegueWithIdentifier("LoginSuccess", sender: AnyObject?())
                }
                addView.addAction(actionOK)
                login.enabled = true
                presentViewController(addView, animated: true, completion: nil)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginButton(sender: AnyObject) {
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

        var phoneNO = name.text
        var passWord = password.text
        login.enabled = false
        var params = ["login": phoneNO, "password": passWord]
        if (phoneNO == ""){
            var addView:UIAlertController = UIAlertController(title: "", message: "请输入手机号", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                NSLog("OK button")
            }
            addView.addAction(actionOK)
            login.enabled = true
            presentViewController(addView, animated: true, completion: nil)
            return
        }
        if (passWord == ""){
            var addView:UIAlertController = UIAlertController(title: "", message: "请输入密码", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                NSLog("OK button")
            }
            addView.addAction(actionOK)
            login.enabled = true
            presentViewController(addView, animated: true, completion: nil)
            return
        }
        let home = NSHomeDirectory() as NSString;
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
        let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
        //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
        var keyValue: AnyObject? = settingPlist?.valueForKey("API")
        var api = keyValue as! String
        
        var request = HTTPTask()
        request.POST("\(api)/auth/signIn", parameters: params, completionHandler: {(response:HTTPResponse) -> Void in
            println("\nresponse:\(response)")
            //let json = JSON(response.headers!)
            //var pragma = json["Pragma"].string!
            //println("\n\(pragma)")
            //let success = JSON(response.text!)
            //println("\(success)")
            var detailJSON = JSON(data: (response.responseObject as? NSData)!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            var isAuthenticated = detailJSON["isAuthenticated"].bool!
            if (detailJSON["isAuthenticated"].bool == false){
                var failMessage = detailJSON["errorMessage"].string!
                var warnAlert:UIAlertController = UIAlertController(title: "", message: failMessage, preferredStyle: .Alert)
                let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                    NSLog("OK button")
                }
                warnAlert.addAction(actionOK)
                dispatch_async(dispatch_get_main_queue()) {
                    self.login.enabled = true
                    self.presentViewController(warnAlert, animated: true, completion: nil)
                }

            }
            else{
                dispatch_async(dispatch_get_main_queue()) {
                    var login:Bool = true
                    settingPlist?.setValue(login, forKey: "Login")
                    settingPlist?.writeToFile(plistPath, atomically: true)
                    self.performSegueWithIdentifier("LoginSuccess", sender: AnyObject?())
                }
            }
            println("\(isAuthenticated)")
        })

    }
    
    @IBAction func hidekeyboard(sender: AnyObject) {
        self.resignFirstResponder()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.resignFirstResponder()
    }
    
    @IBOutlet var backButton: UIBarButtonItem!
    @IBOutlet var name: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var phoneView: UIView!
    @IBOutlet var passwordView: UIView!
    @IBOutlet var login: UIButton!
}
