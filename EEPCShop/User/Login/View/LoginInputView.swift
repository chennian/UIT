//
//  LoginInputView.swift
//  sevenloan
//
//  Created by spectator Mr.Z on 2018/12/4.
//  Copyright © 2018 tangxers. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class LoginInputView: SNBaseView {

    let titleL = UILabel().then {
       $0.font = Font(32)
    }
    
    let textField = UITextField().then {
        $0.font = Font(32)
    }

}

extension LoginInputView {
    
    func set(title: String, placeholder: String) {
        titleL.text = title
        textField.placeholder = placeholder
    }
    
    override func setupView() {
        
        let line = UIView().then {
            $0.backgroundColor = Color(0xd8dade)
        }
    
        addSubviews(views: [titleL,textField,line])
        
        titleL.snp.makeConstraints { (make) in
            make.left.snEqualToSuperview().snOffset(53)
            make.centerY.snEqualToSuperview()
            make.width.snEqualTo(150)
        }
        
        textField.snp.makeConstraints { (make) in
            make.left.snEqualTo(titleL.snp.right).snOffset(20)
            make.top.snEqualToSuperview()
            make.bottom.snEqualToSuperview().snOffset(-2)
            make.right.snEqualToSuperview().snOffset(-75)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.snEqualTo(titleL.snp.left)
            make.right.snEqualTo(textField.snp.right)
            make.bottom.snEqualToSuperview()
            make.height.snEqualTo(1)
        }
    }
}
