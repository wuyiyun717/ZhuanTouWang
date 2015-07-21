//
//  CheckBox.swift
//  LazyCloset
//
//  Created by Wu YiYun on 14-11-11.
//  Copyright (c) 2014年 Wu YiYun. All rights reserved.
//

import UIKit
import QuartzCore

class CheckBox : UIButton {
    var isChecked:Bool!
    var target:AnyObject!
    var fun:Selector!
    
    override init(frame:CGRect){
        super.init(frame: frame)
        self.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        self.setImage(UIImage(named:"com_btn_checked.png"), forState: UIControlState.Normal)
        self.addTarget(self, action:"checkBoxClicked:", forControlEvents: UIControlEvents.TouchUpInside)
        self.isChecked = true
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setTarget(tar:AnyObject, fun ff:Selector) {
        target=tar
        fun=ff

    }
    
    @IBAction func checkBoxClicked(sender: AnyObject) {
        if(self.isChecked == false){
            self.isChecked = true;
            self.setImage(UIImage(named:"com_btn_checked.png"), forState: UIControlState())
    
        }else{
            self.isChecked = false;
            self.setImage(UIImage(named:"com_btn_check.png"), forState: UIControlState())
    
        }
        
    }
}
