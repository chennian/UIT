//
//  PaySuccessController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/27.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class PaySuccessController: SNBaseViewController {
    
    var shop_img :String = ""
    var shop_name:String = ""
    var pay_num :String = ""
    
    let successImg = UIImageView().then{
        $0.image = UIImage(named: "uitoken")
        $0.contentMode = .scaleAspectFill
        $0.layer.cornerRadius = fit(8)
        $0.layer.masksToBounds = true
    }
    
    let successLable = UILabel().then{
        $0.text = "支付成功"
        $0.textColor = ColorRGB(red: 10.0, green: 163.0, blue: 0.0)
        $0.font = Font(30)
    }
    
    let payNum = UILabel().then{
        $0.text = "￥ 0.00"
        $0.font = BoldFont(80)
        $0.textColor = Color(0x313131)
    }
    
    let receiveLable = UILabel().then{
        $0.text = "收款方"
        $0.font = Font(30)
        $0.textColor = ColorRGB(red: 153.0 , green: 153.0  , blue: 153.0)
    }
    
    let shopImg = UIImageView().then{
        $0.kf.setImage(with: URL(string: ""))
        $0.layer.cornerRadius = fit(8)
        $0.layer.masksToBounds = true
    }
    let shopName = UILabel().then{
        $0.text = "0.00"
        $0.textColor = ColorRGB(red: 55.0, green: 55.0, blue: 55.0)
        $0.font = Font(30)
    }
    
    let finishbtn = UIButton().then{
        $0.setTitle("完成", for: .normal)
        $0.setTitleColor(ColorRGB(red: 10.0, green: 163.0, blue: 0.0), for: .normal)
        $0.titleLabel?.font = Font(30)
        $0.layer.cornerRadius = fit(8)
        $0.layer.borderColor = ColorRGB(red: 10.0, green: 163.0, blue: 0.0).cgColor
        $0.layer.borderWidth = fit(1)
    }
    
    let time = UILabel().then{
        $0.textColor =  ColorRGB(red: 153.0 , green: 153.0  , blue: 153.0)
        $0.text = ""
        $0.font = Font(30)
    }
    @objc func finishAction(){
        for i in 0..<(self.navigationController?.viewControllers.count)! {
            if self.navigationController?.viewControllers[i].isKind(of: WalletInfoController.self) == true {
                _ = self.navigationController?.popToViewController(self.navigationController?.viewControllers[i] as! WalletInfoController, animated: true)
                break
                
            }
        }
    }

    
    override func setupView() {
        self.navigationController?.navigationBar.isHidden = true
        
        self.view.addSubviews(views: [successImg,successLable,payNum,receiveLable,shopImg,shopImg,shopName,finishbtn,time])
        
        finishbtn.addTarget(self, action: #selector(finishAction), for: .touchUpInside)
        
        
        self.payNum.text =  "￥\(self.pay_num)"
        self.shopName.text = self.shop_name
        self.shopImg.kf.setImage(with: URL(string: shop_img))
        
        
        let date = NSDate.init()
        let dateFormater = DateFormatter.init()
        
        dateFormater.dateFormat = "YYYY-MM-dd HH:mm:ss"
        
        let dateStr = dateFormater.string(from: date as Date)
        self.time.text = dateStr
        
        
        successImg.snp.makeConstraints { (make) in
            make.top.equalToSuperview().snOffset(200)
            make.centerX.equalToSuperview()
            make.width.snEqualTo(100)
            make.height.snEqualTo(100)
        }
        
        successLable.snp.makeConstraints { (make) in
            make.centerX.equalTo(successImg.snp.centerX)
            make.top.equalTo(successImg.snp.bottom).snOffset(50)
        }
        
        payNum.snp.makeConstraints { (make) in
            make.top.equalTo(successLable.snp.bottom).snOffset(100)
            make.centerX.equalTo(successLable.snp.centerX)
        }
        
        receiveLable.snp.makeConstraints { (make) in
            make.top.equalTo(payNum.snp.bottom).snOffset(80)
            make.centerX.equalTo(payNum.snp.centerX)
        }
        
        shopImg.snp.makeConstraints { (make) in
            make.top.equalTo(receiveLable.snp.bottom).snOffset(30)
            make.centerX.equalTo(receiveLable.snp.centerX)
            make.width.height.snEqualTo(120)
        }
        
        shopName.snp.makeConstraints { (make) in
            make.top.equalTo(shopImg.snp.bottom).snOffset(25)
            make.centerX.equalTo(shopImg.snp.centerX)
        }
        
        finishbtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(160)
            make.right.equalToSuperview().snOffset(-160)
            make.bottom.equalToSuperview().snOffset(-300)
            make.height.snEqualTo(80)
        }
        
        time.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(finishbtn.snp.bottom).snOffset(30)
        }
    
    }
    
}
