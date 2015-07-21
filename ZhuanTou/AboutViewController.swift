//
//  AboutViewController.swift
//  ZhuanTou
//
//  Created by Wu YiYun on 15/6/2.
//  Copyright (c) 2015年 Momu. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        var str = "\n\t专投网是上海墨沐金融信息服务有限公司旗下的专业的创新型互联网金融平台，创始人团队全部为复旦大学背景，我们首创的专业投顾理财模式是一种有别于普通P2P借贷及配资平台的新模式，我们深谙普惠金融的意义，深耕于金融市场，精心设计并提供高端投资银行级别的理财产品，让每一个投资人以较低的门槛就能参与其中。专投网的各类产品，通过与各类金融机构及专业投顾的合作，为投资用户提供了高收益且低风险的投资渠道。\n\n\t● 面向投资用户，专投网致力于普及专业的投资顾问理财服务，帮助更多的投资者享受到高收益、高安全性、低门槛、轻松便捷的高端投资银行级别的理财产品\n\n\t● 面向专业投顾，专投网致力于提供品牌树立、业绩展示、产品发行、IT系统等服务的综合平台，让专业投顾，专注交易，专注产品，助力每一位投资人的财富稳定增值\n\n\t请专业投顾为您理财，让专业的人，用专业的心，在专业的平台，做专业的事，助力每一位投资人的财富稳定增值。"
        aboutText.text = str
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBOutlet var aboutText: UITextView!
}