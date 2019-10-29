//
//  WalletDetailModel.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/8.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import SwiftyJSON

enum WalletDetailType{
    case WalletDetailHead(address:String)
    case WalletDetailInfo(model:WalletDetailModel)
    case EmptyType
}

class WalletDetailModel: SNSwiftyJSONAble{
    var coin_id : String
    var uid : String
    var num : String
    var in_out : String
    var type : String
    var remark : String
    var add_time : String
    
    required init?(jsonData: JSON) {
        self.coin_id = jsonData["coin_id"].stringValue
        self.uid = jsonData["uid"].stringValue
        self.num = jsonData["num"].stringValue
        self.in_out = jsonData["in_out"].stringValue
        self.type = jsonData["type"].stringValue
        self.remark = jsonData["remark"].stringValue
        self.add_time = jsonData["add_time"].stringValue
    }
}
