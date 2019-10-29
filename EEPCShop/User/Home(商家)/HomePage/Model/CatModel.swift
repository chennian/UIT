//
//  CatModel.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/30.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import SwiftyJSON

class CatModel: SNSwiftyJSONAble {
    var id : String
    var name : String
    var img : String

    required init?(jsonData: JSON) {
        self.id = jsonData["id"].stringValue
        self.name = jsonData["name"].stringValue
        self.img = jsonData["image2"].stringValue
    
    }
    
}
