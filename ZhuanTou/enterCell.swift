//
//  stableCell.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/18.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit


class enterCell: UITableViewCell{
    var statusView:UIImageView!
    var productTitle:UILabel!
    var benefit:UILabel!
    var period:UILabel!
    var fund:UILabel!
    var benefitTitle:UILabel!
    var periodTitle:UILabel!
    var fundTitle:UILabel!
    var divideLine:UIImageView!
    var divideLine2:UIImageView!
    var divideLine3:UIImageView!
    var bigView:UIView!
    
    init(reuseIdentifier cellId:String)
    {
        super.init(style: UITableViewCellStyle.Default, reuseIdentifier:cellId)
        self.selectionStyle = UITableViewCellSelectionStyle.None
        self.backgroundColor = UIColor(red: 235/255, green: 235/255, blue: 241/255, alpha: 1.0)
        bigView = UIView(frame: CGRect(x: 10, y: 0, width: UIScreen.mainScreen().applicationFrame.width - 20, height: 100))
        bigView.layer.cornerRadius = 5
        bigView.backgroundColor = UIColor.whiteColor()
        self.addSubview(bigView)
    }
    
    class func getHeight() -> CGFloat
    {
        return 100.0
    }
    
    func addStatus(image: UIImage!){
        self.statusView = UIImageView()
        self.statusView.frame = CGRectMake(2, 2, 50, 50)
        self.statusView.image = image
        self.statusView.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.bigView.addSubview(self.statusView)
    }
    
    func addTitle(string: String!){
        self.productTitle = UILabel()
        self.productTitle.frame = CGRectMake(UIScreen.mainScreen().applicationFrame.width/2 - 90, 10, 160, 30)
        self.productTitle.text = string
        self.productTitle.textColor = UIColor.blackColor()
        self.productTitle.font = UIFont.systemFontOfSize(20)
        self.productTitle.textAlignment = NSTextAlignment.Center
        self.productTitle.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.bigView.addSubview(self.productTitle)
    }
    
    func addBenefit(int: Int!){
        self.benefit = UILabel()
        self.benefit.frame = CGRectMake(0, 50, self.bigView.frame.width/4, 20)
        self.benefit.text = "\(int)%"
        self.benefit.textColor = UIColor(red: 255/255, green: 66/255, blue: 55/255, alpha: 1.0)
        self.benefit.font = UIFont.systemFontOfSize(15)
        self.benefit.textAlignment = NSTextAlignment.Center
        self.benefit.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.bigView.addSubview(self.benefit)
        self.benefitTitle = UILabel()
        self.benefitTitle.frame = CGRectMake(0, 70, self.bigView.frame.width/4, 20)
        self.benefitTitle.text = "收益转让"
        self.benefitTitle.textColor = UIColor.lightGrayColor()
        self.benefitTitle.font = UIFont.systemFontOfSize(15)
        self.benefitTitle.textAlignment = NSTextAlignment.Center
        self.benefitTitle.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.bigView.addSubview(self.benefitTitle)
        self.divideLine = UIImageView(image: UIImage(named: "line.png"))
        self.divideLine.frame = CGRectMake(self.bigView.frame.width/4, 50, 1, 40)
        self.bigView.addSubview(self.divideLine)
        
    }
    
    func addFund(int: Int!){
        self.fund = UILabel()
        self.fund.frame = CGRectMake(self.bigView.frame.width/4, 50, self.frame.width/4, 20)
        self.fund.text = "\(int)%"
        self.fund.textColor = UIColor(red: 255/255, green: 66/255, blue: 55/255, alpha: 1.0)
        self.fund.font = UIFont.systemFontOfSize(15)
        self.fund.textAlignment = NSTextAlignment.Center
        self.fund.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.bigView.addSubview(self.fund)
        self.fundTitle = UILabel()
        self.fundTitle.frame = CGRectMake(self.bigView.frame.width/4, 70, self.frame.width/4, 20)
        self.fundTitle.text = "保本比例"
        self.fundTitle.textColor = UIColor.lightGrayColor()
        self.fundTitle.font = UIFont.systemFontOfSize(15)
        self.fundTitle.textAlignment = NSTextAlignment.Center
        self.fundTitle.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.bigView.addSubview(self.fundTitle)
        self.divideLine2 = UIImageView(image: UIImage(named: "line.png"))
        self.divideLine2.frame = CGRectMake(self.bigView.frame.width/2, 50, 1, 40)
        self.bigView.addSubview(self.divideLine2)
        
    }
    
    func addPeriod(int: Int!){
        self.period = UILabel()
        self.period.frame = CGRectMake(self.bigView.frame.width/2, 50, self.frame.width/4, 20)
        self.period.text = "\(int)天"
        self.period.textColor = UIColor(red: 255/255, green: 66/255, blue: 55/255, alpha: 1.0)
        self.period.font = UIFont.systemFontOfSize(15)
        self.period.textAlignment = NSTextAlignment.Center
        self.period.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.bigView.addSubview(self.period)
        self.periodTitle = UILabel()
        self.periodTitle.frame = CGRectMake(self.bigView.frame.width/2, 70, self.frame.width/4, 20)
        self.periodTitle.text = "投资期限"
        self.periodTitle.textColor = UIColor.lightGrayColor()
        self.periodTitle.font = UIFont.systemFontOfSize(15)
        self.periodTitle.textAlignment = NSTextAlignment.Center
        self.periodTitle.setTranslatesAutoresizingMaskIntoConstraints(false)
        self.bigView.addSubview(self.periodTitle)
        self.divideLine3 = UIImageView(image: UIImage(named: "line.png"))
        self.divideLine3.frame = CGRectMake(self.bigView.frame.width/4*3, 50, 1, 40)
        self.bigView.addSubview(self.divideLine3)
    }
    
    func addPercent(int:Int!){
        var percent = KDGoalBar(frame: CGRectMake(self.bigView.frame.width/4*3 + (self.bigView.frame.width/4 - 50)/2, 40, 50, 50))
        percent.setPercent(Int32(int), animated: true)
        //self.percentImage.addSubview(percent)
        self.bigView.addSubview(percent)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}