//
//  couponCell.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/28.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit


class myInvestCell: UITableViewCell{
    
    var productName:UILabel!
    var amountValue:UILabel!
    var amountTitle:UILabel!
    var paidInterest:UILabel!
    var paidInterestTitle:UILabel!
    var todaysShared:UILabel!
    var todaysSharedTitle:UILabel!
    var redLine:UIImageView!
    
    init(reuseIdentifier cellId:String)
    {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        self.backgroundColor = UIColor.whiteColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    func addProductName(string: String!){
        self.productName = UILabel()
        self.productName.frame = CGRectMake(25, 5, 100, 25)
        self.productName.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.productName.text = string
        self.productName.textColor = UIColor(red: 255/255, green: 66/255, blue: 55/255, alpha: 1.0)
        self.productName.layer.borderWidth = 0
        self.productName.font = UIFont.systemFontOfSize(12)
        self.addSubview(productName)
        self.redLine = UIImageView()
        self.redLine.frame = CGRectMake(20, 2.5, 2, 25)
        self.redLine.image = UIImage(named: "page-selected.png")
        self.addSubview(redLine)
    }
    
    func addAmount(float: Float!){
        self.amountTitle = UILabel()
        self.amountTitle.frame = CGRectMake(30, 35, 100, 20)
        self.amountTitle.text = "投资金额(元)"
        self.amountTitle.font = UIFont.systemFontOfSize(10)
        self.amountTitle.textAlignment = NSTextAlignment.Left
        self.addSubview(amountTitle)
        self.amountValue = UILabel()
        self.amountValue.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width - 140, 35, 100, 20)
        self.amountValue.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.amountValue.text = String(format:"%.2f",float)
        self.amountValue.layer.borderColor = UIColor.blackColor().CGColor
        self.amountValue.layer.borderWidth = 0
        self.amountValue.font = UIFont.systemFontOfSize(10)
        self.amountValue.textAlignment = NSTextAlignment.Right
        self.addSubview(amountValue)
    }
    
    func addPaidInterest(string: String!){
        self.paidInterestTitle = UILabel()
        self.paidInterestTitle.frame = CGRectMake(30, 55, 100, 20)
        self.paidInterestTitle.text = "固定收益(元)"
        self.paidInterestTitle.font = UIFont.systemFontOfSize(10)
        self.paidInterestTitle.textAlignment = NSTextAlignment.Left
        self.addSubview(paidInterestTitle)
        self.paidInterest = UILabel()
        self.paidInterest.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width - 140, 55, 100, 20)
        self.paidInterest.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.paidInterest.text = string
        self.paidInterest.layer.borderColor = UIColor.blackColor().CGColor
        self.paidInterest.layer.borderWidth = 0
        self.paidInterest.font = UIFont.systemFontOfSize(10)
        self.paidInterest.textAlignment = NSTextAlignment.Right
        self.addSubview(paidInterest)
    }
    
    func addTodaysShared(string: String!){
        self.todaysSharedTitle = UILabel()
        self.todaysSharedTitle.frame = CGRectMake(30, 75, 100, 20)
        self.todaysSharedTitle.text = "盈利分成(元)"
        self.todaysSharedTitle.font = UIFont.systemFontOfSize(10)
        self.todaysSharedTitle.textAlignment = NSTextAlignment.Left
        self.addSubview(todaysSharedTitle)
        self.todaysShared = UILabel()
        self.todaysShared.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width - 140, 75, 100, 20)
        self.todaysShared.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.todaysShared.text = string
        if (string != "无分成"){
            if ((string as NSString).floatValue < 0){
                self.todaysShared.textColor = UIColor.greenColor()
            }
            else if((string as NSString).floatValue > 0){
                self.todaysShared.textColor = UIColor.redColor()
            }
        }
        self.todaysShared.layer.borderColor = UIColor.blackColor().CGColor
        self.todaysShared.layer.borderWidth = 0
        self.todaysShared.font = UIFont.systemFontOfSize(10)
        self.todaysShared.textAlignment = NSTextAlignment.Right
        self.addSubview(todaysShared)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
