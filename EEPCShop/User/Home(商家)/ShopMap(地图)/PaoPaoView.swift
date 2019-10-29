//
//  PaoPaoView.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/24.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class PaoPaoView: UIView {
    
    var tapEvent:(()->())?

    
    var model:HomePageModel? {
        didSet{
            guard  let cellModel = model else {
                return
            }
            
            name.text = cellModel.shop_name
            
            let discount = (Float(model!.user_discount)!) * 10
            des.text =  String(format: "%.1f", discount) + "折"
            address.text = cellModel.province + cellModel.city + cellModel.address_detail
            
            
            img.kf.setImage(with: URL(string: httpUrl + cellModel.main_img))
        }
    }
    
    let baseView = UIView().then{
        $0.backgroundColor = ColorRGB(red: 254, green: 253, blue: 253)
        $0.layer.cornerRadius = fit(16)
    }
    
    let img = UIImageView().then{
        $0.contentMode = .scaleToFill
        $0.backgroundColor = .red
        $0.layer.cornerRadius = fit(8)
    }
    
    let name = UILabel().then{
        $0.font = BoldFont(32)
        $0.textColor = ColorRGB(red: 42, green: 52, blue: 87)
        $0.text = "店家名称"
    }
    
    let des = UILabel().then{
        $0.font = Font(26)
        $0.textColor = ColorRGB(red: 42, green: 52, blue: 87)
        $0.text = ""
    }
    
    let address = UILabel().then{
        $0.font = Font(26)
        $0.textColor = ColorRGB(red: 169, green: 174, blue: 190)
        $0.text = "深圳市龙华区民治街道嘉熙业广场"
    }
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func pushAction(){
        guard let click = tapEvent else{
            return
        }
        click()
    }
    
    func setupView() {
        self.addSubview(baseView)
        baseView.addSubview(img)
        baseView.addSubview(name)
        baseView.addSubview(des)
        baseView.addSubview(address)
        
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(pushAction))
        self.addGestureRecognizer(tap)
        
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
            make.top.equalTo(img.snp.top).snOffset(4)
            make.left.equalTo(img.snp.right).snOffset(24)
        }
        
        des.snp.makeConstraints { (make) in
            make.top.equalTo(name.snp.bottom).snOffset(22)
            make.left.equalTo(img.snp.right).snOffset(24)
        }
        
        address.snp.makeConstraints { (make) in
            make.bottom.equalTo(img.snp.bottom).snOffset(-6)
            make.left.equalTo(img.snp.right).snOffset(24)
            make.right.equalToSuperview().snOffset(-20)
        }
    }
        


}
