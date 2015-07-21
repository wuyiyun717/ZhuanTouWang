//
//  RealNameViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/2.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class RealNameViewController: UIViewController{
    var creditOK = false
    
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
        view1.layer.borderColor = UIColor.lightGrayColor().CGColor
        view1.layer.borderWidth = 1
        view2.layer.borderColor = UIColor.lightGrayColor().CGColor
        view2.layer.borderWidth = 1
        
    }
    
    func checkCredit(){
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
        var request = HTTPTask()
        var credit = creditNOTextField.text
        request.POST("\(api)/account/checkIdCode/\(credit)", parameters: nil, completionHandler: {(response:HTTPResponse) -> Void in
            var detailJSON = JSON(data: (response.responseObject as? NSData)!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            //println("\(detailJSON)")
            if(detailJSON["isSuccess"].bool! == true){
                self.creditOK = true
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
            self.shouldSubmit()
        })
    }
    
    func shouldSubmit(){
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
        if(creditOK){
            let home = NSHomeDirectory() as NSString;
            let docPath = home.stringByAppendingPathComponent("Documents") as NSString
            let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
            //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
            var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
            var apiValue: AnyObject? = settingPlist?.valueForKey("API")
            var api = apiValue as! String
            var request = HTTPTask()
            var credit = creditNOTextField.text
            var name = nameTextField.text
            if (name == ""){
                var addView:UIAlertController = UIAlertController(title: "", message: "请输入真实姓名", preferredStyle:.Alert)
                let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                    NSLog("OK button")
                }
                addView.addAction(actionOK)
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(addView, animated: true, completion: nil)
                }
            }
            if (credit.lengthOfBytesUsingEncoding(NSUTF8StringEncoding) != 18){
                var addView:UIAlertController = UIAlertController(title: "", message: "请输入正确的身份证号", preferredStyle:.Alert)
                let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                    NSLog("OK button")
                }
                addView.addAction(actionOK)
                dispatch_async(dispatch_get_main_queue()) {
                    self.presentViewController(addView, animated: true, completion: nil)
                }
            }
            request.POST("\(api)/account/setIdCard/\(credit)/\(name)", parameters: nil, completionHandler: {(response:HTTPResponse) -> Void in
                var detailJSON = JSON(data: (response.responseObject as? NSData)!, options: NSJSONReadingOptions.AllowFragments, error: nil)
                if(detailJSON["isSuccess"].bool! == true){
                    var addView:UIAlertController = UIAlertController(title: "", message: "认证成功", preferredStyle:.Alert)
                    let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                        self.performSegueWithIdentifier("ToMore", sender: AnyObject?())
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

            //self.performSegueWithIdentifier("RegToSMS", sender: AnyObject?())
        }
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
        checkCredit()
        shouldSubmit()
    }
    
    @IBAction func hidekeyboard(sender: AnyObject) {
        self.resignFirstResponder()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.resignFirstResponder()
    }
    
    @IBOutlet var creditNOTextField: UITextField!
    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!

}