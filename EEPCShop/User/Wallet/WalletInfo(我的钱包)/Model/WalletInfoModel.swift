//
//  WalletInfoModel.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/2.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import SwiftyJSON

enum WalletInfoType{
    case walletHeadType(num:String)
    case walletUSDTType(img:UIImage,name:String,num:String)
    case walletEEPCType(img:UIImage,name:String,num:String)
    case walletCBDType(img:UIImage,name:String,num:String)

}

class WalletInfoModel: SNSwiftyJSONAble {
    required init?(jsonData: JSON) {
        
    }
    

}
class CoinValue: SNSwiftyJSONAble {
    var eepcValue : String
    var usdtValue : String
    var idoValue : String
    var cbdValue: String

    
    required init?(jsonData: JSON) {
        self.eepcValue = jsonData["eepcValue"].stringValue
        self.usdtValue = jsonData["usdtValue"].stringValue
        self.idoValue = jsonData["idoValue"].stringValue
        self.cbdValue = jsonData["cbdValue"].stringValue
    }
    
}
