//
//  RmdCodeController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/5/13.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class RmdCodeController: SNBaseViewController {
    
    let imgBack = UIImageView().then{
        $0.image = UIImage(named: "reommend")
        $0.layer.cornerRadius = fit(8)
    }
    
    let codeView = QRCodeView().then({
        $0.layer.cornerRadius = fit(10)
        $0.layer.masksToBounds = true
    })
    
    let notice = UILabel().then{
        $0.textColor = Color(0xffffff)
        $0.text = "扫描进驻筋斗云"
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        //定位
    }
    
    override func setupView() {
        self.title = "我的推荐二维码"
        self.view.backgroundColor = Color(0xffffff)
        
        
        self.view.addSubviews(views: [imgBack])
        imgBack.addSubviews(views: [codeView,notice])
        
        self.codeView.creatErcode("http://app.shijihema.cn/common/webRegister?refererId=\(XKeyChain.get(UITOKEN_UID))")

        
        imgBack.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview().offset(-LL_TabbarSafeBottomMargin)
        }
  
     
        notice.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().snOffset(-(LL_TabbarSafeBottomMargin + 100))
        }
        
        codeView.snp.makeConstraints { (make) in
            make.bottom.equalTo(notice.snp.top).snOffset(-30)
            make.centerX.equalToSuperview()
            make.width.height.snEqualTo(360)
        }
    }
}
