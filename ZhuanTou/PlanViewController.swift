//
//  PlanViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/5/31.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class PlanViewController: UIViewController, UITabBarDelegate{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var urlString:String?="http://www.pujintianxia.com/api/product/orderedAll"
        httpRequest(urlString!)
    }
    
    func connection(connection:NSURLConnection!,didReceiveData data:NSData!){
        var returnString:NSString?
        returnString=NSString(data:data,encoding:NSUTF8StringEncoding)
        //println(returnString)
        //let jsonData = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: nil) as! NSDictionary
        var JSONObject: AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        //let json = JSON(data: data)
        let json = JSON(data:data)

        var str="result:\n"+String(returnString!)
        
        if let userName = json["dataList"][0]["productName"].string{
            println(userName)
        }
        
        
        var url2 = NSURL(string: "http://www.pujintianxia.com/api/product/orderedAll")
        var data2 = NSData(contentsOfURL: url2!)
        var str2 = NSString(data: data2!, encoding: NSUTF8StringEncoding)
        println(str2)
        var json2 : AnyObject! = NSJSONSerialization.JSONObjectWithData(data2!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        //for (key,value) in jsonData{
        //        str+="\n key-->\(key)"+" value=\(value) "
        //}
        text.text = str
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func httpRequest( urlString:String){
        var url:NSURL = NSURL(string: "\(urlString)")!
        var requrst:NSURLRequest?
        var conn:NSURLConnection?
        requrst=NSURLRequest(URL:url)
        conn=NSURLConnection(request: requrst!,delegate: self)
        //println(conn)
        if((conn) != nil){
                println("http连接成功!")
        }else{
                println("http连接失败!")
        }
        //var url2 = NSURL(string: "http://www.pujintianxia.com/api/product/orderedAll")
        var data = NSData(contentsOfURL: url)
        var str = NSString(data: data!, encoding: NSUTF8StringEncoding)
        //var json : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        let json = JSON(data: data!)
        if let productName = json["dataList"][0]["productName"].string{
            println(productName)
       //Now you got your value
        }
        println(str)
        
    }
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if tabBar.selectedItem == Home {
            performSegueWithIdentifier("PlanToHome", sender: AnyObject?())
        }
        else if tabBar.selectedItem == Account {
            performSegueWithIdentifier("PlanToAccount", sender: AnyObject?())
        }
        else if tabBar.selectedItem == More{
            performSegueWithIdentifier("PlanToMore", sender: AnyObject?())
        }
    }
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var Home: UITabBarItem!
    @IBOutlet weak var Plan: UITabBarItem!
    @IBOutlet weak var Account: UITabBarItem!
    @IBOutlet weak var More: UITabBarItem!
    //@IBOutlet var label: UILabel!
    @IBOutlet var text: UITextView!
    
    
}