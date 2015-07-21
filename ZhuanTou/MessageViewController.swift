//
//  MessageViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/2.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class MessageViewController: UIViewController, UITableViewDelegate{
    var dateList:NSMutableArray = NSMutableArray()
    var titleList:NSMutableArray = NSMutableArray()
    var statusList:NSMutableArray = NSMutableArray()
    var dataArray:NSMutableArray = NSMutableArray()
    var detailArray:NSMutableArray = NSMutableArray()
    
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
        
        let home = NSHomeDirectory() as NSString;
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
        let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
        //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
        var keyValue: AnyObject? = settingPlist?.valueForKey("ProductCode")
        var apiValue: AnyObject? = settingPlist?.valueForKey("API")
        var api = apiValue as! String
        var url:NSURL = NSURL(string: "\(api)/account/allMessages/1")!
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
        var count = json["dataList"].count
        //var count = 3
        //println("MessageCount:\(count)")
        //println("MessageJson:\(json)")
        var dic = ["Cell":"MainCell","isAttached":false]
        for(var i = 0; i < count; i++){
            dateList.addObject(json["dataList"][i]["createdOn"].string!)
            //dateList.addObject("2015")
            titleList.addObject(json["dataList"][i]["title"].string!)
            //titleList.addObject("12345")
            statusList.addObject(json["dataList"][i]["status"].string!)
            //statusList.addObject("yidu")
            detailArray.addObject(json["dataList"][i]["content"].string!)
            //detailArray.addObject("12345")
            dataArray.addObject(dic)
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView:UITableView, numberOfRowsInSection: Int) -> Int{
        println("Rows:\(dataArray.count)")
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if ((dataArray[indexPath.row].objectForKey("Cell")) as! String == "MainCell"){
            return 30;
        }
        else{
            return 50;
        }
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        if((dataArray[indexPath.row].objectForKey("Cell")) as! String == "MainCell"){
            var cell = mailCell(reuseIdentifier:"mailCell")
            cell.backgroundColor = UIColor.whiteColor()
            cell.addDate(dateList[indexPath.row] as! String)
            cell.addTitle(titleList[indexPath.row] as! String)
            cell.addStatus(statusList[indexPath.row] as! String)
            return cell
        }
        else if((dataArray[indexPath.row].objectForKey("Cell")) as! String == "AttachedCell"){
            var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            cell.textLabel?.font = UIFont.systemFontOfSize(10)
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = (detailArray[indexPath.row-1] as! String)
            return cell
        }
        else{
            var cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        var path = NSIndexPath();
        if((dataArray[indexPath.row].objectForKey("Cell")) as! String == "MainCell"){
            //path = NSIndexPath(forItem: indexPath.row+1, inSection: indexPath.section)
            path = NSIndexPath(forRow: indexPath.row+1, inSection: indexPath.section)
        }
        else{
            path = indexPath
        }
        if((dataArray[indexPath.row].objectForKey("isAttached")) as! Bool == true){
            var dic = ["Cell": "MainCell","isAttached":false]
            dataArray[(path.row-1)] = dic
            dataArray.removeObjectAtIndex(path.row)
            tableView.beginUpdates()
            tableView.deleteRowsAtIndexPaths([path] as [AnyObject], withRowAnimation: UITableViewRowAnimation.Top)
            tableView.endUpdates()
        }
        else{
            var dic = ["Cell": "MainCell","isAttached":true]
            dataArray[(path.row-1)] = dic
            var addDic = ["Cell": "AttachedCell","isAttached":true]
            
            dataArray.insertObject(addDic, atIndex: path.row)
            tableView.beginUpdates()
            tableView.insertRowsAtIndexPaths([path] as [AnyObject], withRowAnimation: UITableViewRowAnimation.Top)
            tableView.endUpdates()
        }
}
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}