//
//  RegFinalViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/11.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class RegFinalViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if(!IJReachability.isConnectedToNetwork()){
            var addView:UIAlertController = UIAlertController(title: "", message: "请检查网络状态", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                self.viewDidLoad()

            }
            addView.addAction(actionOK)
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(addView, animated: true, completion: nil)
            }
        }
        view1.layer.borderColor = UIColor(red: 153/255, green: 152/255, blue: 157/255, alpha: 1).CGColor
        view1.layer.borderWidth = 1
        view2.layer.borderColor = UIColor(red: 153/255, green: 152/255, blue: 157/255, alpha: 1).CGColor
        view2.layer.borderWidth = 1
        view3.layer.borderColor = UIColor(red: 153/255, green: 152/255, blue: 157/255, alpha: 1).CGColor
        view3.layer.borderWidth = 1
        view4.layer.borderColor = UIColor(red: 153/255, green: 152/255, blue: 157/255, alpha: 1).CGColor
        view4.layer.borderWidth = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func finishRegist(sender: AnyObject) {
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
        var name:String? = nameField.text
        var phone:AnyObject? = settingPlist?.valueForKey("Phone") as! String
        var pass:String? = password.text
        var vPass:String? = verifyPassword.text
        var smsCode:AnyObject? = settingPlist?.valueForKey("vCode") as! String
        var reCode = recommendCode.text
        var params = ["username":"\(name)", "mobile":"\(phone)", "password":"\(pass)", "confirmPassword":"\(vPass)", "smsCode":"\(smsCode)", "referrerCode":"\(reCode)"]
        var request = HTTPTask()
        request.POST("\(api)/account/register", parameters: params, completionHandler: {(response:HTTPResponse) -> Void in
            println("\nresponse:\(response)")
            //let json = JSON(response.headers!)
            //println("\nresponseHeader:\(json)")
            //var pragma = json["Pragma"].string!
            //println("\n\(pragma)")
            var detailJSON = JSON(data: (response.responseObject as? NSData)!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            println("\(detailJSON)")
            if(detailJSON["isSuccess"].bool! == true){
                var addView:UIAlertController = UIAlertController(title: "", message: "投资成功", preferredStyle:.Alert)
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
    }
    
    @IBAction func hidekeyboard(sender: AnyObject) {
        self.resignFirstResponder()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.resignFirstResponder()
    }
    
    @IBOutlet var nameField: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var verifyPassword: UITextField!
    @IBOutlet var recommendCode: UITextField!
    @IBOutlet var errorMessage: UILabel!
    @IBOutlet var view1: UIView!
    @IBOutlet var view2: UIView!
    @IBOutlet var view3: UIView!
    @IBOutlet var view4: UIView!

}
