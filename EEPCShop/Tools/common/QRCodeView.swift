//
//  QRCodeView.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/21.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class QRCodeView: SNBaseView {
    var icon :UIImage?
    func creatErcode(_ address:String){
//        let url = "http://frontend.xiaoheixiong.net/public/recommend?phone="
        let img = QRCodeTool.creatQRCodeImage(text: address, size: fit(480), icon: nil)
        ercodeBtn.setImage(img, for: UIControl.State.normal)
    }
    
    func creatReceiveErcode(_ shopId:String){
        let url = "http://pay.xiaoheixiong.net/public/getOpenid_uid?shop_id=" + shopId
        let img = QRCodeTool.creatQRCodeImage(text: url, size: fit(480), icon: nil)
        ercodeBtn.setImage(img, for: .normal)
    }
    
    func creatDownErcode(_ url:String){
        let img = QRCodeTool.creatQRCodeImage(text: url, size: fit(480), icon: UIImage(named: "downlogo"))
        ercodeBtn.setImage(img, for: .normal)
    }
    
    let ercodeBtn = UIButton()
    
    override func setupView() {
        
        addSubview(ercodeBtn)
        
        ercodeBtn.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview()
        }
    }
    
}
