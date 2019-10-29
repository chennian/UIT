//
//  MerchantHeadCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/2.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class MerchantHeadCell: SNBaseTableViewCell {
    
    let name = UILabel().then{
        $0.font = BoldFont(32)
        $0.textColor = ColorRGB(red: 42, green: 52, blue: 87)
        $0.text = "商家推荐"
    }

    override func setupView() {
        hidLine()

        self.contentView.backgroundColor = Color(0xf5f5f5)
        self.contentView.addSubview(name)
        
        name.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().snOffset(44)
        }
        
    }

}
