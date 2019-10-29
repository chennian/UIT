//
//  SpaceCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/2.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class SpaceCell: SNBaseTableViewCell {
    
    var styleColor : UIColor = .clear{
        didSet{
            backgroundColor = styleColor
            contentView.backgroundColor = styleColor
        }
    }
    
    override func setupView() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        hidLine()
    }
    
}
