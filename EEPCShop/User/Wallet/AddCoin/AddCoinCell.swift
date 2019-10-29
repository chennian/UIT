//
//  AddCoinCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/30.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class AddCoinCell: SNBaseTableViewCell {
    
    
    var clickEvent:(()->())?
    
    let img = UIImageView().then{
        $0.backgroundColor = .clear
    }
    
    let label = UILabel().then{
        $0.text = ""
        $0.textColor = Color(0x2a3457)
        $0.font = BoldFont(32)
    }
    
    let btn = UIButton().then{
        $0.setTitle("添 加", for: .normal)
        $0.setTitleColor(Color(0x3660fb), for: .normal)
        $0.layer.cornerRadius = fit(30)
        $0.titleLabel?.font = Font(32)
        $0.layer.borderWidth = fit(1)
        $0.layer.borderColor  = Color(0x3660fb).cgColor
    }
    
    @objc func btnAction(){
        guard let action = clickEvent else {
            return
        }
        action()
    }

    
    override func setupView() {
    
        btn.addTarget(self, action: #selector(btnAction), for: .touchUpInside)
        
        self.contentView.addSubviews(views:[img,label,btn])
        
        
        img.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().snOffset(30)
            make.width.height.snEqualTo(68)
        }
        
        label.snp.makeConstraints { (make) in
            make.centerY.equalTo(img.snp.centerY)
            make.left.equalTo(img.snp.right).snOffset(24)
        }
        
        btn.snp.makeConstraints { (make) in
            make.right.equalToSuperview().snOffset(-65)
            make.centerY.equalToSuperview()
            make.width.snEqualTo(120)
            make.height.snEqualTo(60)
        }
    }
}
