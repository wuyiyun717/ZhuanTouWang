//
//  InvestNowViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/29.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class InvestNowViewController: UIViewController, UIWebViewDelegate, UITabBarControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    var productCode:String = String()
    var myCoupons:NSMutableArray = NSMutableArray()
    var isLogin = true
    var check:CheckBox = CheckBox(frame: CGRectMake(300, 230, 120, 30))
    
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
        if(isLogin == false){
            performSegueWithIdentifier("ToLogin", sender: AnyObject?())
        }
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
        
        var urlCoupon:NSURL = NSURL(string: "\(api)/account/MyCoupons")!
        var requrstCoupon:NSURLRequest?
        var connCoupon:NSURLConnection?
        requrstCoupon=NSURLRequest(URL:urlCoupon)
        connCoupon=NSURLConnection(request: requrstCoupon!,delegate: self)
        
        var dataCoupon = NSData(contentsOfURL: urlCoupon)
        let jsonCoupon = JSON(data: dataCoupon!)
        var count = jsonCoupon.count
        for(var i = 0; i < count; i++){
            myCoupons.addObject(jsonCoupon[i]["couponCode"].string!)
        }
        couponPicker.delegate = self
        if count > 0 {
            couponPicker.selectRow(0, inComponent: 0, animated: true)
        }
        couponView.addSubview(couponPicker)
        couponView.clipsToBounds = true
        
        
        check.setTitle("", forState: UIControlState.Normal)
        check.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.view.addSubview(check)
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
//    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        var attribute = [NSFontAttributeName: UIFont.systemFontOfSize(8.0)]
//        //var str = NSAttributedString(string: myCoupons[row] as! String)
//        var str = NSAttributedString(string: myCoupons[row] as! String, attributes:attribute)
//        return str
//        
//    }
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
        label.text = myCoupons[row] as? String
        label.font = UIFont.systemFontOfSize(12)

        return label
    }
//    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
//        return myCoupons[row] as! String
//    }
    func numberOfComponentsInPickerView( pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int{
        return myCoupons.count
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
            var mycoupon = ""
            if myCoupons.count > 0 {
                if(check.isChecked == true){
                    var mycoupon = myCoupons[couponPicker.selectedRowInComponent(0)] as! String
                }
            }
            var params:Dictionary<String, AnyObject> = ["idOrCode":productCode, "investAmount":investAmount, "tradePassword":tradePassword, "coupons":mycoupon]
            //println("\(params as! Dictionary<String, AnyObject>)")
            //println(params)
            var request = HTTPTask()
            request.POST("\(api)/product/invest", parameters: params, completionHandler: {(response:HTTPResponse) -> Void in
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
            })
        }
    }
    
    @IBAction func hidekeyboard(sender: AnyObject) {
        self.resignFirstResponder()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.resignFirstResponder()
    }
    
    @IBOutlet var couponView: UIView!
    @IBOutlet var couponPicker: UIPickerView!
    @IBOutlet var tradePasswordTextField: UITextField!
    @IBOutlet var investTextField: UITextField!
    @IBOutlet var amountLabel: UILabel!
}
