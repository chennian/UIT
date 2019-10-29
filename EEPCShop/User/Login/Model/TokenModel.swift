//
//  TokenModel.swift
//  XHXMerchant
//
//  Created by Mac Pro on 2018/4/14.
//  Copyright © 2018年 CHENNIAN. All rights reserved.
//

import UIKit
import SwiftyJSON

class TokenModel: SNSwiftyJSONAble {
    var timestamp : Int
    var token : String
    var uid : String
   
    required init?(jsonData: JSON) {
        self.timestamp = jsonData["timestamp"].intValue
        self.token = jsonData["token"].stringValue
        self.uid = jsonData["uid"].stringValue
    }
    
        
}
