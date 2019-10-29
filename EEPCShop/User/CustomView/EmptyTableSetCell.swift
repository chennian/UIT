//
//  EmptyTableSetCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/30.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class EmptyTableSetCell: SNBaseTableViewCell {

    let emptyImgView  = UIImageView().then{
        $0.backgroundColor = Color(0xf5f5f5)
        $0.image = UIImage(named: "empty")
    }
    override func setupView() {
        hidLine()
        
        self.contentView.backgroundColor = Color(0xf5f5f5)
        self.contentView.addSubview(emptyImgView)
        
        emptyImgView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.snEqualTo(fit(1000))
            make.height.snEqualTo(300)
        }
    }
}
