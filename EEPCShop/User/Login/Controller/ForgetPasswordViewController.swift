//
//  ForgetPasswordViewController.swift
//  sevenloan
//
//  Created by spectator Mr.Z on 2018/12/4.
//  Copyright © 2018 tangxers. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ForgetPasswordViewController: SNBaseViewController {
    
    let backView = UIView().then{
        $0.backgroundColor = Color(0xffffff)
    }
    
    let backBtn = UIButton().then{
        $0.setImage(Image("back_black"), for: .normal)
    }
    
    let name = UILabel().then{
        $0.text = "忘记密码"
        $0.textColor = Color(0x262626)
        $0.font = Font(36)
    }
    
    let phoneView = ForgetPasswordInputView()
    let passwordView = ForgetPasswordInputView()
    let checkPasswordView = ForgetPasswordInputView()
    let key = ForgetPasswordInputView()

//    let smsCodeView = ForgetPasswordSMSView()
    let saveButton = BGButton().then {
        $0.set(content: "提交")
    }
}

extension ForgetPasswordViewController {
    
    func set(title: String) {
        self.title = title
    }
    
}

extension ForgetPasswordViewController {
    
    
    /// setup view -- 加载视图
    override func setupView() {
        self.title = "忘记密码"
        
        view.backgroundColor = Color(0xf5f2f7)
        
        phoneView.set(title: "手机号", placeholder: "请输入手机号")
        passwordView.set(title: "密码", placeholder: "请输入登录密码")
        checkPasswordView.set(title: "确认密码", placeholder: "请确认登录密码")
        key.set(title: "助记词或密钥", placeholder: "请输入钱包助记词或者密钥")

        
        let containView = UIView().then {
            $0.backgroundColor = .white
        }
        
        view.addSubviews(views: [backView,containView])
        backView.addSubviews(views: [backBtn,name])
        containView.addSubviews(views: [phoneView,passwordView,checkPasswordView,key,saveButton])
        passwordView.textField.isSecureTextEntry = true
        checkPasswordView.textField.isSecureTextEntry = true

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
        
        containView.snp.makeConstraints { (make) in
            make.left.snEqualToSuperview().snOffset(30)
            make.right.snEqualToSuperview().snOffset(-30)
            make.top.equalTo(backView.snp.bottom).snOffset(20)
        }
        
        phoneView.snp.makeConstraints { (make) in
            make.top.snEqualToSuperview().snOffset(30)
            make.left.snEqualToSuperview().snOffset(30)
            make.right.snEqualToSuperview().snOffset(-30)
            make.height.snEqualTo(100)
        }
        
        passwordView.snp.makeConstraints { (make) in
            make.top.snEqualTo(phoneView.snp.bottom)
            make.left.snEqualToSuperview().snOffset(30)
            make.right.snEqualToSuperview().snOffset(-30)
            make.height.snEqualTo(100)
        }
        
        checkPasswordView.snp.makeConstraints { (make) in
            make.top.snEqualTo(passwordView.snp.bottom)
            make.left.snEqualToSuperview().snOffset(30)
            make.right.snEqualToSuperview().snOffset(-30)
            make.height.snEqualTo(100)
        }
        
        key.snp.makeConstraints { (make) in
            make.top.snEqualTo(checkPasswordView.snp.bottom)
            make.left.snEqualToSuperview().snOffset(30)
            make.right.snEqualToSuperview().snOffset(-30)
            make.height.snEqualTo(100)
        }
        
        saveButton.snp.makeConstraints { (make) in
            make.top.snEqualTo(key.snp.bottom).snOffset(70)
            make.height.snEqualTo(100)
            make.width.snEqualTo(566)
            make.bottom.snEqualToSuperview().snOffset(-50)
            make.centerX.snEqualToSuperview()
        }
        
        saveButton.layer.cornerRadius = fit(50)
        
    }
    
    @objc func backAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func submitAction(){
        if phoneView.textField.text! == "" {
            SZHUD("请填写手机号", type: .info, callBack: nil)
            return
        }
        if passwordView.textField.text! == "" {
            SZHUD("请填写登录密码", type: .info, callBack: nil)
            return
        }
        if checkPasswordView.textField.text! == "" {
            SZHUD("请填写确认密码", type: .info, callBack: nil)
            return
        }
        
        if checkPasswordView.textField.text != passwordView.textField.text {
            SZHUD("两次密码不一致", type: .info, callBack: nil)
            return
        }
        
        if key.textField.text! == "" {
            SZHUD("请填写", type: .info, callBack: nil)
            return
        }
        
        let url = httpUrl + "/user/forgetPwd"
        let para = ["phone":phoneView.textField.text!,
                    "key":key.textField.text!,
                    "pwd":checkPasswordView.textField.text!];
        Alamofire.request(url, method: .post, parameters:para, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                SZHUD("提交成功", type: .success, callBack: nil)
                self.dismiss(animated: true, completion: nil)
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

        self.saveButton.addTarget(self, action: #selector(submitAction), for: .touchUpInside)
    }
}
