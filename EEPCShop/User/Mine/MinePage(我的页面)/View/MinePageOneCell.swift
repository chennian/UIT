//
//  MInePageOneCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/3.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class MinePageOneCell: SNBaseTableViewCell {
    
    var clickBtnEvent:((_ para:String)->())?
    
    let baseView = UIView().then{
        $0.backgroundColor = Color(0xffffff)
        $0.layer.cornerRadius = fit(20)
        $0.isUserInteractionEnabled = true
    }
    
    let one  = MineInfoView().then{
        $0.layer.cornerRadius = fit(20)
        $0.isUserInteractionEnabled = true
    }
    let two  = MineInfoView().then{
        $0.isUserInteractionEnabled = true
    }
    let three  = MineInfoView().then{
        $0.layer.cornerRadius = fit(20)
        $0.isUserInteractionEnabled = true
    }
    
    
    func bindEvent(){
        let tapOne = UITapGestureRecognizer.init(target: self, action: #selector(OneAction))
        one.addGestureRecognizer(tapOne)
        
        let tapTwo = UITapGestureRecognizer.init(target: self, action: #selector(TwoAction))
        two.addGestureRecognizer(tapTwo)
        
        let tapThree = UITapGestureRecognizer.init(target: self, action: #selector(ThreeAction))
        three.addGestureRecognizer(tapThree)
    }
    @objc func OneAction(){
        guard let clickEvent = clickBtnEvent else {return}
        clickEvent("1")
    }
    
    @objc func TwoAction(){
        guard let clickEvent = clickBtnEvent else {return}
        clickEvent("2")
    }
    @objc func ThreeAction(){
        guard let clickEvent = clickBtnEvent else {return}
        clickEvent("3")
    }
    
    override func setupView() {
        hidLine()
        self.contentView.backgroundColor = Color(0xf5f5f5)
        self.contentView.addSubview(self.baseView)
        self.baseView.addSubviews(views: [one,two,three])
        
        one.set(img:UIImage(named: "edit")!, name: "编辑资料")
        two.set(img:UIImage(named: "pay")!, name: "支付设置")
        three.set(img:UIImage(named: "password")!, name: "重置密码")
        three.hidLine()
        
        bindEvent()

        self.baseView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalToSuperview().snOffset(30)
            make.right.equalToSuperview().snOffset(-30)
        }
        
        one.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.snEqualTo(125)
        }
        
        two.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(one.snp.bottom)
            make.height.snEqualTo(125)
        }
        three.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(two.snp.bottom)
            make.height.snEqualTo(125)
        }
        
        
    }

    

}
