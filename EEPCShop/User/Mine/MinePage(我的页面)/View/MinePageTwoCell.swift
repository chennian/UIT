//
//  MinePageTwoCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/3.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class MinePageTwoCell: SNBaseTableViewCell {
    
    var clickBtnEvent:(()->())?
    var clickEvent:(()->())?


    let baseView = UIView().then{
        $0.backgroundColor = Color(0xffffff)
        $0.layer.cornerRadius = fit(20)
    }
    
    let one  = MineInfoView().then{
        $0.layer.cornerRadius = fit(20)
    }
    let two  = MineInfoView().then{
        $0.layer.cornerRadius = fit(20)
    }
    
    
    @objc func OneAction(){
        guard let clickEvent = clickBtnEvent else {return}
        clickEvent()
    }
    
    @objc func TwoAction(){
        guard let clickEvent = clickEvent else {return}
        clickEvent()
    }
    
    func bindEvent(){
        let tapOne = UITapGestureRecognizer.init(target: self, action: #selector(OneAction))
        one.addGestureRecognizer(tapOne)
        
        let tapTwo = UITapGestureRecognizer.init(target: self, action: #selector(TwoAction))
        two.addGestureRecognizer(tapTwo)
    }

    
    override func setupView() {
        self.contentView.backgroundColor = Color(0xf5f5f5)
        self.contentView.addSubview(baseView)
        self.baseView.addSubviews(views: [one,two])
        
        hidLine()
        
        one.set(img:UIImage(named: "share")!, name: "下载App")
        one.hidLine()
        two.set(img:UIImage(named: "about")!, name: "推荐分润")
//        two.hidLine()
        
        bindEvent()
        
        self.baseView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().snOffset(30)
            make.right.equalToSuperview().snOffset(-30)
        }
        
        
        two.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.snEqualTo(125)
        }
        
        one.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(two.snp.bottom)
            make.height.snEqualTo(125)
        }
        
    }
    
}
