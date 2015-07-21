//
//  RegViewContoller.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/1.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class RegViewController: UIViewController{
    //@IBOutlet var phoneImage: UIImageView!

    
    var vCodeSuccess = false
    var phoneNOSuccess = false
    var canPushViewNow = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //vCodeSuccess = false
        //phoneNOSuccess = false
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
        verifyMobile()
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
            validateCode.image = UIImage(data: imageData!)
        }
        else{
            var addView:UIAlertController = UIAlertController(title: "", message: "网络异常", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                self.performSegueWithIdentifier("backToLogin", sender: AnyObject?())
            }
            addView.addAction(actionOK)
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeErrorMessage:", name: "errorMessageGet", object: nil)
        phoneView.layer.borderColor = UIColor(red: 153/255, green: 152/255, blue: 157/255, alpha: 1).CGColor
        phoneView.layer.borderWidth = 1
        vCodeView.layer.borderColor = UIColor(red: 153/255, green: 152/255, blue: 157/255, alpha: 1).CGColor
        vCodeView.layer.borderWidth = 1
        //errorMessage.text = "234556"

    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.resignFirstResponder()
        verifyMobile()
    }
    
    func verifyMobile(){
        let home = NSHomeDirectory() as NSString;
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
        let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
        //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
        var keyValue: AnyObject? = settingPlist?.valueForKey("API")
        var api = keyValue as! String
        var request = HTTPTask()
        var errMessage:String?
        var isSuccess:Bool?
        request.POST("\(api)/account/checkMobile/\(phoneNumber.text)", parameters: nil, completionHandler: {(response:HTTPResponse) -> Void in
            println("\nverifyMobile:\(response)")
            println("\nverifyMobile:\(response.headers)")
            
            var jsonData = response.text?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            let json = JSON(data:jsonData!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            errMessage = json["errorMessage"].string
            isSuccess = json["isSuccess"].bool
            
            println("\nverifyMobile:\(json)")
            //NSNotificationCenter.defaultCenter().postNotificationName("errorMessageGet", object: errMessage)
            
            //println("\(errMessage!)")
            
//            if(errMessage != ""){
//                var addView:UIAlertController = UIAlertController(title: "", message: errMessage, preferredStyle:.Alert)
//                let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
//                    NSLog("OK button")
//                }
//                addView.addAction(actionOK)
//                self.presentViewController(addView, animated: true, completion: nil)
//                
//            }
            
            dispatch_async(dispatch_get_main_queue()) {
                if(isSuccess == false){
                    self.errorMessage.text = errMessage
                }
                else{
                    self.errorMessage.text = ""
                }
                self.phoneNOSuccess = json["isSuccess"].boolValue
                if(self.phoneNOSuccess == false){
                    self.canPushViewNow = false
                }
                self.shouldPushView()
            }
            if(isSuccess == true){
                self.verifyVCode()
            }
        })
    }
    
    func verifyVCode(){
        let home = NSHomeDirectory() as NSString;
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
        let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
        //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
        var keyValue: AnyObject? = settingPlist?.valueForKey("API")
        var api = keyValue as! String
        var request = HTTPTask()
        var errMessage:String?
        var isSuccess:Bool?
        request.POST("\(api)/account/checkVCode/\(vCode.text)", parameters: nil, completionHandler: {(response:HTTPResponse) -> Void in
            println("\nverifyVCode:\(response)")
            //println("\nresponse:\(response.headers)")
            var jsonData = response.text?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
            let json = JSON(data:jsonData!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            errMessage = json["errorMessage"].string
            isSuccess = json["isSuccess"].bool

            println("\nverifyVCode:\(json)")
            //println("\(errMessage!)")
            
            //NSNotificationCenter.defaultCenter().postNotificationName("errorMessageGet", object: errMessage)
            //self.errorMessage.text = errMessage!
            //self.errorMessage.setNeedsDisplay()
            //self.errorMessage.setNeedsLayout()
//            if(errMessage != ""){
//                var addView:UIAlertController = UIAlertController(title: "", message: errMessage, preferredStyle:.Alert)
//                let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
//                    NSLog("OK button")
//                }
//                addView.addAction(actionOK)
//                self.presentViewController(addView, animated: true, completion: nil)
//                
//            }
            dispatch_async(dispatch_get_main_queue()) {
                if(isSuccess == false || isSuccess == nil){
                    if(self.phoneNOSuccess == true){
                        self.errorMessage.text = errMessage
                    }
                }
                else{
                    self.errorMessage.text = ""
                }
                self.vCodeSuccess = json["isSuccess"].boolValue
                if(self.vCodeSuccess == false){
                    self.canPushViewNow = false
                }
                self.shouldPushView()
            }
        })
    }
    
    func shouldPushView(){
        if(canPushViewNow && vCodeSuccess && phoneNOSuccess){
            let home = NSHomeDirectory() as NSString;
            let docPath = home.stringByAppendingPathComponent("Documents") as NSString
            let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
            //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
            var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
            var phone = phoneNumber.text
            var vC = vCode.text
            settingPlist?.setValue(phone, forKey: "Phone")
            settingPlist?.setValue(vC, forKey: "vCode")
            settingPlist?.writeToFile(plistPath, atomically: true)

            self.performSegueWithIdentifier("RegToSMS", sender: AnyObject?())
        }
    }
    
    func changeErrorMessage(errMessage: NSNotification){
        var em = errMessage.object as? String
        if(em != ""){
            self.errorMessage.text = em
            self.errorMessage.setNeedsDisplay()
        }
    }
    
    @IBAction func RegButton(sender: AnyObject) {
//        if(phoneNumber.text == ""){
//            dispatch_async(dispatch_get_main_queue()) {
//                self.errorMessage.text = "请输入电话号码"
//            }
//        }
//        else if(vCode.text == ""){
//            dispatch_async(dispatch_get_main_queue()) {
//                self.errorMessage.text = "请输入验证码"
//            }
//        }
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

        var phoneNO = phoneNumber.text
        var verifyCode = vCode.text
        if (phoneNO == ""){
            var addView:UIAlertController = UIAlertController(title: "", message: "请输入手机号", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                NSLog("OK button")
            }
            addView.addAction(actionOK)
            presentViewController(addView, animated: true, completion: nil)
            return
        }
        if (verifyCode == ""){
            var addView:UIAlertController = UIAlertController(title: "", message: "请输入验证码", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                NSLog("OK button")
            }
            addView.addAction(actionOK)
            presentViewController(addView, animated: true, completion: nil)
            return
        }
        verifyMobile()
        canPushViewNow = true
        shouldPushView()
//        var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
//        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath!)
//        var keyValue: AnyObject? = settingPlist?.valueForKey("API")
//        //var api = keyValue as! String
//        if(vCodeSuccess && phoneNOSuccess){
//            var phone = phoneNumber.text
//            var vC = vCode.text
//            settingPlist?.setValue(phone, forKey: "Phone")
//            settingPlist?.setValue(vC, forKey: "vCode")
//            settingPlist?.writeToFile(plistPath!, atomically: true)
//            self.performSegueWithIdentifier("RegToSMS", sender: AnyObject?())
//        }
        //var url:NSURL = NSURL(string: "\(api)/account/checkMobile/\(phoneNumber.text)")!
        //println(url)
        //var requrst:NSURLRequest?
        //var conn:NSURLConnection?
        //requrst=NSURLRequest(URL:url)
        //conn=NSURLConnection(request: requrst!,delegate: self)
        //println(conn)
        //var url2 = NSURL(string: "http://www.pujintianxia.com/api/product/orderedAll")
        //var data = NSData(contentsOfURL: url)
        //var str = NSString(data: data!, encoding: NSUTF8StringEncoding)
        //var json : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        //let json = JSON(data: data!)
//        if let productName = json["dataList"][0]["productName"].string{
//            println(productName)
//            //Now you got your value
//        }
        //println(str)
        
//        var request = HTTPTask()
//        request.POST("\(api)/account/checkMobile/\(phoneNumber.text)", parameters: nil, completionHandler: {(response:HTTPResponse) -> Void in
//            println("\nresponse:\(response)")
//            println("\nresponse:\(response.headers)")
//
//            let json = JSON(response.text!)
//            println("\nresponseHeader:\(json)")
//            //println("\n\(pragma)")
//        })
//        request.POST("\(api)/account/checkVCode/\(vCode.text)", parameters: nil, completionHandler: {(response:HTTPResponse) -> Void in
//                println("\nresponse:\(response)")
//                //println("\nresponse:\(response.headers)")
//                var jsonData = response.text?.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
//                let json = JSON(data:jsonData!, options: NSJSONReadingOptions.AllowFragments, error: nil)
//                var errMessage = json["errorMessage"].string
//                
//                println("\nresponseHeader:\(json)")
//                //println("\(errMessage!)")
//                
//                //NSNotificationCenter.defaultCenter().postNotificationName("errorMessageGet", object: errMessage)
//                //self.errorMessage.text = errMessage!
//                //self.errorMessage.setNeedsDisplay()
//                //self.errorMessage.setNeedsLayout()
//                dispatch_async(dispatch_get_main_queue()) {
//                    self.errorMessage.text = errMessage
//                }
//        })
        
    }
    
    @IBAction func LogOut(sender: AnyObject) {
        var request = HTTPTask()
        request.GET("http://test.pujintianxia.com/Account/SignOut", parameters: nil, completionHandler: {(response:HTTPResponse) -> Void in
            println("log out")
            
        })
    }
    
    @IBAction func hidekeyboard(sender: AnyObject) {
        self.resignFirstResponder()
        verifyMobile()
    }
    
    @IBOutlet var phoneNumber: UITextField!
    @IBOutlet var vCode: UITextField!
    @IBOutlet var validateCode: UIImageView!
    @IBOutlet var errorMessage: UILabel!
    @IBOutlet var phoneView: UIView!
    @IBOutlet var vCodeView: UIView!
}