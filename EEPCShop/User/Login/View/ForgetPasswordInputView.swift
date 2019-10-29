//
//  ForgetPasswordInputView.swift
//  sevenloan
//
//  Created by spectator Mr.Z on 2018/12/4.
//  Copyright © 2018 tangxers. All rights reserved.
//

import UIKit

class ForgetPasswordInputView: SNBaseView {

    let titleL = UILabel().then {
        $0.font = Font(32)
        $0.textColor = Color(0x262626)
    }
    
    let textField = UITextField().then {
        $0.font = Font(32)
        $0.textColor = Color(0x8f8f8f) 
    }
}

extension ForgetPasswordInputView {
    
    func set(title: String, placeholder: String, textAlignment: NSTextAlignment = .left) {
        titleL.text = title
        textField.placeholder = placeholder
        textField.textAlignment = textAlignment
    }
    
    override func setupView() {
        
        let line = LineView()
        
        addSubviews(views: [titleL,textField,line])
        
        titleL.snp.makeConstraints { (make) in
            make.left.snEqualToSuperview()
            make.centerY.snEqualToSuperview()
            make.width.snEqualTo(150)
        }
        
        textField.snp.makeConstraints { (make) in
            make.left.snEqualTo(titleL.snp.right).snOffset(20)
            make.top.snEqualToSuperview()
            make.bottom.snEqualToSuperview().snOffset(-2)
            make.right.snEqualToSuperview()
        }
        
        line.snp.makeConstraints { (make) in
            make.left.snEqualTo(titleL.snp.left)
            make.right.snEqualTo(textField.snp.right)
            make.bottom.snEqualToSuperview()
            make.height.snEqualTo(1)
        }
    }
}
