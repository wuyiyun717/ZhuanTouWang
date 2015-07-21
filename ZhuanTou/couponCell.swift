//
//  couponCell.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/28.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit


class couponCell: UITableViewCell{
    
    var couponID:UILabel!
    var faceValue:UILabel!
    var faceTitle:UILabel!
    var threshold:UILabel!
    var thresholdTitle:UILabel!
    var expire:UILabel!
    var expireTitle:UILabel!
    var redLine:UIImageView!
    
    init(reuseIdentifier cellId:String)
    {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        self.backgroundColor = UIColor.whiteColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    func addCouponID(string: String!){
        self.couponID = UILabel()
        self.couponID.frame = CGRectMake(25, 0, 100, 25)
        self.couponID.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.couponID.text = string
        self.couponID.textColor = UIColor(red: 255/255, green: 66/255, blue: 55/255, alpha: 1.0)
        self.couponID.layer.borderWidth = 0
        self.couponID.font = UIFont.systemFontOfSize(12)
        self.addSubview(couponID)
        self.redLine = UIImageView()
        self.redLine.frame = CGRectMake(20, 2.5, 2, 20)
        self.redLine.image = UIImage(named: "page-selected.png")
        self.addSubview(redLine)
    }
    
    func addFaceValue(float: Float!){
        self.faceTitle = UILabel()
        self.faceTitle.frame = CGRectMake(30, 25, 100, 25)
        self.faceTitle.text = "面值"
        self.faceTitle.font = UIFont.systemFontOfSize(10)
        self.faceTitle.textAlignment = NSTextAlignment.Left
        self.addSubview(faceTitle)
        self.faceValue = UILabel()
        self.faceValue.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width - 140, 25, 100, 25)
        self.faceValue.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.faceValue.text = String(format:"%.2f",float)
        self.faceValue.layer.borderColor = UIColor.blackColor().CGColor
        self.faceValue.layer.borderWidth = 0
        self.faceValue.font = UIFont.systemFontOfSize(10)
        self.faceValue.textAlignment = NSTextAlignment.Right
        self.addSubview(faceValue)
    }
    
    func addthreshold(float: Float!){
        self.thresholdTitle = UILabel()
        self.thresholdTitle.frame = CGRectMake(30, 45, 100, 25)
        self.thresholdTitle.text = "使用门槛"
        self.thresholdTitle.font = UIFont.systemFontOfSize(10)
        self.thresholdTitle.textAlignment = NSTextAlignment.Left
        self.addSubview(thresholdTitle)
        self.threshold = UILabel()
        self.threshold.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width - 140, 45, 100, 25)
        self.threshold.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.threshold.text = String(format:"%.2f",float)
        self.threshold.layer.borderColor = UIColor.blackColor().CGColor
        self.threshold.layer.borderWidth = 0
        self.threshold.font = UIFont.systemFontOfSize(10)
        self.threshold.textAlignment = NSTextAlignment.Right
        self.addSubview(threshold)
    }
    
    func addExpire(string: String!){
        self.expireTitle = UILabel()
        self.expireTitle.frame = CGRectMake(30, 65, 100, 25)
        self.expireTitle.text = "到期时间"
        self.expireTitle.font = UIFont.systemFontOfSize(10)
        self.expireTitle.textAlignment = NSTextAlignment.Left
        self.addSubview(expireTitle)
        self.expire = UILabel()
        self.expire.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width - 140, 65, 100, 25)
        self.expire.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.expire.text = string
        self.expire.layer.borderColor = UIColor.blackColor().CGColor
        self.expire.layer.borderWidth = 0
        self.expire.font = UIFont.systemFontOfSize(10)
        self.expire.textAlignment = NSTextAlignment.Right
        self.addSubview(expire)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
