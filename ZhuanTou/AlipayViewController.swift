//
//  AlipayViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/25.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class AlipayViewController: UIViewController, UITabBarDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor()], forState: UIControlState.Selected)
        tabBar.barTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        Home.image = UIImage(named: "home.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        Home.selectedImage = UIImage(named: "home-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        Account.image = UIImage(named: "account.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        Account.selectedImage = UIImage(named: "account-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        More.image = UIImage(named: "more.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        More.selectedImage = UIImage(named: "more-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        
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
        var amountValue: AnyObject? = settingPlist?.valueForKey("RechargeAmount")
        var amount = amountValue as! String
        var accountValue: AnyObject? = settingPlist?.valueForKey("AlipayAccount")
        var account = accountValue as! String
        rechargeAmount.text = "充值金额：\(account)"
        alipayAccount.text = "您的支付宝账户：\(amount)"
        
        topView.layer.borderColor = UIColor.lightGrayColor().CGColor
        topView.layer.borderWidth = 1
        
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if tabBar.selectedItem == Home {
            performSegueWithIdentifier("AlipayToHome", sender: AnyObject?())
        }
        else if tabBar.selectedItem == Account{
            performSegueWithIdentifier("AlipayToAccount", sender: AnyObject?())
        }
        else if tabBar.selectedItem == More{
            performSegueWithIdentifier("AlipayToMore", sender: AnyObject?())
        }
    }
    
    @IBAction func AlipayAPP(sender: AnyObject) {
        var url = NSURL(string: "http://d.alipay.com")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBAction func AlipayWeb(sender: AnyObject) {
        var url = NSURL(string: "http://shenghuo.alipay.com/send/payment/fill.htm")
        UIApplication.sharedApplication().openURL(url!)
    }
    
    @IBOutlet var topView: UIView!
    @IBOutlet var alipayAccount: UILabel!
    @IBOutlet var rechargeAmount: UILabel!
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var Home: UITabBarItem!
    @IBOutlet var Account: UITabBarItem!
    @IBOutlet var More: UITabBarItem!
}