//
//  DownLoadCodeController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/5/2.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class DownLoadCodeController: SNBaseViewController {
    
    
    let imgBack = UIImageView().then{
        $0.image = UIImage(named: "download")
        $0.layer.cornerRadius = fit(8)
    }
    
    let logo = UIImageView().then{
        $0.image = UIImage(named: "logo")
        $0.isHidden = true
    }
    
    let label_anrdord = UILabel().then{
        $0.text = "安卓下载二维码"
        $0.textColor = Color(0xffffff)
        $0.font = Font(30)
    }
    
    let label_ios = UILabel().then{
        $0.text = "苹果下载二维码"
        $0.textColor = Color(0xffffff)
        $0.font = Font(30)
    }
    
    let codeView_anrdord = QRCodeView().then({
        $0.layer.cornerRadius = fit(10)
    })
    
    let codeView_ios = QRCodeView().then({
        $0.layer.cornerRadius = fit(10)
    })
    
    override func loadData() {
        let url = httpUrl + "/common/getDownUrl"
        Alamofire.request(url, method: .post, parameters:nil, headers:nil).responseJSON { [unowned self](res) in
            let jsonData = JSON(data: res.data!)
            if  jsonData["code"].intValue == 1000{
                CNLog(jsonData["data"])
                DispatchQueue.main.async {
                    self.codeView_anrdord.creatDownErcode(jsonData["data"].stringValue)
                    self.codeView_ios.creatDownErcode("https://apps.apple.com/cn/app/uit/id1467148026")

                }
            }else{
                SZHUD(jsonData["msg"].stringValue , type: .error, callBack: nil)
            }
        }
    }
    
    override func setupView() {
        self.title = "下载App"
        navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = Color(0xffffff)
        

        
        self.view.addSubviews(views: [imgBack])
        imgBack.addSubviews(views: [logo,codeView_anrdord,codeView_ios,label_anrdord,label_ios])
        
        imgBack.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        logo.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().snOffset(150)
            make.width.snEqualTo(103)
            make.height.snEqualTo(148)
        }
   
        
        codeView_anrdord.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().snOffset(-300)
            make.width.height.snEqualTo(300)
        }
        
        label_anrdord.snp.makeConstraints { (make) in
            make.bottom.equalTo(codeView_anrdord.snp.top).snOffset(-30)
            make.centerX.equalToSuperview()
        }
        
        codeView_ios.snp.makeConstraints { (make) in
            make.top.equalTo(codeView_anrdord.snp.bottom).snOffset(200)
            make.centerX.equalToSuperview()
            make.width.height.snEqualTo(300)
        }
        
        label_ios.snp.makeConstraints { (make) in
            make.bottom.equalTo(codeView_ios.snp.top).snOffset(-30)
            make.centerX.equalToSuperview()
        }
        
    }
}
