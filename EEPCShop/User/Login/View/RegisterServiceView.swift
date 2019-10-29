//
//  RegisterServiceView.swift
//  sevenloan
//
//  Created by spectator Mr.Z on 2018/12/4.
//  Copyright © 2018 tangxers. All rights reserved.
//

import UIKit

class RegisterServiceView:SNBaseView {
    var clickEvent:(()->())?
    
    let checkBtn = UIButton().then {
        $0.isSelected = false
    }
    
    let descLabel = UILabel().then {
        $0.font = Font(28)
    }
    
    let button = UIButton().then{
        $0.setTitle("服务协议", for: .normal)
        $0.titleLabel?.font = Font(28)
        $0.setTitleColor(Color(0x2777ff), for: .normal)
    }
    
    
    var checked : Bool {
        get {
            return checkBtn.isSelected
        }
    }
    
}

extension RegisterServiceView {
    
    func set(image: String, selectImage: String, desc: String, serviceButtonText: String) {
        
        checkBtn.setImage(Image(image), for: .normal)
        checkBtn.setImage(Image(selectImage), for: .selected)
        descLabel.text = desc
    }
    
}

extension RegisterServiceView {
    
    override func setupView() {
        
        addSubviews(views: [checkBtn,descLabel,button])
        
        checkBtn.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.snEqualTo(36)
        }
        
        descLabel.snp.makeConstraints { (make) in
            make.left.equalTo(checkBtn.snp.right).snOffset(20)
            make.centerY.snEqualToSuperview()
        }
        
        button.snp.makeConstraints { (make) in
            make.left.equalTo(descLabel.snp.right).snOffset(5)
            make.centerY.equalTo(descLabel.snp.centerY)
            make.height.snEqualTo(30)
            make.height.snEqualTo(120)
        }
        
    }
    
    @objc func click(){
        self.checkBtn.isSelected = !self.checkBtn.isSelected
        
    }
    @objc func clickAction(){
        guard let action = clickEvent else {
            return
        }
        action()
    }
    
    override func bindEvent() {
        checkBtn.addTarget(self, action: #selector(click), for: .touchUpInside)
        button.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        
    }
}
