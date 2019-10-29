//
//  ForgetPasswordSMSView.swift
//  sevenloan
//
//  Created by spectator Mr.Z on 2018/12/4.
//  Copyright © 2018 tangxers. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ForgetPasswordSMSView: SNBaseView {

    let titleL = UILabel().then {
        $0.font = Font(32)
    }
    
    let textField = UITextField().then {
        $0.font = Font(32)
    }
    
    let smsButton = TimerButton().then {
        $0.timeLength = 60
        $0.backgroundColor = Color(0xffffff)
        $0.setTitleColor(Color(0x2777ff), for: .normal)
        $0.layer.borderWidth = fit(2)
        $0.layer.borderColor = Color(0x2777ff).cgColor
        $0.layer.cornerRadius = fit(29)
    }

}

extension ForgetPasswordSMSView {
    
    func set(title: String, placeholder: String, buttonText: String) {
        titleL.text = title
        textField.placeholder = placeholder
//        smsButton.setContent(title: buttonText)
    }
    
    override func setupView() {
        
        let line = LineView()
        
        addSubviews(views: [titleL,textField,smsButton,line])
        
        smsButton.setup("验证码", timeTitlePrefix: "", aTimeLength: 60)

        
        titleL.snp.makeConstraints { (make) in
            make.left.snEqualToSuperview()
            make.centerY.snEqualToSuperview()
            make.width.snEqualTo(150)
        }
        
        textField.snp.makeConstraints { (make) in
            make.left.snEqualTo(titleL.snp.right).snOffset(20)
            make.top.snEqualToSuperview()
            make.bottom.snEqualToSuperview().snOffset(-2)
//            make.right.snEqualToSuperview()
        }
        
        smsButton.snp.makeConstraints { (make) in
            make.right.snEqualToSuperview()
            make.width.snEqualTo(140)
            make.height.snEqualTo(60)
            make.centerY.snEqualToSuperview()
            make.left.snEqualTo(textField.snp.right)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.snEqualTo(titleL.snp.left)
            make.right.snEqualTo(smsButton.snp.right)
            make.bottom.snEqualToSuperview()
            make.height.snEqualTo(1)
        }
        
        smsButton.layer.cornerRadius = fit(30)
    }
}
