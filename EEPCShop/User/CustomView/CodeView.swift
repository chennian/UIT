//
//  CodeView.swift
//  seven
//
//  Created by Mac Pro on 2018/12/17.
//  Copyright © 2018年 CHENNIAN. All rights reserved.
//

import UIKit

class CodeView: SNBaseView {

    let name = UILabel().then{
        $0.font = Font(32)
        $0.textColor = Color(0x262626)
        $0.text = "验证码"
    }
    
    let textfield = UITextField().then{
        $0.borderStyle = .none
        $0.font = Font(32)
        $0.textColor = Color(0x262626)
        $0.textAlignment = .right
        $0.placeholder = "请输入验证码"
    }
    
    let smsButton = TimerButton().then {
        $0.timeLength = 60
        $0.backgroundColor = Color(0xffffff)
        $0.setTitleColor(Color(0x2777ff), for: .normal)
        $0.layer.borderWidth = fit(2)
        $0.layer.borderColor = Color(0x2777ff).cgColor
        $0.layer.cornerRadius = fit(29)
    }
    
    let line = UIView().then{
        $0.backgroundColor = Color(0xd3dbea)
    }
    
    override func setupView() {
        
        self.addSubviews(views: [name,textfield,smsButton,line])
        
        smsButton.setup("验证码", timeTitlePrefix: "", aTimeLength: 60)
        
        name.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().snOffset(35)
        }
        
        smsButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().snOffset(-35)
            make.centerY.equalToSuperview()
            make.width.snEqualTo(140)
            make.height.snEqualTo(58)
        }
        
        textfield.snp.makeConstraints { (make) in
            make.left.equalTo(name.snp.right).snOffset(20)
            make.right.equalTo(smsButton.snp.left).snOffset(-30)
            make.centerY.equalTo(name.snp.centerY)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(35)
            make.right.equalToSuperview().snOffset(-35)
            make.height.snEqualTo(1)
            make.bottom.equalToSuperview()
        }
    
    }

}
