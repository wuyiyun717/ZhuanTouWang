//
//  MyBankcardViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/26.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class MyBankcardViewController: UIViewController, UITableViewDelegate, UITabBarControllerDelegate, UIPickerViewDelegate, UIPickerViewDataSource{
    var nofee:Float = 0.0
    var bankList:NSMutableArray = NSMutableArray()
    var bankCardIdList:NSMutableArray = NSMutableArray()
    var bankNameList:NSMutableArray = NSMutableArray()
    var bankCardCodeList:NSMutableArray = NSMutableArray()
    var openBankList:NSMutableArray = NSMutableArray()
    var provinceList:NSMutableArray = NSMutableArray()
    var cityList:NSMutableArray = NSMutableArray()
    var accountName:String = String()
    var selectedProvince:String = String()
    var selectedCity:String = String()
    var defaultBankCardID:String = String()
    
    var createOnList:NSMutableArray = NSMutableArray()
    var withdrawMethodList:NSMutableArray = NSMutableArray()
    var amountList:NSMutableArray = NSMutableArray()
    var statusList:NSMutableArray = NSMutableArray()
    var defaultBankCardIndex = 0
    
    
//    override func viewWillAppear(animated: Bool) {
//        for(var i = 0; i < bankCardIdList.count; i++){
//            if(bankCardIdList[i] as! String == defaultBankCardID){
//                defaultBankCardIndex = i
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //bankCardPicker = UIPickerView(frame: CGRectMake(0, 40, UIScreen.mainScreen().applicationFrame.width, 180))
        //bankCardPicker = UIPickerView(frame: CGRectMake(0, UIScreen.mainScreen().applicationFrame.height - 40, UIScreen.mainScreen().applicationFrame.width, 80))
        //self.view.addSubview(bankCardPicker)

        UITabBarItem.appearance().setTitleTextAttributes([NSForegroundColorAttributeName: UIColor.grayColor()], forState: UIControlState.Selected)
        tabBar.barTintColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        Home.image = UIImage(named: "home.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        Home.selectedImage = UIImage(named: "home-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        Account.image = UIImage(named: "account.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        Account.selectedImage = UIImage(named: "account-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        More.image = UIImage(named: "more.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)
        More.selectedImage = UIImage(named: "more-selected.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysOriginal)

        withdrawButton.enabled = false
        manageButton.enabled = true
        historyButton.enabled = true
        withdrawSelected.hidden = false
        manageSelected.hidden = true
        historySelected.hidden = true
        withdrawView.hidden = false
        manageView.hidden = true
        historyView.hidden = true

        bankView.layer.borderColor = UIColor.lightGrayColor().CGColor
        bankView.layer.borderWidth = 1
        accountLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
        accountLabel.layer.borderWidth = 1
        feeCostLabel.layer.borderColor = UIColor.lightGrayColor().CGColor
        feeCostLabel.layer.borderWidth = 1
        withdrawTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        tradePassTextField.layer.borderColor = UIColor.lightGrayColor().CGColor
        openBankView.layer.borderColor = UIColor.lightGrayColor().CGColor
        openBankView.layer.borderWidth = 1
        provinceView.layer.borderColor = UIColor.lightGrayColor().CGColor
        provinceView.layer.borderWidth = 1
        cityView.layer.borderColor = UIColor.lightGrayColor().CGColor
        cityView.layer.borderWidth = 1
        
        bankPicker.delegate = self
        bankView.addSubview(bankPicker)
        bankView.clipsToBounds = true
        
        provincePicker.delegate = self
        provinceView.addSubview(provincePicker)
        provinceView.clipsToBounds = true
        
        cityPicker.delegate = self
        cityView.addSubview(cityPicker)
        cityView.clipsToBounds = true
        
        openBankPicker.delegate = self
        openBankView.addSubview(openBankPicker)
        openBankView.clipsToBounds = true
        
        bankTableView.delegate = self
        historyTableView.delegate = self
        
        selectedProvince = ""
        selectedCity = ""
        
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
        var url:NSURL = NSURL(string: "\(api)/account/userWithdrawVm")!
        var requrst:NSURLRequest?
        var conn:NSURLConnection?
        requrst=NSURLRequest(URL:url)
        conn=NSURLConnection(request: requrst!,delegate: self)
        
        var data = NSData(contentsOfURL: url)
        var str = NSString(data: data!, encoding: NSUTF8StringEncoding)
        //var json : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        let json = JSON(data: data!)
        println("\(json)")
        var avai = json["fundsAvailable"].float!
        var avaiString = String(format:"%.2f",avai)
        nofee = json["noWithdrawFeeAmount"].float!
        var nofeeString = String(format:"%.2f",nofee)
        fundAvaiLabel.text = "\(avaiString)元"
        noFeeLabel.text = "\(nofeeString)免手续费提款额度"
        accountName = json["fullName"].string!
        accountLabel.text = accountName
        var allBankCount = json["allBanks"].count
        for (var i = 0; i < allBankCount; i++){
            openBankList.addObject(json["allBanks"][i].string!)
        }
        var count = json["bankCards"].count
        if(count == 0){
            //bankList.addObject("暂无银行卡信息")
        }
        else{
            for(var i = 0; i < count; i++){
                var bankCardCode = json["bankCards"][i]["cardCode"].string!
                var bankName = json["bankCards"][i]["bankName"].string!
                var bankStr = "\(bankCardCode)(\(bankName))"
                bankList.addObject(bankStr)
                bankNameList.addObject(bankName)
                bankCardCodeList.addObject(bankCardCode)
                bankCardIdList.addObject(json["bankCards"][i]["id"].string!)
                if(json["bankCards"][i]["isDefault"].bool! == true){
                    defaultBankCardID = json["bankCards"][i]["id"].string!
                }
            }
        }
        var provinceCount = json["allProvinces"].count
        for(var i = 0; i < provinceCount; i++){
            var provinceName = json["allProvinces"][i].string!
            provinceList.addObject(provinceName)
        }
        bankPicker.reloadAllComponents()
        for(var i = 0; i < bankCardIdList.count; i++){
            if(bankCardIdList[i] as! String == defaultBankCardID){
                bankPicker.selectRow(i, inComponent: 0, animated: true)
            }
        }
        provincePicker.selectedRowInComponent(0)
        cityPicker.hidden = true
        //selectedProvince = provinceList[0] as! String
       

        println("province:\(provinceList)")
    }
    
    func updateDefaultBank(){
        println("Old default:\(defaultBankCardID)")
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
        var url:NSURL = NSURL(string: "\(api)/account/userWithdrawVm")!
        var requrst:NSURLRequest?
        var conn:NSURLConnection?
        requrst=NSURLRequest(URL:url)
        conn=NSURLConnection(request: requrst!,delegate: self)
        
        var data = NSData(contentsOfURL: url)
        var str = NSString(data: data!, encoding: NSUTF8StringEncoding)
        //var json : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        let json = JSON(data: data!)
        //println("\(json)")
        var count = json["bankCards"].count
        if(count == 0){
            //bankList.addObject("暂无银行卡信息")
        }
        else{
            for(var i = 0; i < count; i++){
                if(json["bankCards"][i]["isDefault"].bool! == true){
                    defaultBankCardID = json["bankCards"][i]["id"].string!
                }
            }
        }
        println("New default:\(defaultBankCardID)")
        bankPicker.reloadAllComponents()
        for(var i = 0; i < bankCardIdList.count; i++){
            if(bankCardIdList[i] as! String == defaultBankCardID){
                bankPicker.selectRow(i, inComponent: 0, animated: true)
            }
        }
        bankTableView.reloadData()
    }
    
    @IBAction func confirmWithdraw(sender: AnyObject) {
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
        if(withdrawTextField.text == ""){
            var addView:UIAlertController = UIAlertController(title: "", message: "请输入金额", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                NSLog("OK button")
            }
            addView.addAction(actionOK)
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(addView, animated: true, completion: nil)
            }
        }
        else if(tradePassTextField.text == ""){
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
            var amount = (withdrawTextField.text as NSString).floatValue
            var bankCardId = bankCardIdList[bankPicker.selectedRowInComponent(0)] as! String
            var tradePass = tradePassTextField.text
            var params:Dictionary<String,AnyObject> = ["channel":"2","Amount":amount,"transferAccount":accountName,"tradePassword":tradePass,"BankCardId":bankCardId]
            println(params)
            var request = HTTPTask()
            request.POST("\(api)/withdraw/applyWithdrawal", parameters: params, completionHandler: {(response:HTTPResponse) -> Void in
                var detailJSON = JSON(data: (response.responseObject as? NSData)!, options: NSJSONReadingOptions.AllowFragments, error: nil)
                println("\(detailJSON)")
                if(detailJSON["isSuccess"].bool! == true){
                    var addView:UIAlertController = UIAlertController(title: "", message: "提款成功", preferredStyle:.Alert)
                    let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                        self.performSegueWithIdentifier("ToMore", sender: AnyObject?())
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
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
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
        if(pickerView == provincePicker){
            cityList.removeAllObjects()
            let home = NSHomeDirectory() as NSString;
            let docPath = home.stringByAppendingPathComponent("Documents") as NSString
            let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
            //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
            var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
            var apiValue: AnyObject? = settingPlist?.valueForKey("API")
            var api = apiValue as! String
            var urlCity:NSURL = NSURL(string: "\(api)/withdraw/provinceCityMap")!
            var requrstCity:NSURLRequest?
            var connCity:NSURLConnection?
            requrstCity=NSURLRequest(URL:urlCity)
            connCity=NSURLConnection(request: requrstCity!,delegate: self)
            
            var provinceName = provinceList[provincePicker.selectedRowInComponent(0)] as! String
            var dataCity = NSData(contentsOfURL: urlCity)
            //var strCity = NSString(data: dataCity!, encoding: NSUTF8StringEncoding)
            let jsonCity = JSON(data: dataCity!)
            var cityCount = jsonCity["\(provinceName)"].count
            for(var i = 0; i < cityCount; i++){
                var cityName = jsonCity["\(provinceName)"][i].string!
                cityList.addObject(cityName)
            }
            selectedProvince = provinceName
            println("city:\(cityList)")
            cityPicker.hidden = false
            cityPicker.reloadAllComponents()
        }
        else if(pickerView == cityPicker){
            selectedCity = cityList[cityPicker.selectedRowInComponent(0)] as! String
        }
    }
    
    @IBAction func withdrawChosen(sender: AnyObject) {
        withdrawButton.enabled = false
        manageButton.enabled = true
        historyButton.enabled = true
        withdrawSelected.hidden = false
        manageSelected.hidden = true
        historySelected.hidden = true
        withdrawView.hidden = false
        manageView.hidden = true
        historyView.hidden = true
        
    }
    
    @IBAction func manageChosen(sender: AnyObject) {
        withdrawButton.enabled = true
        manageButton.enabled = false
        historyButton.enabled = true
        withdrawSelected.hidden = true
        manageSelected.hidden = false
        historySelected.hidden = true
        withdrawView.hidden = true
        manageView.hidden = false
        historyView.hidden = true
        dispatch_async(dispatch_get_main_queue()) {
            if(self.bankList.count < 2){
                self.bankTableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().applicationFrame.width, CGFloat(self.bankList.count * 70))
            }
            else{
                self.bankTableView.frame = CGRectMake(0, 0, UIScreen.mainScreen().applicationFrame.width, 100)
            }
            //self.manageView.addSubview(self.bankTableView)
            //self.bankTableView.hidden = true
            println("\(self.bankTableView.frame.height)")
            self.addBankCardview.frame = CGRectMake(0, self.bankTableView.frame.height, UIScreen.mainScreen().applicationFrame.width, 160)
            //self.manageView.addSubview(self.addBankCardview)

        }


    }
    
    @IBAction func historyChosen(sender: AnyObject) {
        withdrawButton.enabled = true
        manageButton.enabled = true
        historyButton.enabled = false
        withdrawSelected.hidden = true
        manageSelected.hidden = true
        historySelected.hidden = false
        withdrawView.hidden = true
        manageView.hidden = true
        historyView.hidden = false
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
        var url:NSURL = NSURL(string: "\(api)/withdraw/records/1")!
        var requrst:NSURLRequest?
        var conn:NSURLConnection?
        requrst=NSURLRequest(URL:url)
        conn=NSURLConnection(request: requrst!,delegate: self)
        
        var data = NSData(contentsOfURL: url)
        var str = NSString(data: data!, encoding: NSUTF8StringEncoding)
        //var json : AnyObject! = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments, error: nil)
        let json = JSON(data: data!)
        var count = json["dataList"].count
        for(var i = 0; i < count; i++){
            createOnList.addObject(json["dataList"][i]["createdOn"].string!)
            withdrawMethodList.addObject(json["dataList"][i]["channel"].string!)
            amountList.addObject(json["dataList"][i]["amount"].float!)
            statusList.addObject(json["dataList"][i]["status"].string!)
        }

    }

    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
        var label = UILabel()
        if (pickerView == cityPicker || pickerView == provincePicker){
            label = UILabel(frame: CGRect(x: 0, y: 0, width: 90, height: 30))
        }
        else{
            label = UILabel(frame: CGRect(x: 0, y: 0, width: 180, height: 30))
        }
        switch (pickerView){
//        case bankCardPicker:
//            label.text = bankList[row] as? String
        case bankPicker:
            label.text = bankList[row] as? String
        case openBankPicker:
            label.text = openBankList[row] as? String
        case provincePicker:
            label.text = provinceList[row] as? String
        case cityPicker:
            label.text = cityList[row] as? String
        default:
            println("default")
        }
        label.font = UIFont.systemFontOfSize(12)
        return label
    }

    func numberOfComponentsInPickerView( pickerView: UIPickerView) -> Int{
        return 1
    }
    
    func pickerView(pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int{
        switch (pickerView){
//        case bankCardPicker:
//            return bankList.count
        case bankPicker:
            return bankList.count
        case openBankPicker:
            return openBankList.count
        case provincePicker:
            return provinceList.count
        case cityPicker:
            return cityList.count
        default:
            return 0
        }

    }
    
    func updateFeeCost(){
        var withdraw:Float = 0.0
        if(withdrawTextField.text == ""){
            withdraw = 0.0
        }
        else{
            withdraw = (withdrawTextField.text as NSString).floatValue
        }
        var feeCost:Float = 0.0
        if(withdraw - nofee <= 0){
            feeCost = 0.0
        }
        else{
            feeCost = (withdraw - nofee) * 0.005
        }
        var feeCostString = String(format:"%.2f",feeCost)
        feeCostLabel.text = "\(feeCostString)"
    }

    @IBAction func addBankCard(sender: AnyObject) {
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
        if(selectedProvince == ""){
            var addView:UIAlertController = UIAlertController(title: "", message: "请输入省份", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                NSLog("OK button")
            }
            addView.addAction(actionOK)
            presentViewController(addView, animated: true, completion: nil)
        }
        else if(selectedCity == ""){
            var addView:UIAlertController = UIAlertController(title: "", message: "请输入城市", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                NSLog("OK button")
            }
            addView.addAction(actionOK)
            presentViewController(addView, animated: true, completion: nil)
        }
        else if(bankNameTextField.text == ""){
            var addView:UIAlertController = UIAlertController(title: "", message: "请输入支行名称", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                NSLog("OK button")
            }
            addView.addAction(actionOK)
            presentViewController(addView, animated: true, completion: nil)
        }
        else if(bankCardNOTextField.text != ConfirmBankCardNOTextField.text){
            var addView:UIAlertController = UIAlertController(title: "", message: "两次银行卡号不一致", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                NSLog("OK button")
            }
            addView.addAction(actionOK)
            presentViewController(addView, animated: true, completion: nil)
        }
        else{
            let home = NSHomeDirectory() as NSString;
            let docPath = home.stringByAppendingPathComponent("Documents") as NSString
            let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
            //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
            var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
            var apiValue: AnyObject? = settingPlist?.valueForKey("API")
            var api = apiValue as! String
            var accountName = accountLabel.text
            var subbranchBankName = bankNameTextField.text
            var bankCardNO = bankCardNOTextField.text
            var openBankName = openBankList[openBankPicker.selectedRowInComponent(0)] as! String
            var provinceName = provinceList[provincePicker.selectedRowInComponent(0)] as! String
            var cityName = cityList[cityPicker.selectedRowInComponent(0)] as! String

            var params = ["AccountName":accountName, "BankName":openBankName, "SubbranchBankName":subbranchBankName, "CardCode":bankCardNO,"Province":provinceName,"City":cityName]
            //println("\(params as! Dictionary<String, AnyObject>)")
            //println(params)
            var request = HTTPTask()
            request.POST("\(api)/withdraw/addBankCard", parameters: params, completionHandler: {(response:HTTPResponse) -> Void in
                var detailJSON = JSON(data: (response.responseObject as? NSData)!, options: NSJSONReadingOptions.AllowFragments, error: nil)
                println("\(detailJSON)")
                if(detailJSON["isSuccess"].bool! == true){
                    var addView:UIAlertController = UIAlertController(title: "", message: "添加成功", preferredStyle:.Alert)
                    let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                        //self.performSegueWithIdentifier("ToMore", sender: AnyObject?())
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
    
    func tableView(tableView:UITableView, numberOfRowsInSection: Int) -> Int{
        if(tableView == bankTableView){
            return bankList.count
        }
        else{
            return createOnList.count
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if(tableView == bankTableView){
            return 70
        }
        else{
            return 30
        }
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!{
        if(!IJReachability.isConnectedToNetwork()){
            var addView:UIAlertController = UIAlertController(title: "", message: "请检查网络状态", preferredStyle:.Alert)
            let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                self.viewDidLoad()
            }
            addView.addAction(actionOK)
            dispatch_async(dispatch_get_main_queue()) {
                self.presentViewController(addView, animated: true, completion: nil)
            }
            return nil
        }
        if(tableView == bankTableView){
            var cell = bankCell(reuseIdentifier:"bankCell")
            cell.backgroundColor = UIColor.clearColor()
            cell.addBankCardNO(bankCardCodeList[indexPath.row] as! String)
            let home = NSHomeDirectory() as NSString;
            let docPath = home.stringByAppendingPathComponent("Documents") as NSString
            let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
            //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
            var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
            var apiValue: AnyObject? = settingPlist?.valueForKey("WithoutAPI")
            var api = apiValue as! String
            var bank = bankNameList[indexPath.row] as! String
            var str = "\(api)/Content/images/\(bank).jpg"
            var url:NSURL = NSURL(string: str.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!)!
            var data = NSData(contentsOfURL: url)
            var image = UIImage(data: data!)
            cell.addBankPicture(image)
            cell.addSelect()
            if(bankCardIdList[indexPath.row] as! String == defaultBankCardID){
                cell.selectedBank.hidden = false
            }
            else{
                cell.selectedBank.hidden = true
            }
            return cell
        }
        else{
            var cell = withdrawHistoryCell(reuseIdentifier:"withdrawHistoryCell")
            cell.backgroundColor = UIColor.clearColor()
            cell.addDate(createOnList[indexPath.row] as! String)
            cell.addType(withdrawMethodList[indexPath.row] as! String)
            cell.addAmount(amountList[indexPath.row] as! Float)
            cell.addStatus(statusList[indexPath.row] as! String)
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
        if(tableView == bankTableView){
            let home = NSHomeDirectory() as NSString;
            let docPath = home.stringByAppendingPathComponent("Documents") as NSString
            let plistPath = docPath.stringByAppendingPathComponent("Setting.plist")
            //var plistPath = NSBundle.mainBundle().pathForResource("Setting", ofType: "plist")
            var settingPlist = NSMutableDictionary(contentsOfFile: plistPath)
            var apiValue: AnyObject? = settingPlist?.valueForKey("API")
            var api = apiValue as! String
            var request = HTTPTask()
            var newDefaultBank = bankCardIdList[indexPath.row] as! String
            request.POST("\(api)/withdraw/setDefaultCard/\(newDefaultBank)", parameters: nil, completionHandler: {(response:HTTPResponse) -> Void in
                var detailJSON = JSON(data: (response.responseObject as? NSData)!, options: NSJSONReadingOptions.AllowFragments, error: nil)
                println("\(detailJSON)")
                if(detailJSON["isSuccess"].bool! == true){
                    var addView:UIAlertController = UIAlertController(title: "", message: "修改默认银行卡成功", preferredStyle:.Alert)
                    let actionOK = UIAlertAction(title:"OK", style:.Default) { action in
                        self.updateDefaultBank()
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
        updateFeeCost()
    }
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        self.resignFirstResponder()
        updateFeeCost()
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        if tabBar.selectedItem == Home {
            performSegueWithIdentifier("BankToHome", sender: AnyObject?())
        }
        else if tabBar.selectedItem == Account{
            performSegueWithIdentifier("BankToAccount", sender: AnyObject?())
        }
        else if tabBar.selectedItem == More{
            performSegueWithIdentifier("BankToMore", sender: AnyObject?())
        }
    }
//    @IBAction func showPicker(sender: AnyObject) {
//      
//
//        dispatch_async(dispatch_get_main_queue()) {
//            UIView.beginAnimations(nil, context: nil)
//            UIView.setAnimationDuration(0.3)
//            //UIView.animateWithDuration(0.3, animations: {self.bankCardPicker.center = CGPointMake(UIScreen.mainScreen().applicationFrame.width/2, UIScreen.mainScreen().applicationFrame.height-40)}, completion:nil)
//            self.bankCardPicker.center = CGPointMake(UIScreen.mainScreen().applicationFrame.width/2, UIScreen.mainScreen().applicationFrame.height-40)
//
//            UIView.commitAnimations()
//        }
//        
//    }
//
//    var bankCardPicker: UIPickerView!
    
    @IBOutlet var manageView: UIScrollView!
    @IBOutlet var withdrawView: UIView!
    @IBOutlet var fundAvaiLabel: UILabel!
    @IBOutlet var noFeeLabel: UILabel!
    @IBOutlet var withdrawTextField: UITextField!
    @IBOutlet var tradePassTextField: UITextField!
    @IBOutlet var accountLabel: UILabel!
    @IBOutlet var feeCostLabel: UILabel!
    @IBOutlet var bankView: UIView!
    @IBOutlet var bankPicker: UIPickerView!
    
    @IBOutlet var openBankView: UIView!
    @IBOutlet var openBankPicker: UIPickerView!
    @IBOutlet var provinceView: UIView!
    @IBOutlet var provincePicker: UIPickerView!
    @IBOutlet var cityView: UIView!
    @IBOutlet var cityPicker: UIPickerView!
    @IBOutlet var bankNameTextField: UITextField!
    @IBOutlet var bankCardNOTextField: UITextField!
    @IBOutlet var ConfirmBankCardNOTextField: UITextField!
    
    @IBOutlet var historyView: UIView!
    @IBOutlet var bankTableView: UITableView!
    @IBOutlet var historyTableView: UITableView!
    
    
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet weak var Home: UITabBarItem!
    @IBOutlet weak var Account: UITabBarItem!
    @IBOutlet weak var More: UITabBarItem!
    
    @IBOutlet var withdrawButton: UIButton!
    @IBOutlet var manageButton: UIButton!
    @IBOutlet var historyButton: UIButton!
    @IBOutlet var withdrawSelected: UIImageView!
    @IBOutlet var manageSelected: UIImageView!
    @IBOutlet var historySelected: UIImageView!
    
    @IBOutlet var addBankCardLabel: UILabel!
    @IBOutlet var addBankCardview: UIView!
    
}

//class ProvincePickerViewDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource{
//    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView!) -> UIView {
//        var label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
//        label.text = "江苏省"
//        label.font = UIFont.systemFontOfSize(12)
//        
//        return label
//    }
//    
//    func numberOfComponentsInPickerView( pickerView: UIPickerView) -> Int{
//        return 1
//    }
//    
//    func pickerView(pickerView: UIPickerView,numberOfRowsInComponent component: Int) -> Int{
//        return 2
//    }
//    
//}