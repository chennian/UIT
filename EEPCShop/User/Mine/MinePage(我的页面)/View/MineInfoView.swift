//
//  InfoView.swift
//  seven
//
//  Created by Mac Pro on 2018/12/17.
//  Copyright © 2018年 CHENNIAN. All rights reserved.
//

import UIKit

class MineInfoView: SNBaseView {
    
    let img = UIImageView().then{
        $0.backgroundColor = .clear
    }
    
    let name = UILabel().then{
        $0.font = Font(32)
        $0.textColor = Color(0x262626)
    }
    
    let accessoryImageView = UIImageView().then {
        $0.image = Image("back")
    }
    let line = UIView().then{
        $0.backgroundColor = Color(0xd3dbea)
    }
    
    override func setupView() {
        self.addSubviews(views: [img,name,accessoryImageView,line])
        
        img.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(46)
            make.centerY.equalToSuperview()
            make.height.width.snEqualTo(40)
        }
        
        name.snp.makeConstraints { (make) in
            make.centerY.equalTo(img.snp.centerY)
            make.left.equalTo(img.snp.right).snOffset(17)
        }
        
        accessoryImageView.snp.makeConstraints { (make) in
            make.right.equalToSuperview().snOffset(-42)
            make.centerY.equalToSuperview()
            make.width.height.snEqualTo(30)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(30)
            make.right.equalToSuperview().snOffset(-30)
            make.height.snEqualTo(1)
            make.bottom.equalToSuperview()
        }
    }
}
extension MineInfoView{
    
    func hidLine(){
        self.line.isHidden = true
    }
    
    func set(img:UIImage,name: String) {
        self.img.image = img
        self.name.text = name
    }
}
