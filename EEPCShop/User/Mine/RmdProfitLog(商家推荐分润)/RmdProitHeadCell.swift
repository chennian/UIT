//
//  RmdProitHeadCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/5/8.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class RmdProitHeadCell: SNBaseTableViewCell {
    
    var model:String?{
        didSet{
            guard let str = model else {
                return
            }
            totalLable.text = str + "  家"
        }
    }
    
    let totalLable = UILabel().then{
        $0.text = ""
        $0.textColor = Color(0x2a3457)
        $0.font = Font(32)
    }
    
    let des = UILabel().then{
        $0.text = "推荐商家数量"
        $0.textColor = Color(0x2a3457)
        $0.font = Font(32)
    }
    
    
    override func setupView() {
//        self.contentView.backgroundColor = Color(0x3660fb)
        
        self.contentView.addSubviews(views: [totalLable,des])
        
  
        
        des.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().snOffset(65)
        }
        
        totalLable.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().snOffset(-65)
        }
    }
}
