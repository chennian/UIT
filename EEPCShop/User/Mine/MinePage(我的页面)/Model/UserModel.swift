//
//  MinePageModel.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/3.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

import SwiftyJSON
enum MinePageType{
    case MineHeadType
    case MineCellOne
    case MineCellTwo
    case SpaceCell
    case LoginOut
    
}

class UserModel: SNSwiftyJSONAble {
    var uid : String
    var phone: String
    var pwd : String
    var pay_pwd : String
    var nick_name : String
    var level : String
    var contribute_point : String
    var headimg : String
    var eepc : String
    var usdt : String
    var cbd: String
    var ido: String
    var eepc_wallet_address: String
    var usdt_wallet_address: String
    var first_buy: String
    var bank_status:String
    var login_status:String

    
    required init?(jsonData: JSON) {
        self.uid = jsonData["uid"].stringValue
        self.phone = jsonData["phone"].stringValue
        self.pwd = jsonData["pwd"].stringValue
        self.pay_pwd = jsonData["pay_pwd"].stringValue
        self.nick_name = jsonData["nick_name"].stringValue
        self.level = jsonData["level"].stringValue
        self.contribute_point = jsonData["contribute_point"].stringValue
        self.headimg = jsonData["headimg"].stringValue
        self.eepc = jsonData["eepc"].stringValue
        self.usdt = jsonData["usdt"].stringValue
        self.cbd = jsonData["cbd"].stringValue
        self.ido = jsonData["ido"].stringValue
        self.eepc_wallet_address = jsonData["eepc_wallet_address"].stringValue
        self.usdt_wallet_address = jsonData["usdt_wallet_address"].stringValue
        self.first_buy = jsonData["first_buy"].stringValue
        self.bank_status = jsonData["bank_status"].stringValue
        self.login_status = jsonData["login_status"].stringValue
    }
}
