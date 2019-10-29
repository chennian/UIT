//
//  AgreementController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/26.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class AgreementController: SNBaseViewController {
    
    let backView = UIView().then{
        $0.backgroundColor = Color(0xffffff)
        $0.layer.cornerRadius = fit(20)
    }
    
    let backBtn = UIButton().then{
        $0.setImage(Image("back_black"), for: .normal)
    }
    
    let name = UILabel().then{
        $0.text = "注册协议"
        $0.textColor = Color(0x262626)
        $0.font = Font(36)
    }
    
    let textView = UITextView().then{
        $0.backgroundColor = Color(0xffffff)
        $0.textColor = Color(0x262626)
    }
}


extension AgreementController {
    
    
    /// setup view -- 加载视图
    override func setupView() {
        self.title = "忘记密码"
        
        view.backgroundColor = Color(0xf5f2f7)
        
        
        view.addSubviews(views: [backView,textView])
        backView.addSubviews(views: [backBtn,name])
        
        
        backView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(64 + LL_StatusBarExtraHeight)
        }
        
        backBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(30)
            make.width.height.snEqualTo(40)
            make.bottom.equalToSuperview().snOffset(-25)
        }
        
        name.snp.makeConstraints { (make) in
            make.centerY.equalTo(backBtn.snp.centerY)
            make.centerX.equalToSuperview()
        }
        
        textView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(backView.snp.bottom).snOffset(20)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func backAction(){
        self.dismiss(animated: true, completion: nil)
    }
    

    override func loadData() {
        
        let url = httpUrl + "/common/getAgreement"
        let para = ["id":"1"];
        Alamofire.request(url, method: .post, parameters:para, headers:nil).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                CNLog(jsonData["data"]["content"].stringValue)
                DispatchQueue.main.async {
                    self.textView.text = jsonData["data"]["content"].stringValue
                }
            }else{
                if !jsonData["msg"].stringValue.isEmpty{
                    SZHUD(jsonData["msg"].stringValue , type: .info, callBack: nil)
                }else{
                    SZHUD("请求错误" , type: .error, callBack: nil)
                }
            }
        }
    }
    
    
    ///  bind event -- 绑定事件处理
    override func bindEvent() {
        
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        
    }
}
