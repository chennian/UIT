//
//  RegisterViewController.swift
//  sevenloan
//
//  Created by spectator Mr.Z on 2018/12/3.
//  Copyright © 2018 tangxers. All rights reserved.
//

import UIKit
import Foundation
import SwiftyJSON
import Alamofire


class RegisterViewController: SNBaseViewController {

    let banner = UIImageView().then {
        $0.image = Image("registered_bg")
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = .white
        $0.text = "注册"
        $0.font = Font(36)
    }
    let backButton = UIButton().then {
        $0.setImage(Image("registered_back"), for: .normal)
    }
    
    
    let nickView = RegisterInputView().then{
        $0.backgroundColor = Color(0xffffff)
    }
    let phoneView = RegisterInputView().then{
        $0.backgroundColor = Color(0xffffff)
    }
    let passwordView = RegisterInputView().then{
        $0.backgroundColor = Color(0xffffff)
    }
    let confirmPasswordView = RegisterInputView().then{
        $0.backgroundColor = Color(0xffffff)
    }
    let payPwdView = RegisterInputView().then{
        $0.backgroundColor = Color(0xffffff)
    }
    let confirmPayPwdView = RegisterInputView().then{
        $0.backgroundColor = Color(0xffffff)
    }
    let smsCodeView = ForgetPasswordSMSView().then{
        $0.backgroundColor = Color(0xffffff)
    }
    let serviceView = RegisterServiceView().then{
        $0.backgroundColor = Color(0xffffff)
    }
    let registerButton = BGButton().then {
        $0.set(content: "注册")
        $0.layer.cornerRadius = fit(50)

    }

}

extension RegisterViewController {
    /// setup view -- 加载视图
    override func setupView() {
        
        self.view.backgroundColor = Color(0xffffff)
        view.addSubviews(views: [banner,backButton,titleLabel,nickView,phoneView,passwordView,confirmPasswordView,payPwdView,confirmPayPwdView,smsCodeView,serviceView,registerButton])
        
        nickView.set(title: "昵称", placeholder: "请输入昵称")
        phoneView.set(title: "手机号码", placeholder: "请输入手机号")
        passwordView.set(title: "登录密码", placeholder: "请输入密码")
        confirmPasswordView.set(title: "确认密码", placeholder: "请确认密码")
        payPwdView.set(title: "支付密码", placeholder: "请输入6位数字密码")
        confirmPayPwdView.set(title: "确认密码", placeholder: "请输入6位数字密码")
        
        smsCodeView.set(title: "验证码", placeholder: "请输入验证码", buttonText: "验证码")
        serviceView.set(image: "agree", selectImage: "agree1", desc: "我已阅读并同意一下协议", serviceButtonText: "验证码")
        
        passwordView.textField.isSecureTextEntry = true
        confirmPasswordView.textField.isSecureTextEntry = true
        payPwdView.textField.isSecureTextEntry = true
        confirmPayPwdView.textField.isSecureTextEntry = true

        self.smsCodeView.smsButton.clickBtnEvent = {[unowned self] in
            self.sendSMS()
            
        }
        serviceView.clickEvent = {[unowned self] in
            self.present(AgreementController(), animated: false, completion: nil)
        }
        backButton.snp.makeConstraints { (make) in
            make.top.snEqualTo(banner.snp.top).snOffset(LL_StatusBarAndNavigationBarHeight)
            make.left.snEqualTo(banner.snp.left).snOffset(30)
        }
        
        banner.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.snEqualToSuperview()
            make.height.snEqualTo(174 + LL_StatusBarAndNavigationBarHeight)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(80)
            make.bottom.equalTo(banner.snp.bottom).snOffset(-17)
        }
        
        nickView.snp.makeConstraints { (make) in
            make.top.equalTo(banner.snp.bottom).snOffset(60)
            make.height.snEqualTo(100)
            make.left.equalToSuperview().snOffset(75)
            make.right.equalToSuperview().snOffset(-75)
        }
        
        phoneView.snp.makeConstraints { (make) in
            make.top.equalTo(nickView.snp.bottom)
            make.height.snEqualTo(100)
            make.left.equalToSuperview().snOffset(75)
            make.right.equalToSuperview().snOffset(-75)
        }
        passwordView.snp.makeConstraints { (make) in
            make.top.equalTo(phoneView.snp.bottom)
            make.height.snEqualTo(100)
            make.left.equalToSuperview().snOffset(75)
            make.right.equalToSuperview().snOffset(-75)
        }
        confirmPasswordView.snp.makeConstraints { (make) in
            make.top.equalTo(passwordView.snp.bottom)
            make.height.snEqualTo(100)
            make.left.equalToSuperview().snOffset(75)
            make.right.equalToSuperview().snOffset(-75)
        }
        
        payPwdView.snp.makeConstraints { (make) in
            make.top.equalTo(confirmPasswordView.snp.bottom)
            make.height.snEqualTo(100)
            make.left.equalToSuperview().snOffset(75)
            make.right.equalToSuperview().snOffset(-75)
        }
        confirmPayPwdView.snp.makeConstraints { (make) in
            make.top.equalTo(payPwdView.snp.bottom)
            make.height.snEqualTo(100)
            make.left.equalToSuperview().snOffset(75)
            make.right.equalToSuperview().snOffset(-75)
        }
        smsCodeView.snp.makeConstraints { (make) in
            make.top.equalTo(confirmPayPwdView.snp.bottom)
            make.height.snEqualTo(100)
            make.left.equalToSuperview().snOffset(75)
            make.right.equalToSuperview().snOffset(-75)
        }
        
        serviceView.snp.makeConstraints { (make) in
            make.top.equalTo(smsCodeView.snp.bottom)
            make.height.snEqualTo(100)
            make.left.equalToSuperview().snOffset(75)
            make.right.equalToSuperview().snOffset(-75)
        }
        registerButton.snp.makeConstraints { (make) in
            make.left.snEqualToSuperview().snOffset(75)
            make.right.snEqualToSuperview().snOffset(-75)
            make.height.snEqualTo(100)
            make.top.snEqualTo(serviceView.snp.bottom).snOffset(50)
        }
    }
    
    @objc func backAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func sendSMS() {
        if phoneView.textField.text! == "" {
            SZHUD("请填写手机号", type: .info, callBack: nil)
            return
        }
        let url = httpUrl + "/common/sendSMS"
        let para = ["phone":phoneView.textField.text!,
                    "vtype":"2"];
        Alamofire.request(url, method: .post, parameters:para, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                SZHUD("发送成功", type: .success, callBack: nil)
            }else{
                if !jsonData["msg"].stringValue.isEmpty{
                    SZHUD(jsonData["msg"].stringValue , type: .info, callBack: nil)
                }else{
                    SZHUD("请求错误" , type: .error, callBack: nil)
                }
            }
        }
        
    }
    
    
    @objc func registerAction(){

        if nickView.textField.text! == "" {
            SZHUD("请填写昵称", type: .info, callBack: nil)
            return
        }
        if phoneView.textField.text! == "" {
            SZHUD("请填写手机号", type: .info, callBack: nil)
            return
        }
        if passwordView.textField.text! == "" {
            SZHUD("请填写登录密码", type: .info, callBack: nil)
            return
        }
        if confirmPasswordView.textField.text! == "" {
            SZHUD("请填写确认密码", type: .info, callBack: nil)
            return
        }

        if passwordView.textField.text != confirmPasswordView.textField.text {
            SZHUD("两次密码不一致", type: .info, callBack: nil)
            return
        }

        if payPwdView.textField.text! == "" {
            SZHUD("请填写支付密码", type: .info, callBack: nil)
            return
        }
        if confirmPayPwdView.textField.text! == "" {
            SZHUD("请填写确认支付密码", type: .info, callBack: nil)
            return
        }

        if payPwdView.textField.text != confirmPayPwdView.textField.text {
            SZHUD("支付密码不一致", type: .info, callBack: nil)
            return
        }

        if smsCodeView.textField.text! == "" {
            SZHUD("请填写验证码", type: .info, callBack: nil)
            return
        }

        if !serviceView.checked  {
            SZHUD("请同意注册协议", type: .info, callBack: nil)
            return
        }

        let url = httpUrl + "/user/registerMember"
        let para = ["nick_name":nickView.textField.text!,
                    "phone":phoneView.textField.text!,
                    "code":smsCodeView.textField.text!,
                    "pwd":confirmPasswordView.textField.text!,
                    "pay_pwd":confirmPayPwdView.textField.text!];
        Alamofire.request(url, method: .post, parameters:para, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                SZHUD("提交成功", type: .success, callBack: nil)
                self.getKeyAndWords()
//                self.dismiss(animated: true, completion: nil)
            }else{
                if !jsonData["msg"].stringValue.isEmpty{
                    SZHUD(jsonData["msg"].stringValue , type: .info, callBack: nil)
                }else{
                    SZHUD("请求错误" , type: .error, callBack: nil)
                }
            }
        }
  
    }
    func getKeyAndWords() {
        
        let url = httpUrl + "/common/getKeyAndWords"
        let para = ["phone":self.phoneView.textField.text!];
        Alamofire.request(url, method: .post, parameters:para, headers:nil).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                DispatchQueue.main.async {
                    let vc = MyWordsController()
                    vc.word   = jsonData["data"]["word"].stringValue
                    vc.key = jsonData["data"]["key"].stringValue
                    self.present(vc, animated: false, completion: nil)
                    
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
        backButton .addTarget(self, action: #selector(backAction), for: .touchUpInside)
        registerButton .addTarget(self, action: #selector(registerAction), for: .touchUpInside)
    }
}
