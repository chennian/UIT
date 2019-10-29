//
//  RmdProfitModel.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/5/1.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import SwiftyJSON

enum RmdType{
    case headType(str:String)
    case infoType(model:RmdProfitModel)
}

class RmdProfitModel: SNSwiftyJSONAble{
    
    var id : String
    var uid : String
    var num: String
    var money: String
    var shop_id: String
    var user_id: String
    var add_time : String
    
    
    required init?(jsonData: JSON) {
        self.id = jsonData["id"].stringValue
        self.uid = jsonData["uid"].stringValue
        self.num = jsonData["num"].stringValue
        self.money = jsonData["money"].stringValue
        self.shop_id = jsonData["shop_id"].stringValue
        self.user_id = jsonData["user_id"].stringValue
        self.add_time = jsonData["add_time"].stringValue
        
    }
    
}
