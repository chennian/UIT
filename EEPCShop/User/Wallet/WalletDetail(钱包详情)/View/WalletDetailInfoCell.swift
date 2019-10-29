//
//  WalletDetailInfoCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/4.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class WalletDetailInfoCell: SNBaseTableViewCell {
    
    let name = UILabel().then{
        $0.text = "转出USDT"
        $0.textColor = Color(0x2a3457)
        $0.font = Font(30)
    }

    let timeLable = UILabel().then{
        $0.text = "2019/02/23 13:05:01"
        $0.textColor = Color(0xa9aebe)
        $0.font = Font(24)
    }
    
    let money = UILabel().then{
        $0.text = "+362.6552"
        $0.textColor = Color(0x0e7d28)
        $0.font = BoldFont(32)
    }
    
    override func setupView() {
        
        contentView.addSubviews(views: [name,timeLable,money])
        
        name.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(34)
            make.top.equalToSuperview().snOffset(33)
        }
        
        timeLable.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(34)
            make.top.equalTo(name.snp.bottom).snOffset(19)
        }
        
        money.snp.makeConstraints { (make) in
            make.centerY.equalTo(name.snp.centerY)
            make.right.equalToSuperview().snOffset(-34)
        }
        
    }
}
extension WalletDetailInfoCell{
    func setData(_ type:String,_ num:String,_ time:String) {
        name.text = type
        timeLable.text = time
        money.text = num
    }
}
