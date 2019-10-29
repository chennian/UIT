//
//  ShopCouponCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/5/17.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class ShopCouponCell: SNBaseTableViewCell {
    
    var clickEvent:(()->())?
    
    var model : HomePageModel?{
        didSet{
            guard let cellModel = model else {
                return
            }
            discount.text = String(format: "%.1f", Float(cellModel.user_discount)! * 10) + "折"
            couponLable.text = "满" + cellModel.base + "减" + cellModel.bouns
        }
    }
    
    
    private let descriptionLabel = UILabel().then{
        $0.text = "优惠"
        $0.textColor = Color(0x878787)
        $0.font = Font(26)
    }
    
    private let lineLeft = UIView().then{
        $0.backgroundColor = Color(0x878787)
    }
    
    private let lineRight = UIView().then{
        $0.backgroundColor = Color(0x878787)
    }
    
    
    let discount = UILabel().then{
        $0.font = Font(24)
        $0.text = ""
        $0.textColor = Color(0xff4242)
        $0.layer.borderWidth = fit(1)
        $0.layer.borderColor = Color(0xffc1c1).cgColor
        $0.layer.cornerRadius = fit(2)
        $0.textAlignment = .center
    }
    
    let couponLable = UILabel().then{
        $0.font = Font(24)
        $0.text = "满100减7"
        $0.textColor = Color(0xff4242)
        $0.layer.borderWidth = fit(1)
        $0.layer.borderColor = Color(0xffc1c1).cgColor
        $0.layer.cornerRadius = fit(2)
        $0.textAlignment = .center
    }
    

    
    let couponButton = UIButton().then{
        $0.setTitle("领劵", for: .normal)
        $0.layer.cornerRadius = fit(5)
        $0.backgroundColor = Color(0xff4242)
        $0.setTitleColor(Color(0xffffff), for: .normal)
        $0.titleLabel?.font = Font(32)
    }
    
    @objc func getCoupon(){
        guard let action = clickEvent else {
            return
        }
        action()
    }
    
    override func setupView() {
        
        line.isHidden = true
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(lineLeft)
        contentView.addSubview(lineRight)
        contentView.addSubview(couponLable)
        contentView.addSubview(discount)
        contentView.addSubview(couponButton)

        couponButton.addTarget(self, action: #selector(getCoupon), for: .touchUpInside)
        
        descriptionLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().snOffset(25)
            make.centerX.equalToSuperview()
        }
        lineLeft.snp.makeConstraints { (make) in
            make.centerY.equalTo(descriptionLabel.snp.centerY)
            make.right.equalTo(descriptionLabel.snp.left).snOffset(-12)
            make.height.snEqualTo(1)
            make.width.snEqualTo(60)
        }
        lineRight.snp.makeConstraints { (make) in
            make.left.equalTo(descriptionLabel.snp.right).snOffset(12)
            make.centerY.equalTo(descriptionLabel.snp.centerY)
            make.width.snEqualTo(60)
            make.height.snEqualTo(1)
        }
        
        discount.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(30)
            make.top.equalTo(descriptionLabel.snp.bottom).snOffset(30)
            make.width.snEqualTo(100)
            make.height.snEqualTo(40)
        }
        
        couponLable.snp.makeConstraints { (make) in
            make.left.equalTo(discount.snp.right).snOffset(10)
            make.centerY.equalTo(discount.snp.centerY)
            make.width.snEqualTo(150)
            make.height.snEqualTo(40)
        }
        
        couponButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().snOffset(-30)
            make.centerY.equalTo(discount.snp.centerY)
            make.width.snEqualTo(120)
            make.height.snEqualTo(50)

        }
        
        
    }
    
}

