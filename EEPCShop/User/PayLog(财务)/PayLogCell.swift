//
//  PayLogCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/5/11.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class PayLogCell: SNBaseTableViewCell {
    
    var model:PayLogModel?{
        didSet{
            guard let cellModel = model else {
                return
            }
            
            shopName.text = cellModel.shop_name
            shopImg.kf.setImage(with: URL(string: imgUrl + cellModel.main_img))
            status.text = cellModel.remark
            time.text =  "支付时间:" + cellModel.pay_time
            total.text = "支付金额:" + cellModel.pay_num
//            discount.text = "优惠:" +  String(Float(cellModel.total)!  -  Float(cellModel.pay_num)!)
            discount.text = "支付EEPC:" +  String(Float(cellModel.pay_eepc)!)

        }
    }
    
    let baseView = UIView().then{
        $0.backgroundColor = Color(0xffffff)
        $0.layer.cornerRadius = fit(10)
    }
    
    let shopName = UILabel().then{
        $0.font = BoldFont(32)
        $0.textColor = Color(0x2a3457)
        $0.text = "好兄弟"
    }
    
    let status = UILabel().then{
        $0.font = Font(30)
        $0.textColor = Color(0x858585)
        $0.text = "已完成"
    }
    
    let underLine = UIView().then{
        $0.backgroundColor = Color(0xdcdcdc)
    }
    
    let shopImg = UIImageView().then{
        $0.backgroundColor  = Color(0xf5f5f5)
    }
    let time = UILabel().then{
        $0.font = Font(24)
        $0.textColor = Color(0x858585)
        $0.text = "付款时间:2019-05-11 01:24:43"
    }
    
    let total = UILabel().then{
        $0.font = Font(24)
        $0.textColor = Color(0x858585)
        $0.text = "付款金额:￥1000"
    }
    
    let discount = UILabel().then{
        $0.font = Font(24)
        $0.textColor = Color(0x858585)
        $0.text = "优惠:￥10"
    }
    
    
    
    override func setupView() {
        hidLine()
        self.contentView.backgroundColor = Color(0xf5f5f5)
        self.contentView.addSubview(self.baseView)
        self.baseView.addSubviews(views: [shopName,status,underLine,shopImg,time,total,discount])
        
        self.baseView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(20)
            make.right.equalToSuperview().snOffset(-20)
            make.top.equalToSuperview().snOffset(10)
            make.bottom.equalToSuperview().snOffset(-10)
        }
        
        
        underLine.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(10)
            make.right.equalToSuperview().snOffset(-10)
            make.top.equalToSuperview().snOffset(80)
            make.height.snEqualTo(1)
        }
        
        shopName.snp.makeConstraints { (make) in
            make.bottom.equalTo(underLine.snp.top).snOffset(-10)
            make.left.equalToSuperview().snOffset(10)
        }
        
        status.snp.makeConstraints { (make) in
            make.bottom.equalTo(underLine.snp.top).snOffset(-10)
            make.right.equalToSuperview().snOffset(-10)
        }
        
        shopImg.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(10)
            make.top.equalTo(underLine.snp.bottom).snOffset(30)
            make.width.height.snEqualTo(124)
        }
        
        time.snp.makeConstraints { (make) in
            make.top.equalTo(shopImg.snp.top)
            make.left.equalTo(shopImg.snp.right).snOffset(25)
        }
        
        total.snp.makeConstraints { (make) in
            make.top.equalTo(time.snp.bottom).snOffset(10)
            make.left.equalTo(shopImg.snp.right).snOffset(25)
        }
        
        
        discount.snp.makeConstraints { (make) in
            make.top.equalTo(total.snp.bottom).snOffset(10)
            make.left.equalTo(shopImg.snp.right).snOffset(25)
        }
    }
    
}
