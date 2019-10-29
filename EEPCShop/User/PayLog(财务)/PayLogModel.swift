//
//  PayLogModel.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/5/11.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import SwiftyJSON

class PayLogModel: SNSwiftyJSONAble {
    
    
    var shop_name:String
    
    var main_img:String
    
    var remark:String
    
    var pay_time:String
    
    var pay_num:String
    
    var pay_eepc:String
    
    
    required init?(jsonData: JSON) {
        
        self.shop_name = jsonData["shop_name"].stringValue
        self.main_img = jsonData["main_img"].stringValue
        self.remark = jsonData["remark"].stringValue
        self.pay_time = jsonData["pay_time"].stringValue
        self.pay_num = jsonData["pay_num"].stringValue
        self.pay_eepc = jsonData["pay_eepc"].stringValue
        
    }
}
