//
//  HomePageModel.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/2.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import SwiftyJSON

enum homePageType{
    case bannerType
    case classType
    case adType
    case merchantHeadType
    case merchantType(HomePageModel)
    case spaceType
    case emptyType
    case mapType

}

class HomePageModel: SNSwiftyJSONAble {
    var id : String
    var shop_id : String
    var shop_name : String
    var user_discount : String
    var discount : String
    var eepc_ratio : String
    var usdt_ratio : String

    
    var province : String
    var city : String
    var area : String
    var address_detail : String
    var lng : String
    
    var lat : String
    var main_img : String
    var phone :String
    var cat : String
    var lable : String
    
    var detail_img :String
    var describtion :String
    
    var base:String = ""
    var bouns:String = ""
    
    
    
    required init?(jsonData: JSON) {
        self.id = jsonData["id"].stringValue
        self.shop_id = jsonData["shop_id"].stringValue
        self.shop_name = jsonData["shop_name"].stringValue
        self.user_discount = jsonData["user_discount"].stringValue
        self.discount = jsonData["discount"].stringValue
        self.eepc_ratio = jsonData["eepc_ratio"].stringValue
        self.usdt_ratio = jsonData["usdt_ratio"].stringValue
        
        self.province = jsonData["province"].stringValue
        self.city = jsonData["city"].stringValue
        self.area = jsonData["area"].stringValue
        self.address_detail = jsonData["address_detail"].stringValue
        self.lng = jsonData["lng"].stringValue
        
        self.lat = jsonData["lat"].stringValue
        self.main_img = jsonData["main_img"].stringValue
        self.phone = jsonData["phone"].stringValue
        self.cat = jsonData["cat"].stringValue
        self.lable = jsonData["lable"].stringValue

        self.detail_img = jsonData["detail_img"].stringValue
        self.describtion = jsonData["description"].stringValue

    }
    
}
