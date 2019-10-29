//
//  WalletHeadInfoCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/2.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class WalletHeadInfoCell: SNBaseTableViewCell {
    
    var clickEvent:(()->())?
    
    var addEvent:(()->())?


    let baseView = UIImageView().then{
        $0.image = UIImage(named: "walletLayer1")
        $0.isUserInteractionEnabled = true
    }
    
    let name = UILabel().then{
        $0.text = "UIToken"
        $0.textColor = Color(0xffffff)
        $0.font = Font(36)
    }
    
    let scanBtn = UIButton().then{
        $0.backgroundColor = Color(0xffffff)
        $0.layer.cornerRadius = fit(24.5)
        $0.setTitle("扫一扫", for: .normal)
        $0.setTitleColor(Color(0x3660fb), for: .normal)
        $0.titleLabel?.font = Font(22)
        $0.isHidden = true
    }
    
    
    let addBtn = UIButton().then{
        $0.backgroundColor = Color(0xffffff)
        $0.layer.cornerRadius = fit(24.5)
        $0.setTitle("添 加", for: .normal)
        $0.setTitleColor(Color(0x3660fb), for: .normal)
        $0.titleLabel?.font = Font(22)
    }
    
    let total = UILabel().then{
        $0.text = "≈" + "75,668.62"
        $0.textColor = Color(0xffffff)
        $0.font = Font(62)
    }
    
    let des = UILabel().then{
        $0.text = "总资产(￥)"
        $0.textColor = Color(0xffffff)
        $0.font = Font(28)
    }
    
    @objc func click(){
        guard let action = clickEvent else {
            return
        }
        action()
    }
    
    @objc func clickAction(){
        guard let action = addEvent else {
            return
        }
        action()
    }
    
    func bindEvent(){
        scanBtn.addTarget(self, action: #selector(click), for: .touchUpInside)
        addBtn.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
    }
    override func setupView() {
        hidLine()
        self.contentView.addSubview(baseView)
        bindEvent()
        
        baseView.addSubviews(views: [name,scanBtn,total,des,addBtn])
        
        baseView.snp.makeConstraints { (make) in
            make.top.right.bottom.left.equalToSuperview()
        }
        
        name.snp.makeConstraints { (make) in
            make.top.equalToSuperview().snOffset(70 + LL_Extra)
            make.centerX.equalToSuperview()
        }
        
        scanBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(name.snp.centerY)
            make.left.equalToSuperview().snOffset(30)
            make.height.snEqualTo(50)
            make.width.snEqualTo(104)
        }
        
        addBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(name.snp.centerY)
            make.right.equalToSuperview().snOffset(-30)
            make.height.snEqualTo(50)
            make.width.snEqualTo(104)
        }
        
        total.snp.makeConstraints { (make) in
            make.centerX.equalTo(name.snp.centerX)
            make.top.equalTo(name.snp.bottom).snOffset(138)
        }
        
        des.snp.makeConstraints { (make) in
            make.centerX.equalTo(name.snp.centerX)
            make.top.equalTo(total.snp.bottom).snOffset(28)
        }
        
        
    }
    
}
extension WalletHeadInfoCell{
    func set(num:String) {
        self.total.text = "≈" + num
    }
    
}
