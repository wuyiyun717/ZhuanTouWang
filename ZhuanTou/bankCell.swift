//
//  bankCell.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/7/1.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit


class bankCell: UITableViewCell{
    
    var selectedBank:UIView!
    var bankCardNO:UILabel!
    var bankPicture:UIImageView!
    
    init(reuseIdentifier cellId:String)
    {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        //self.backgroundColor = UIColor(red: 234/255, green: 234/255, blue: 234/255, alpha: 1)
        self.selectionStyle = UITableViewCellSelectionStyle.None
    }
    func addSelect(){
        self.selectedBank = UIView()
        self.selectedBank.frame = CGRectMake(10, 0, UIScreen.mainScreen().applicationFrame.width - 20, 60)
        self.selectedBank.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.selectedBank.backgroundColor = UIColor.clearColor()
        self.selectedBank.layer.borderColor = UIColor(red: 255/255, green: 66/255, blue: 55/255, alpha: 1.0).CGColor
        self.selectedBank.layer.borderWidth = 2
        self.addSubview(selectedBank)
    }
    
    func addBankCardNO(string: String!){
        self.bankCardNO = UILabel()
        self.bankCardNO.frame = CGRectMake(0, 40, UIScreen.mainScreen().applicationFrame.width, 20)
        self.bankCardNO.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.bankCardNO.text = string
        self.bankCardNO.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.bankCardNO.textAlignment = NSTextAlignment.Center
        self.bankCardNO.layer.borderWidth = 0
        self.bankCardNO.font = UIFont.systemFontOfSize(10)
        self.addSubview(bankCardNO)
    }
    
    func addBankPicture(image: UIImage!){
        self.bankPicture = UIImageView()
        self.bankPicture.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width/2 - 75, 0, 150, 40)
        self.bankPicture.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.bankPicture.image = image
        self.bankPicture.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.bankPicture.layer.borderWidth = 0
        self.addSubview(bankPicture)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
