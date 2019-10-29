//
//  CityModel.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/24.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import SwiftyJSON
class CityModel: SNSwiftyJSONAble {
    var name : String

    
    
    required init?(jsonData: JSON) {
        self.name = jsonData["city"].stringValue

    }
}
