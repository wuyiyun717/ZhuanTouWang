//
//  FirstViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/1.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController, UIScrollViewDelegate{
    //var delegate: UIScrollViewDelegate?
    
    @IBOutlet var loginButton: UIButton!
    @IBOutlet var startButton: UIButton!
    var scrollview:UIScrollView!
    var pageControl:UIPageControl!
    var width:CGFloat!
    var hight:CGFloat!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if(!IJReachability.isConnectedToNetwork()){
            var addView:UIAlertController = UIAlertController(title: "", message: "请检查网络状态", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
            }
            addView.addAction(actionOK)
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(addView, animated: true, completion: nil)
            }
            return
        }
        
        var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath!)
        let home = NSHomeDirectory() as NSString;
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
        let filePath = docPath.stringByAppendingPathComponent("Setting.plist")
        settingPlist!.writeToFile(filePath, atomically: true)
        var settingPlistNew = NSMutableDictionary(contentsOfFile: filePath)

        var keyValue: AnyObject? = settingPlistNew?.valueForKey("FirstLogin")
        var firstLogin = keyValue as! Bool
        startButton.hidden = true
        loginButton.hidden = true
        if  firstLogin {
            print("TRUE")
            width=self.view.bounds.size.width
            hight=self.view.bounds.size.height - 20
            scrollview = UIScrollView(frame: CGRect(x: 0, y: 20, width: width, height: hight))
            scrollview.delegate = self
            for (var i=1; i<4; i++) {
                var fileName:NSString = "."
                if i < 4{
                    fileName = "00\(i).jpg"
                }
                var imageView = UIImageView(image: UIImage(named: fileName as String))
                var newWidth = width * CGFloat(i - 1)
                imageView.frame = CGRect(x: newWidth, y: 0, width: width, height: hight)
                scrollview.addSubview(imageView)
            }
            scrollview.contentSize = CGSizeMake(width*4, hight)
            scrollview.bounces = false
            
            //滚动时是否水平显示滚动条
            scrollview.showsHorizontalScrollIndicator = false
            scrollview.showsVerticalScrollIndicator = false
            //分页显示
            scrollview.pagingEnabled = true
            
            
            //pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 460, 320, 20)];
            pageControl = UIPageControl(frame: CGRect(x: 0, y: hight - 50, width: width, height: 20))
            //[pageControl setBackgroundColor:[UIColor clearColor]];
            pageControl.backgroundColor = UIColor.clearColor()
            pageControl.currentPage = 0;
            pageControl.numberOfPages = 3;
            
            //[pageControl addTarget:self action:@selector(click) forControlEvents:UIControlEventValueChanged];
            //pageControl.targetForAction(@selector(click), withSender: AnyObject)
            
            //[self.view addSubview:scrollview];
            //scrollview.backgroundColor = UIColor(red: 230, green: 126, blue: 34, alpha: 0)
            self.view.addSubview(scrollview)
            //[self.view addSubview:pageControl];
            self.view.addSubview(pageControl)
        }
        else {
            print("FALSE")
            startButton.hidden = false
            loginButton.hidden = false
            firstLogin = false
            settingPlist?.setValue(firstLogin, forKey: "FirstLogin")
            settingPlist?.writeToFile(plistPath!, atomically: true)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
        //println(plistPath)
        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath!)
        let home = NSHomeDirectory() as NSString;
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
        let filePath = docPath.stringByAppendingPathComponent("Setting.plist")
        var keyValue: AnyObject? = settingPlist?.valueForKey("FirstLogin")
        var firstLogin = keyValue as! Bool
        if  !firstLogin {
            //performSegueWithIdentifier("toReg", sender: self)
            
        }
        firstLogin = false
        settingPlist?.setValue(firstLogin, forKey: "FirstLogin")
        settingPlist?.writeToFile(plistPath!, atomically: true)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollViewDidEndDecelerating(scrollView:UIScrollView) {
        var index = scrollview.contentOffset.x/width
        //pageControl(setCurrentPage:index)
        pageControl.currentPage = Int(index)
        println(index)
        if Int(index) == 3 {
            print("Page to login view.")
            //segueForUnwindingToViewController(RegTabBarController(), fromViewController: ViewController(), identifier: "toReg")
            //scrollview.backgroundColor = UIColor(red: 230, green: 126, blue: 34, alpha: 1.0)
            //startButton.backgroundColor = UIColor(red: 230, green: 126, blue: 34, alpha: 0)
            performSegueWithIdentifier("ToHome", sender: self)

            //performSegueWithIdentifier("toReg", sender: self)
        }
        else{
            print("Page .")
            startButton.hidden = true
            loginButton.hidden = true

        }
    }
}
