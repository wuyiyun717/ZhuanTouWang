//
//  NetworkThread.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/7/8.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class NetworkThread:UIAlertController{
    
    func checkNetwork(){

    }
    
    func test(){
    do{
    if(!IJReachability.isConnectedToNetwork()){
    var addView:UIAlertController = UIAlertController(title: "", message: "请检查网络状态", preferredStyle:.Alert)
    let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
    return
    }
    addView.addAction(actionOK)
    var currentViewController:UIViewController = UIViewController()
    var window = UIApplication.sharedApplication().keyWindow
    if(window?.windowLevel != UIWindowLevelNormal){
    var windows = UIApplication.sharedApplication().windows
    var tmpwin:UIWindow
    for tmpwin in windows{
    if(tmpwin.windowLevel == UIWindowLevelNormal ){
    window = tmpwin as? UIWindow
    break
    }
    }
    }
    if (NSArray(array:window!.subviews).count == 0){
    currentViewController = self
    }
    else{
    var frontView: AnyObject = NSArray(array:window!.subviews).objectAtIndex(0)
    var nextResponder = frontView.nextResponder()
    if(nextResponder!.isKindOfClass(UIViewController)){
    currentViewController = nextResponder as! UIViewController
    }
    else{
    currentViewController = window!.rootViewController!
    }
    }
    dispatch_sync(dispatch_get_main_queue(), {
    currentViewController.performSegueWithIdentifier("ToLogin", sender: AnyObject?())
    self.performSegueWithIdentifier("ToLogin", sender: AnyObject?())
    
    })
    //currentViewController.presentViewController(addView, animated: true, completion: nil)
    println("Block")
    }
    sleep(5)
    }while(true)
    }
}
