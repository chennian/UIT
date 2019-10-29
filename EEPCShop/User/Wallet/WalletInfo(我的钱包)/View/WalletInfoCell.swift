//
//  WalletInfoCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/2.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class WalletInfoCell:  SNBaseTableViewCell {
    let baseView = UIView().then{
        $0.backgroundColor = ColorRGB(red: 254, green: 253, blue: 253)
        $0.layer.cornerRadius = fit(16)
    }
    
    let img = UIImageView().then{
        $0.contentMode = .scaleAspectFit
        $0.backgroundColor = .clear
    }
    
    let coinType  = UILabel().then{
        $0.font = BoldFont(32)
        $0.textColor = ColorRGB(red: 42, green: 52, blue: 87)
        $0.text = "USDT"
    }
    
    let num  = UILabel().then{
        $0.font = Font(32)
        $0.textColor = ColorRGB(red: 42, green: 52, blue: 87)
        $0.text = "25388.3675"
    }
    override func setupView() {
        hidLine()
        self.contentView.backgroundColor = Color(0xf5f5f5)
        self.contentView.addSubview(baseView)
        baseView.addSubview(img)
        baseView.addSubview(coinType)
        baseView.addSubview(num)
        
        baseView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.snEqualTo(690)
            make.height.snEqualTo(170)
        }
        
        img.snp.makeConstraints { (make) in
            make.centerY.equalTo(baseView.snp.centerY)
            make.left.equalTo(baseView.snp.left).snOffset(30)
            make.width.height.snEqualTo(68)
        }
        
        coinType.snp.makeConstraints { (make) in
            make.centerY.equalTo(img.snp.centerY)
            make.left.equalTo(img.snp.right).snOffset(24)
        }
        
        num.snp.makeConstraints { (make) in
            make.centerY.equalTo(img.snp.centerY)
            make.right.equalToSuperview().snOffset(-30)
        }
        
    }
    
}
extension WalletInfoCell{
    func set(img:UIImage,name: String,num:String) {
        self.img.image = img
        self.coinType.text = name
        self.num.text = num
    }}
