//
//  MerchantCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/2.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class MerchantCell: SNBaseTableViewCell {
    
    var model:HomePageModel? {
        didSet{
            guard  let cellModel = model else {
                return
            }
            
            name.text = cellModel.shop_name
            
            let discount = Float(model!.eepc_ratio)!  + Float(model!.usdt_ratio)!
            
            let discountF = discount * 10

            des.text = String(format: "%.1f", discountF) + "折"
//            des.text =  cellModel.lable
            cat.text = cellModel.lable
            
            self.discount.text = "满" + cellModel.base + "减" + cellModel.bouns

            address.text = cellModel.province + cellModel.city + cellModel.address_detail
            
            img.kf.setImage(with: URL(string: imgUrl + cellModel.main_img))
            
            if XKeyChain.get(latitudeKey).isEmpty {
                distance.text = "暂未定位"
            }else{
                let point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(Double(XKeyChain.get(latitudeKey))!,Double(XKeyChain.get(longiduteKey))!))
                //            let point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(111.2323232,34.23121))
                let point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(Double(cellModel.lat)!,Double(cellModel.lng)!))
                
                let distanceMI = String(format: "%.2f", BMKMetersBetweenMapPoints(point1,point2)/1000)
                
                distance.text = distanceMI + "km"
            }
            
        }
    }
    
    let baseView = UIView().then{
        $0.backgroundColor = ColorRGB(red: 254, green: 253, blue: 253)
        $0.layer.cornerRadius = fit(16)
    }
    
    let img = UIImageView().then{
        $0.contentMode = .scaleToFill
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = fit(8)
        $0.layer.masksToBounds = true
    }

    let name = UILabel().then{
        $0.font = BoldFont(30)
        $0.textColor = ColorRGB(red: 42, green: 52, blue: 87)
        $0.text = "店家名称"
    }
    
    let des = UILabel().then{
        $0.font = Font(24)
        $0.text = ""
        $0.textColor = Color(0xff4242)
        $0.layer.borderWidth = fit(1)
        $0.layer.borderColor = Color(0xffc1c1).cgColor
        $0.layer.cornerRadius = fit(2)
        //        $0.isHidden = true
        $0.textAlignment = .center
    }
//    let discount = UILabel().then{
//        $0.font = Font(24)
//        $0.text = "满100减7"
//        $0.textColor = Color(0xff4242)
//        $0.layer.borderWidth = fit(1)
//        $0.layer.borderColor = Color(0xffc1c1).cgColor
//        $0.layer.cornerRadius = fit(2)
//        $0.textAlignment = .center
//    }
//
//    let couponLable = UILabel().then{
//        $0.font = Font(24)
//        $0.text = "领劵"
//        $0.textColor = Color(0xff4242)
//        $0.layer.borderWidth = fit(1)
//        $0.layer.borderColor = Color(0xffc1c1).cgColor
//        $0.layer.cornerRadius = fit(2)
//        //        $0.isHidden = true
//        $0.textAlignment = .center
//    }
    
    
    let couponImage = UIImageView().then{
        $0.image = UIImage(named: "conpon1")
        $0.layer.cornerRadius = fit(2)
        $0.isHidden = true
//        $0.contentMode = .scaleAspectFill
    }
    let discount = UILabel().then{
        $0.font = Font(24)
        $0.text = ""
        $0.textColor = Color(0xff4242)
        $0.textAlignment = .center
        $0.isHidden = true
    }

    let couponLable = UILabel().then{
        $0.font = Font(24)
        $0.text = "领劵"
        $0.textColor = Color(0xff4242)
        $0.textAlignment = .center
        $0.isHidden = true
    }
    
    let cat = UILabel().then{
        $0.font = Font(24)
        $0.textColor = Color(0xff7e00)
    }
    
    let address = UILabel().then{
        $0.font = Font(26)
        $0.textColor = ColorRGB(red: 169, green: 174, blue: 190)
        $0.text = "深圳市龙华区民治街道嘉熙业广场"
    }
    
    let distance = UILabel().then{
        $0.font = Font(26)
        $0.textColor = ColorRGB(red: 169, green: 174, blue: 190)
        $0.text = ""
    }
    
    
    override func setupView() {
        hidLine()

        self.contentView.backgroundColor = Color(0xf5f5f5)
        self.contentView.addSubview(baseView)
        baseView.addSubview(img)
        baseView.addSubview(name)
        
        baseView.addSubview(couponImage)
        
        baseView.addSubview(discount)
        baseView.addSubview(des)
        baseView.addSubview(cat)
        baseView.addSubview(couponLable)
        baseView.addSubview(address)
        baseView.addSubview(distance)
        
        baseView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.height.snEqualTo(206)
            make.width.snEqualTo(690)
        }
        
        img.snp.makeConstraints { (make) in
            make.centerY.equalTo(baseView.snp.centerY)
            make.left.equalTo(baseView.snp.left).snOffset(20)
            make.height.width.snEqualTo(168)
        }
        
        name.snp.makeConstraints { (make) in
            make.top.equalTo(img.snp.top)
            make.left.equalTo(img.snp.right).snOffset(24)
        }
        
        des.snp.makeConstraints { (make) in
            make.top.equalTo(name.snp.bottom).snOffset(10)
            make.left.equalTo(img.snp.right).snOffset(24)
            make.height.snEqualTo(40)
            make.width.snEqualTo(80)
        }


        couponImage.snp.makeConstraints { (make) in
            make.left.equalTo(des.snp.right).snOffset(10)
            make.centerY.equalTo(des.snp.centerY)
            make.width.snEqualTo(210)
            make.height.snEqualTo(40)
        }

        discount.snp.makeConstraints { (make) in
            make.left.equalTo(couponImage.snp.left).snOffset(10)
            make.centerY.equalTo(couponImage.snp.centerY)
        }

        couponLable.snp.makeConstraints { (make) in
            make.right.equalTo(couponImage.snp.right).snOffset(-10)
            make.centerY.equalTo(couponImage.snp.centerY)
        }
//
        
//        discount.snp.makeConstraints { (make) in
//            make.top.equalTo(name.snp.bottom).snOffset(10)
//            make.left.equalTo(des.snp.right).snOffset(10)
//            make.height.snEqualTo(40)
//            make.width.snEqualTo(130)
//        }
//
//
//        couponLable.snp.makeConstraints { (make) in
//            make.left.equalTo(discount.snp.right).snOffset(10)
//            make.centerY.equalTo(discount.snp.centerY  )
//            make.height.snEqualTo(40)
//            make.width.snEqualTo(80)
//        }
        
        cat.snp.makeConstraints { (make) in
            make.left.equalTo(img.snp.right).snOffset(24)
            make.top.equalTo(discount.snp.bottom).snOffset(14)
            make.right.equalToSuperview().snOffset(-100)
        }
        
        
        
        distance.snp.makeConstraints { (make) in
            make.right.equalToSuperview().snOffset(-30)
            make.centerY.equalTo(des.snp.centerY)
        }
        
        address.snp.makeConstraints { (make) in
            make.bottom.equalTo(img.snp.bottom)
            make.left.equalTo(img.snp.right).snOffset(24)
            make.right.equalToSuperview().snOffset(-20)
        }
    }
}
extension MerchantCell{
    func  setCoupon(_ total:String,_ num:String){
    }
}
