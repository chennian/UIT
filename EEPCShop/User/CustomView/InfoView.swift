//
//  InfoView.swift
//  seven
//
//  Created by Mac Pro on 2018/12/17.
//  Copyright © 2018年 CHENNIAN. All rights reserved.
//

import UIKit

class InfoView: SNBaseView {
    
    let name = UILabel().then{
        $0.font = Font(32)
        $0.textColor = Color(0x262626)
    }
    
    let textfield = UITextField().then{
        $0.borderStyle = .none
        $0.font = Font(32)
        $0.textColor = Color(0x262626)
        $0.textAlignment = .right
//        $0.isUserInteractionEnabled = false
    }
    
    let line = UIView().then{
        $0.backgroundColor = Color(0xd3dbea)
    }
    
    override func setupView() {
        self.addSubviews(views: [name,textfield,line])
        
        name.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().snOffset(35)
        }
        
        textfield.snp.makeConstraints { (make) in
            make.right.equalToSuperview().snOffset(-35)
            make.centerY.equalToSuperview()
            make.width.snEqualTo(320)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(35)
            make.right.equalToSuperview().snOffset(-35)
            make.height.snEqualTo(1)
            make.bottom.equalToSuperview()
        }
    }
}
extension InfoView{
    func set(name: String, placeHolder: String) {
        self.name.text = name
        self.textfield.placeholder = placeHolder
    }
}
