//
//  LoginOutCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/8.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class LoginOutCell: SNBaseTableViewCell {
    var clickBtnEvent:(()->())?

    
    let loginOut = UIButton().then{
        $0.backgroundColor = .clear
        $0.setTitleColor(Color(0x3660fb), for: .normal)
        $0.setTitle("退出当前账号", for: .normal)
        $0.layer.cornerRadius = fit(44)
        $0.layer.borderColor = Color(0x3660fb).cgColor
        $0.layer.borderWidth = fit(2)
        $0.titleLabel?.font = Font(32)
    }
    
    func bindEvent(){
        loginOut.addTarget(self, action: #selector(logoutAction), for: .touchUpInside)
    }
    
    @objc func logoutAction(){
        guard let clickEvent = clickBtnEvent else {return}
        clickEvent()
    }

    override func setupView() {
        self.contentView.backgroundColor = Color(0xf5f5f5)
        hidLine()
        self.contentView.addSubview(loginOut)
        bindEvent()

        loginOut.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(147)
            make.right.equalToSuperview().snOffset(-147)
            make.height.snEqualTo(88)
            make.centerY.equalToSuperview()
        }
        
    }

}
