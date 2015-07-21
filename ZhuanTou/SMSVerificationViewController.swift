//
//  SMSVerificationViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/7.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class SMSVerificationViewController: UIViewController {
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
        vCodeView.layer.borderColor = UIColor(red: 153/255, green: 152/255, blue: 157/255, alpha: 1).CGColor
        vCodeView.layer.borderWidth = 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func enterTextCode(sender: AnyObject) {
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
        var phone:AnyObject? = settingPlist?.valueForKey("Phone") as! String
        var vCode:AnyObject? = settingPlist?.valueForKey("vCode") as! String
        var request = HTTPTask()
        request.POST("\(api)/account/registerSmsCode/\(phone)/\(vCode)", parameters: nil, completionHandler: {(response:HTTPResponse) -> Void in
            println("\nresponse:\(response)")
            //println("\nresponse:\(response.headers)")
            var jsonData = response.text?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            let json = JSON(data:jsonData!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            //var errMessage = json["errorMessage"].string
            println("\nresponseHeader:\(json)")
            //println("\(errMessage!)")
            
            //NSNotificationCenter.defaultCenter().postNotificationName("errorMessageGet", object: errMessage)
            //self.errorMessage.text = errMessage!
            //self.errorMessage.setNeedsDisplay()
            //self.errorMessage.setNeedsLayout()
            //dispatch_async(dispatch_get_main_queue()) {
                self.performSegueWithIdentifier("ToRegFinal", sender: AnyObject?())
            //}
        })

    }
    
    @IBAction func hidekeyboard(sender: AnyObject) {
        self.resignFirstResponder()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.resignFirstResponder()
    }
    
    @IBOutlet var textCode: UITextField!
    @IBOutlet var vCodeView: UIView!
}