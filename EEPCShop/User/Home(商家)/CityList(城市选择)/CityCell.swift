//
//  CityCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/24.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class CityCell: SNBaseTableViewCell {

    var model:CityModel?{
        didSet{
            guard let cellModel = model else{return}
            self.cityName.text = cellModel.name
        }
    }
    
    let cityName = UILabel().then{
        $0.text = ""
        $0.textColor = Color(0x2a3457)
        $0.font = Font(30)
    }

    override func setupView() {
        self.contentView.addSubview(cityName)
        cityName.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(30)
            make.centerY.equalToSuperview()
        }
    }
}
