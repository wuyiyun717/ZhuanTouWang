//
//  DisplayAchieveViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/23.
//  Copyright (c) 2015年 Momu. All rights reserved.
//


import UIKit

class DisplayAchieveViewController: UIViewController, UIWebViewDelegate, UITabBarControllerDelegate{
    
    var productCode:String = String()
    var firstLoad = true
    var highChartString:NSString = NSString()
    var isLogin = false

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
        
        highChart.delegate = self
        var htmlPath = NSBundle.mainBundle().pathForResource("localHighCharts", ofType: "html")
        var htmlString = NSString(contentsOfFile: htmlPath!, encoding: NSUTF8StringEncoding, error: nil)
        var request = NSURLRequest(URL: NSURL(fileURLWithPath: htmlPath!)!)
        println("Request:\(request)")
        highChart.loadRequest(request)
        let home = NSHomeDirectory() as NSString;
        let docPath = home.stringByAppendingPathComponent("Documents") as NSString
        let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
        //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
        var keyValue: AnyObject? = settingPlist?.valueForKey("ProductCode")
        productCode = keyValue as! String
        var apiValue: AnyObject? = settingPlist?.valueForKey("API")
        var api = apiValue as! String
        var url:NSURL = NSURL(string: "\(api)/tradingDetail/byCode4M/\(productCode)")!
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
        println("\(productCode)")

        var data = NSData(contentsOfURL: url)
        var dataString:NSString = NSString()
        if(data != nil){
            dataString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
        }
        println("\(dataString)")
        if (data == nil || dataString == "null" || dataString == ""){
            titleLabel.text = "暂无登记业绩"
            plPct.text = "--%"
            indPct.text = "--%"
            trader.text = "--"
        }
        else{
            highChartString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
            let json = JSON(data: data!)
            println("\(json)")
            titleLabel.text = json["relatedRecordName"].string
            trader.text = json["traderName"].string
            var pl = Float(Int(10000*(json["netValue"].float! - 1)))/100
            println(pl)
            plPct.text = "\(pl)%"
            var ind = json["indList"][0]["value"].float!
            var max = json["indList"][0]["date"].string!
            for(var i = 0; i < json["indList"].count; i++){
                if(json["indList"][i]["date"].string! > max){
                    ind = json["indList"][i]["value"].float!
                    max = json["indList"][i]["date"].string!
                }
            }
            var indTrue = Float(Int(10000*(ind - 1)))/100
            println(indTrue)
            indPct.text = "\(indTrue)%"
            if (pl > 0){
                plPct.textColor = UIColor(red: 255/255, green: 66/255, blue: 55/255, alpha: 1)
            }
            else{
                plPct.textColor = UIColor(red: 98/255, green: 183/255, blue: 34/255, alpha: 1)
            }
            if (indTrue > 0){
                indPct.textColor = UIColor(red: 255/255, green: 66/255, blue: 55/255, alpha: 1)
            }
            else{
                indPct.textColor = UIColor(red: 98/255, green: 183/255, blue: 34/255, alpha: 1)
            }
        }
        achiView.layer.borderColor = UIColor.lightGrayColor().CGColor
        achiView.layer.borderWidth = 1
        
        //highChart.loadHTMLString(htmlPath, baseURL: NSURL(fileURLWithPath: String(htmlString!)))
//        var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
//        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath!)
//        var keyValue: AnyObject? = settingPlist?.valueForKey("ProductCode")
//        productCode = keyValue as! String
//        var apiValue: AnyObject? = settingPlist?.valueForKey("API")
//        var api = apiValue as! String
//        var url:NSURL = NSURL(string: "\(api)/tradingDetail/byCode4M/\(productCode)")!
//        var requrst:NSURLRequest?
//        var conn:NSURLConnection?
//        requrst=NSURLRequest(URL:url)
//        conn=NSURLConnection(request: requrst!,delegate: self)
//        //println(conn)
//        if((conn) != nil){
//            println("http连接成功!")
//        }else{
//            println("http连接失败!")
//        }
//        
//        var data = NSData(contentsOfURL: url)
//        var str = NSString(data: data!, encoding: NSUTF8StringEncoding)
//        //var json : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
//        let json = JSON(data: data!)
        
        //println("\(json)")
        
        //(contentsOfFile: filePath, usedEncoding: NSUTF8StringEncoding, error: nil)
        //var data = NSData(contentsOfFile: filePath!)
        //var str:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
        //println("\(url!)")
        //highChart.stringByEvaluatingJavaScriptFromString("var script = document.createElement('script');script.type = 'text/javascript';script.text = \"function getProductDetailStr(){return \(json)}\";document.getElementsByTagName('head')[0].appendChild(script);")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidFinishLoad(webView: UIWebView) {
        

        //var str = "{\"relatedRecordId\":\"0ae618a0-538f-4435-b156-202bc7f0afaa\",\"relatedRecordType\":\"稳健型投顾产品\",\"relatedRecordName\":\"双子座1.0\",\"relatedRecordCode\":\"201506091224791\",\"name\":\"双子座\",\"prior\":200000.000000,\"inferior\":50000.000000,\"initial\":250000.000000,\"netValue\":1.020174,\"pl\":5043.690000,\"plStd\":0.042099,\"plStdRank\":0.675000,\"numOfDaysProfit\":4,\"numOfDaysLoss\":4,\"tradingHaltedPct\":0.000000,\"numOfDaysEven\":0,\"maxRetracement\":-0.088348,\"numOfTradesProfit\":15,\"numOfTradesLoss\":7,\"numOfTradesEven\":0,\"numOfClosedTrades\":22,\"winRate\":0.681818,\"numOfStockOwning\":1,\"positionPct\":0.225137,\"marketValue\":57420.000000,\"netValueRank\":0.500000,\"maxRetracementRank\":0.700000,\"winRateRank\":0.550000,\"sharpPctRank\":0.500000,\"plDist\":\"0,0,1,1,2,2,0,2,0,0,\",\"commision\":98.522000,\"anualizedReturn\":0.610286,\"sharpPct\":0.479215,\"yestPlPct\":-0.025879,\"monthPlPct\":0.020174,\"traderName\":\"dzh123\",\"industryPctList\":[{\"industry\":\"机械设备\",\"pct\":1.000000,\"id\":\"6c361467-e66b-4a95-a9c9-6c3a8bad5507\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAaec=\",\"isDeleted\":false}],\"netValueList\":[{\"date\":\"6_15\",\"value\":1.119040,\"year\":\"2015\",\"value2\":250000.000000,\"dateTime\":\"2015-06-15 00:00:00\",\"id\":\"66e9ecaa-78a3-426a-8e28-10cedc53349f\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAALmk=\",\"isDeleted\":false},{\"date\":\"6_10\",\"value\":1.006400,\"year\":\"2015\",\"value2\":250000.000000,\"dateTime\":\"2015-06-10 00:00:00\",\"id\":\"245cd293-e558-4311-b328-683f2299cfb9\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAOg8=\",\"isDeleted\":false},{\"date\":\"6_18\",\"value\":1.047278,\"year\":\"2015\",\"value2\":250000.000000,\"dateTime\":\"2015-06-18 00:00:00\",\"id\":\"dda386a3-6396-4059-b468-7219cd1d0ba0\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAO0w=\",\"isDeleted\":false},{\"date\":\"6_17\",\"value\":1.107552,\"year\":\"2015\",\"value2\":250000.000000,\"dateTime\":\"2015-06-17 00:00:00\",\"id\":\"0fffcec0-540a-4fb8-b2ae-9a8f8dee2d09\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAQJg=\",\"isDeleted\":false},{\"date\":\"6_19\",\"value\":1.020174,\"year\":\"2015\",\"value2\":250000.000000,\"dateTime\":\"2015-06-19 00:00:00\",\"id\":\"05dcd3dc-31be-47ad-8210-a42f017d2d11\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAQeg=\",\"isDeleted\":false},{\"date\":\"6_12\",\"value\":1.102996,\"year\":\"2015\",\"value2\":250000.000000,\"dateTime\":\"2015-06-12 00:00:00\",\"id\":\"65388fb7-575d-4f89-b5d9-c73c866bb64e\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAARsM=\",\"isDeleted\":false},{\"date\":\"6_16\",\"value\":1.112112,\"year\":\"2015\",\"value2\":250000.000000,\"dateTime\":\"2015-06-16 00:00:00\",\"id\":\"999b12a0-ddf2-4f1f-beca-ca6ab797e007\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAARzo=\",\"isDeleted\":false},{\"date\":\"6_11\",\"value\":1.048552,\"year\":\"2015\",\"value2\":250000.000000,\"dateTime\":\"2015-06-11 00:00:00\",\"id\":\"d792e5c5-1946-48e7-b55a-fc4f1d9430eb\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAATgI=\",\"isDeleted\":false}],\"retracementList\":[{\"date\":\"6_16\",\"value\":-0.006191,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-16 00:00:00\",\"id\":\"60641343-b36c-4e09-afcc-282a873a4ad0\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAMVc=\",\"isDeleted\":false},{\"date\":\"6_11\",\"value\":0.000000,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-11 00:00:00\",\"id\":\"1f83d71c-14f5-49d1-a82a-3af05678dc3e\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAANCM=\",\"isDeleted\":false},{\"date\":\"6_15\",\"value\":0.000000,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-15 00:00:00\",\"id\":\"291308f5-a599-41b8-936b-45037f3b37f4\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAANYs=\",\"isDeleted\":false},{\"date\":\"6_19\",\"value\":-0.088348,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-19 00:00:00\",\"id\":\"72a31ac4-f778-4cc7-881d-82386eaa2d29\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAPV4=\",\"isDeleted\":false},{\"date\":\"6_12\",\"value\":0.000000,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-12 00:00:00\",\"id\":\"05be2928-8b0d-4c45-8902-8b633c78d111\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAPoM=\",\"isDeleted\":false},{\"date\":\"6_17\",\"value\":-0.010266,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-17 00:00:00\",\"id\":\"3fa4cae8-09c4-4fa0-95eb-a3d7d9a32dc2\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAQdw=\",\"isDeleted\":false},{\"date\":\"6_18\",\"value\":-0.064128,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-18 00:00:00\",\"id\":\"6cd33a74-5e5b-4a2b-b77d-b2d90b0bcfb6\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAARAU=\",\"isDeleted\":false},{\"date\":\"6_10\",\"value\":0.000000,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-10 00:00:00\",\"id\":\"f134195b-c3d7-4435-824f-bc3905295b50\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAARTs=\",\"isDeleted\":false}],\"indList\":[{\"date\":\"6_16\",\"value\":0.952488,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-16 00:00:00\",\"id\":\"ba14a9b3-219a-4f92-b44f-3303e4fd5348\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAMvc=\",\"isDeleted\":false},{\"date\":\"6_12\",\"value\":1.003321,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-12 00:00:00\",\"id\":\"b050dd59-9054-4afb-b310-572f786c6f2a\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAN+M=\",\"isDeleted\":false},{\"date\":\"6_10\",\"value\":0.998429,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-10 00:00:00\",\"id\":\"84b4d8a7-f99d-4e57-b60c-57b22f7c3e58\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAN+8=\",\"isDeleted\":false},{\"date\":\"6_18\",\"value\":0.927237,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-18 00:00:00\",\"id\":\"a39de213-36e8-4c1c-adb7-7322dcb40398\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAO3E=\",\"isDeleted\":false},{\"date\":\"6_11\",\"value\":0.997955,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-11 00:00:00\",\"id\":\"a9ac3495-0a1f-4b56-8a02-8b92af094052\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAPog=\",\"isDeleted\":false},{\"date\":\"6_15\",\"value\":0.981891,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-15 00:00:00\",\"id\":\"75b1e941-a0b7-44d9-b3ce-d13b99060d9e\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAASCk=\",\"isDeleted\":false},{\"date\":\"6_17\",\"value\":0.966406,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-17 00:00:00\",\"id\":\"4d668e3f-8b4e-4db5-92dd-fba7c8ee0d2c\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAATeg=\",\"isDeleted\":false},{\"date\":\"6_19\",\"value\":0.872042,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-19 00:00:00\",\"id\":\"9489dd6e-c964-4755-b072-fc798df1007d\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAATgk=\",\"isDeleted\":false}],\"plPctList\":[{\"date\":\"6_19\",\"value\":0.020174,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-19 00:00:00\",\"id\":\"deb12f7b-a7dd-4e71-9b63-2bc8c542d42f\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAMeY=\",\"isDeleted\":false},{\"date\":\"6_18\",\"value\":0.047278,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-18 00:00:00\",\"id\":\"3d90946a-668e-4400-822b-4fd27af47516\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAANvY=\",\"isDeleted\":false},{\"date\":\"6_11\",\"value\":0.048552,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-11 00:00:00\",\"id\":\"9c7d51d0-395a-483f-baf8-550f39b2048a\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAN6U=\",\"isDeleted\":false},{\"date\":\"6_10\",\"value\":0.006400,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-10 00:00:00\",\"id\":\"9daaf09d-76d6-4d8e-ac8d-982e9ea5c8a2\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAQFQ=\",\"isDeleted\":false},{\"date\":\"6_15\",\"value\":0.119040,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-15 00:00:00\",\"id\":\"79847b7c-4d67-4430-b424-9d16730d12e9\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAQPo=\",\"isDeleted\":false},{\"date\":\"6_17\",\"value\":0.107552,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-17 00:00:00\",\"id\":\"30045294-4272-442f-aa26-9fd889db66bb\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAQVk=\",\"isDeleted\":false},{\"date\":\"6_12\",\"value\":0.102996,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-12 00:00:00\",\"id\":\"0d9a3b19-bd03-46a9-b240-c73061b83e66\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAARsE=\",\"isDeleted\":false},{\"date\":\"6_16\",\"value\":0.112112,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-16 00:00:00\",\"id\":\"bc4edc05-9359-4087-a8a5-e5533aa04517\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAASuo=\",\"isDeleted\":false}],\"datedDealList\":[],\"datedPositionList\":[],\"platePctList\":[{\"plateName\":\"中小板\",\"pct\":0.000000,\"id\":\"cda67b36-212e-4508-be04-27e94ab65b3a\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAb88=\",\"isDeleted\":false},{\"plateName\":\"主板\",\"pct\":0.000000,\"id\":\"3e6c5bfb-6ac3-4048-8231-89664bacf11a\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAcAY=\",\"isDeleted\":false},{\"plateName\":\"创业板\",\"pct\":1.000000,\"id\":\"33473eec-0af6-476b-b7bb-af9ef73d2cd8\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAcBI=\",\"isDeleted\":false}],\"plDaily\":[{\"date\":\"6_19\",\"value\":-0.025879,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-19 00:00:00\",\"id\":\"8d701790-3c7c-4433-863b-4adab24dfbef\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAANks=\",\"isDeleted\":false},{\"date\":\"6_18\",\"value\":-0.054420,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-18 00:00:00\",\"id\":\"10dd4926-3b75-496a-a603-6127720f3c06\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAOTQ=\",\"isDeleted\":false},{\"date\":\"6_12\",\"value\":0.051923,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-12 00:00:00\",\"id\":\"9fdef374-047f-4f37-aef3-65d424c3843d\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAOcQ=\",\"isDeleted\":false},{\"date\":\"6_15\",\"value\":0.014545,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-15 00:00:00\",\"id\":\"14fa76fd-4f0a-479c-b7b7-b06199327aa7\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAQ68=\",\"isDeleted\":false},{\"date\":\"6_17\",\"value\":-0.004100,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-17 00:00:00\",\"id\":\"a69d1b02-6f06-40f8-a204-b848b653d5e5\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAARLo=\",\"isDeleted\":false},{\"date\":\"6_11\",\"value\":0.041884,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-11 00:00:00\",\"id\":\"a6f4ef93-a2f6-43d2-9ae1-c40d6821ddbc\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAARkU=\",\"isDeleted\":false},{\"date\":\"6_16\",\"value\":-0.006191,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-16 00:00:00\",\"id\":\"21bef3da-24e6-45ab-85e9-c5922425fde6\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAARoE=\",\"isDeleted\":false},{\"date\":\"6_10\",\"value\":0.006400,\"year\":\"2015\",\"value2\":0.000000,\"dateTime\":\"2015-06-10 00:00:00\",\"id\":\"fa6282dc-8410-4d6d-8d1a-e9aeff70ae81\",\"createdOn\":\"2015-06-20 23:02:22\",\"createdBy\":null,\"modifiedOn\":null,\"modifiedBy\":null,\"rowVersion\":\"AAAAAAAAS3g=\",\"isDeleted\":false}],\"active\":false,\"qualified\":null}"
//        var text: NSString = NSString(CString: str.cStringUsingEncoding(NSUTF8StringEncoding)!,
//            encoding: NSUTF8StringEncoding)!
//        println("\(text))")
        //var json : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        //var str = NSString(contentsOfFile: path, encoding: NSUTF8StringEncoding, error: nil)
        if(firstLoad == true){
            dispatch_async(dispatch_get_main_queue()) {
                //self.highChart.stringByEvaluatingJavaScriptFromString("var script = document.createElement('script');script.type = 'text/javascript';script.text = \"function getProductDetailStr(){return \(str)}\";document.getElementsByTagName('head')[0].appendChild(script);")
                self.highChart.stringByEvaluatingJavaScriptFromString("draw('\(highChartString)');")

//                self.highChart.reload()
            }
            firstLoad = false
        }
        

//        var filePath:String = NSBundle.mainBundle().pathForResource("str", ofType: "txt")!
//        var url = String(contentsOfFile: filePath, encoding: NSUTF8StringEncoding, error: nil)
//        var data = NSData(contentsOfFile: filePath)
    
//        var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
//        var settingPlist = NSMutableDictionary(contentsOfFile: plistPath!)
//        var keyValue: AnyObject? = settingPlist?.valueForKey("ProductCode")
//        productCode = keyValue as! String
//        var apiValue: AnyObject? = settingPlist?.valueForKey("API")
//        var api = apiValue as! String
//        var url:NSURL = NSURL(string: "\(api)/tradingDetail/byCode4M/\(productCode)")!
//        var requrst:NSURLRequest?
//        var conn:NSURLConnection?
//        requrst=NSURLRequest(URL:url)
//        conn=NSURLConnection(request: requrst!,delegate: self)
//        //println(conn)
//        if((conn) != nil){
//            println("http连接成功!")
//        }else{
//            println("http连接失败!")
//        }
//        
//        var data = NSData(contentsOfURL: url)
//        var str = NSString(data: data!, encoding: NSUTF8StringEncoding)
//        //var json : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
//        let json = JSON(data: data!)
//        
//        println("\(json)")
//
//        //(contentsOfFile: filePath, usedEncoding: NSUTF8StringEncoding, error: nil)
//        //var data = NSData(contentsOfFile: filePath!)
//        //var str:NSString = NSString(data: data!, encoding: NSUTF8StringEncoding)!
//        //println("\(url!)")
//        webView.stringByEvaluatingJavaScriptFromString("function getProductDetailStr(){return \(json)}")
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
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        checkLogin()
        if tabBar.selectedItem == Home {
            performSegueWithIdentifier("AchiToHome", sender: AnyObject?())
        }
        else if tabBar.selectedItem == Account{
            if(isLogin){
                performSegueWithIdentifier("AchiToAccount", sender: AnyObject?())
            }
            else{
                performSegueWithIdentifier("ToLogin", sender: AnyObject?())
            }
        }
        else if tabBar.selectedItem == More{
            if(isLogin){
                performSegueWithIdentifier("AchiToMore", sender: AnyObject?())
            }
            else{
                performSegueWithIdentifier("ToLogin", sender: AnyObject?())
            }
        }
    }
    
    @IBOutlet var achiView: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var trader: UILabel!
    @IBOutlet var plPct: UILabel!
    @IBOutlet var indPct: UILabel!
    @IBOutlet var highChart: UIWebView!
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var Home: UITabBarItem!
    @IBOutlet var Account: UITabBarItem!
    @IBOutlet var More: UITabBarItem!
}