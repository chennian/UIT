//
//  BannerModel.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/5/10.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import SwiftyJSON

class BannerModel: SNSwiftyJSONAble {
    var id : String
    var name : String
    var img : String
    var type : String
    var url:String

    
    required init?(jsonData: JSON) {
        self.id = jsonData["id"].stringValue
        self.name = jsonData["name"].stringValue
        self.img = jsonData["image"].stringValue
        self.type = jsonData["type"].stringValue
        self.url = jsonData["url"].stringValue
    }
}
