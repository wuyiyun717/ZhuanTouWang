//
//  investCell.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/21.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit


class withdrawHistoryCell: UITableViewCell{
    
    var date:UILabel!
    var type:UILabel!
    var amount:UILabel!
    var status:UILabel!
    
    init(reuseIdentifier cellId:String)
    {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        self.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    
    func addDate(string: String!){
        self.date = UILabel()
        self.date.frame = CGRectMake(0, 0, UIScreen.mainScreen().applicationFrame.width / 4, 30)
        self.date.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.date.text = string
        self.date.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.date.layer.borderWidth = 0.5
        self.date.font = UIFont.systemFontOfSize(8)
        self.addSubview(date)
    }
    
    func addType(string: String!){
        self.type = UILabel()
        self.type.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width / 4, 0, UIScreen.mainScreen().applicationFrame.width / 4, 30)
        self.type.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.type.text = string
        self.type.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.type.layer.borderWidth = 0.5
        self.type.font = UIFont.systemFontOfSize(10)
        self.addSubview(type)
    }
    
    func addAmount(float: Float!){
        self.amount = UILabel()
        self.amount.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width / 2, 0, UIScreen.mainScreen().applicationFrame.width / 4, 30)
        self.amount.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.amount.text = String(format:"%.2f",float)
        self.amount.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.amount.layer.borderWidth = 0.5
        self.amount.font = UIFont.systemFontOfSize(14)
        self.addSubview(amount)
    }
    
    func addStatus(string: String!){
        self.status = UILabel()
        self.status.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width / 4 * 3, 0, UIScreen.mainScreen().applicationFrame.width / 4, 30)
        self.status.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.status.text = string
        self.status.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.status.layer.borderWidth = 0.5
        self.status.font = UIFont.systemFontOfSize(14)
        self.addSubview(status)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}