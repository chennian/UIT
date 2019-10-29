//
//  InfoEditCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/17.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class InfoEditCell: SNBaseTableViewCell {
    
    var clickEvent:(()->())?
    var clickButton:(()->())?
    
    let baseView = UIView().then{
        $0.backgroundColor = Color(0xffffff)
        $0.layer.cornerRadius = fit(20)
        $0.isUserInteractionEnabled = true
    }
    
    let imageLable = UILabel().then{
        $0.text = "头像"
        $0.textColor = Color(0x2a3457)
        $0.font = Font(32)
    }
    
    let imageImageView = UIButton().then{
        $0.layer.cornerRadius = fit(52)
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
    }
    
    let arrow = UIImageView().then{
        $0.image = UIImage(named: "back")
    }
    
    let lineOne = UIView().then{
        $0.backgroundColor = Color(0xdcdcdc)
    }
    
    let nickLable = UILabel().then{
        $0.textColor = Color(0x2a3457)
        $0.text = "昵称"
        $0.font = Font(32)
    }
    
    let niceName = UITextField().then{
        $0.textColor = Color(0x2a3457)
        $0.text = ""
        $0.font = Font(32)
        $0.borderStyle = .none
        $0.textAlignment = .right
    }
    
    let lineTwo = UIView().then{
        $0.backgroundColor = Color(0xdcdcdc)
    }

    let saveButton = UIButton().then{
        $0.setTitle("保存", for: .normal)
        $0.backgroundColor = Color(0x3660fb)
        $0.layer.cornerRadius = fit(49)
        $0.titleLabel?.font = Font(30)
    }
    
    @objc func tapAction() -> Void {
        guard let action = clickEvent else {
            return
        }
        action()
    }
    
    
    @objc func clickAction() -> Void {
        guard let action = clickButton else {
            return
        }
        action()
    }
    
   func bindEvent(){
    imageImageView.addTarget(self, action: #selector(tapAction), for: .touchUpInside)
    saveButton.addTarget(self, action:#selector(clickAction), for: .touchUpInside)
    
    }
    
    override func setupView() {
        
        bindEvent()
        
        self.contentView.backgroundColor = Color(0xf5f5f5)
        
        hidLine()
        
        self.contentView.addSubviews(views: [baseView])

        baseView.addSubviews(views: [imageLable,imageImageView,arrow,lineOne,nickLable,niceName,lineTwo,saveButton])
        
        baseView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().snOffset(30)
            make.left.equalToSuperview().snOffset(30)
            make.right.equalToSuperview().snOffset(-30)
            make.height.snEqualTo(626)
        }
        
        imageLable.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(50)
            make.top.equalToSuperview().snOffset(107)
        }
        
        arrow.snp.makeConstraints { (make) in
            make.right.equalToSuperview().snOffset(-52)
            make.centerY.equalTo(imageLable.snp.centerY)
            make.width.snEqualTo(20)
            make.height.snEqualTo(30)
        }
        
        imageImageView.snp.makeConstraints { (make) in
            make.right.equalTo(arrow.snp.left).snOffset(-36)
            make.centerY.equalTo(arrow.snp.centerY)
            make.height.width.snEqualTo(106)
        }
        
        lineOne.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(34)
            make.top.equalTo(imageLable.snp.bottom).snOffset(73)
            make.right.equalToSuperview()
            make.height.snEqualTo(1)
        }
        
        nickLable.snp.makeConstraints { (make) in
            make.top.equalTo(lineOne.snp.bottom).snOffset(39)
            make.left.equalToSuperview().snOffset(50)
        }
        
        niceName.snp.makeConstraints { (make) in
            make.centerY.equalTo(nickLable.snp.centerY)
            make.right.equalToSuperview().snOffset(-53)
            make.width.snEqualTo(300)
        }
        
        lineTwo.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(34)
            make.right.equalToSuperview()
            make.top.equalTo(nickLable.snp.bottom).snOffset(39)
            make.height.snEqualTo(1)
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(lineTwo.snp.bottom).snOffset(156)
            make.height.snEqualTo(98)
            make.width.snEqualTo(572)
        }
        
    }
}
