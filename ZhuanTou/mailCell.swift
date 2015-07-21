//
//  mailCell.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/28.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit


class mailCell: UITableViewCell{
    
    var date:UILabel!
    var title:UILabel!
    var status:UILabel!
    
    init(reuseIdentifier cellId:String)
    {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        self.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    func addDate(string: String!){
        self.date = UILabel()
        self.date.frame = CGRectMake(0, 0, 100, 30)
        self.date.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.date.text = string
        self.date.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.date.layer.borderWidth = 0
        self.date.font = UIFont.systemFontOfSize(8)
        self.addSubview(date)
    }
    
    func addTitle(string: String!){
        self.title = UILabel()
        self.title.frame = CGRectMake(100, 0, UIScreen.mainScreen().applicationFrame.width - 170, 30)
        self.title.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.title.text = string
        self.title.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.title.numberOfLines = 0
        self.title.layer.borderWidth = 0
        self.title.font = UIFont.systemFontOfSize(10)
        self.addSubview(title)
    }
    
    func addStatus(string: String!){
        self.status = UILabel()
        self.status.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width - 70, 0, 70, 30)
        self.status.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.status.text = string
        self.status.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.status.layer.borderWidth = 0
        self.status.font = UIFont.systemFontOfSize(10)
        self.addSubview(status)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
