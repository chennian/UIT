//
//  RmdProfitCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/5/1.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class RmdProfitCell: SNBaseTableViewCell {
    
    var model:RmdProfitModel?{
        didSet{
            guard let cellModel = model  else { return }
            
            num.text = "+ \(cellModel.num)"
            time.text = cellModel.add_time
            
        }
    }
    
    
    let num = UILabel().then{
        $0.text = "+100"
        $0.textColor = Color(0x262626)
        $0.font = Font(32)
    }
    let time = UILabel().then{
        $0.text = "2019-04-27"
        $0.textColor = Color(0xa9aebe)
        $0.font = Font(32)
    }
    
    
    override func setupView() {
        
        self.contentView.addSubviews(views: [self.num,self.time])
        
        
        num.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().snOffset(65)
        }
        
        time.snp.makeConstraints { (make) in
            make.right.equalToSuperview().snOffset(-30)
            make.centerY.equalToSuperview()
        }
    }
}
