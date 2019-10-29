//
//  LoginViewController.swift
//  sevenloan
//
//  Created by spectator Mr.Z on 2018/12/3.
//  Copyright © 2018 tangxers. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import SwiftyJSON

class LoginViewController: SNBaseViewController {
    

    var model:[TokenModel] = []

    let banner = UIImageView().then {
        $0.image = Image("logo")
    }
    
    
    let baseView = UIView().then{
        $0.backgroundColor = Color(0xffffff)
        $0.layer.cornerRadius = fit(20)
    }
    
    let titleLabel = UILabel().then {
        $0.textColor = Color(0x2a3457)
        $0.text = "用户登录"
        $0.font = Font(36)
    }
    
    let usernameView = LoginInputView().then{
        $0.backgroundColor = Color(0xffffff)
    }
    let passwordView = LoginInputView().then{
        $0.backgroundColor = Color(0xffffff)
    }
    
    let forgetPassordButton = UIButton().then {
        $0.setTitle("忘记密码", for: .normal)
        $0.setTitleColor(Color(0x2777ff), for: .normal)
        $0.titleLabel?.font = Font(30)
    }
    
    let loginButton = BGButton().then {
        $0.set(content: "登 录")
    }
    
    let registerButton = BorderButton().then {
        $0.set(content: "会员注册")
    }
    
    var popCallBack: (()->())?
}

extension LoginViewController {
    
    override func loadData() {
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false

    }
    
    /// setup view -- 加载视图
    override func setupView() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.isHidden = true
        
        view.backgroundColor = UIColor.init(patternImage: UIImage(named: "login_bg")!)
        
        view.addSubviews(views: [banner,baseView,registerButton])
        baseView.addSubviews(views: [titleLabel,usernameView,passwordView,forgetPassordButton,loginButton])
        passwordView.textField.isSecureTextEntry = true
        usernameView.textField.keyboardType = .numberPad
        
        banner.snp.makeConstraints { (make) in
            make.top.snEqualToSuperview().snOffset(185)
            make.centerX.equalToSuperview()
            make.height.snEqualTo(156)
            make.width.snEqualTo(190)
        }
        
        baseView.snp.makeConstraints { (make) in
            make.top.equalTo(banner.snp.bottom).snOffset(98)
            make.left.equalToSuperview().snOffset(30)
            make.right.equalToSuperview().snOffset(-30)
            make.height.snEqualTo(600)
        }
        
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(47)
            make.top.equalToSuperview().snOffset(60)
        }
        
        usernameView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).snOffset(33)
            make.height.snEqualTo(100)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        passwordView.snp.makeConstraints { (make) in
            make.top.snEqualTo(usernameView.snp.bottom)
            make.height.snEqualTo(100)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
        }
        
        forgetPassordButton.snp.makeConstraints { (make) in
            make.left.snEqualToSuperview().snOffset(55)
            make.top.snEqualTo(passwordView.snp.bottom).snOffset(33)
            make.height.snEqualTo(30)
        }
        
        loginButton.snp.makeConstraints { (make) in
            make.left.snEqualToSuperview().snOffset(45)
            make.right.snEqualToSuperview().snOffset(-45)
            make.height.snEqualTo(90)
            make.top.equalTo(forgetPassordButton.snp.bottom).snOffset(30)
        }
        
        registerButton.snp.makeConstraints { (make) in
            make.bottom.snEqualToSuperview().snOffset(-70)
            make.centerX.snEqualToSuperview()
            make.width.snEqualTo(260)
            make.height.snEqualTo(78)
        }
        
        usernameView.set(title: "账号", placeholder: "请输入登录账号")
        passwordView.set(title: "密码", placeholder: "请输入密码")
        loginButton.layer.cornerRadius = fit(50)
        registerButton.layer.cornerRadius = fit(35)
    }
    func getRootViewController() -> UIViewController? {
        
        let window  = (UIApplication.shared.delegate?.window)!
        assert(window != nil, "The window is empty")
        return window?.rootViewController
    }
    
    func getCurrentViewController() -> UIViewController? {
        
        var currentViewController: UIViewController? = getRootViewController()
        let runLoopFind = true
        while runLoopFind {
            if currentViewController?.presentedViewController != nil {
                
                currentViewController = currentViewController?.presentedViewController
            } else if (currentViewController is UINavigationController) {
                
                let navigationController = currentViewController as? UINavigationController
                currentViewController = navigationController?.children.last
            } else if (currentViewController is UITabBarController) {
                
                let tabBarController = currentViewController as? UITabBarController
                currentViewController = tabBarController?.selectedViewController
            } else {
                
                let childViewControllerCount = currentViewController?.children.count
                if childViewControllerCount! > 0 {
                    
                    currentViewController = currentViewController!.children.last
                    
                    return currentViewController
                } else {
                    
                    return currentViewController
                }
            }
        }
    }
    @objc func loginAction(){
        
        if usernameView.textField.text! == ""{
            SZHUD("请输入登录账号", type: .info, callBack: nil)
            return
        }
        
        if passwordView.textField.text! == ""{
            SZHUD("请输入登录密码", type: .info, callBack: nil)
            return
        }
        let para = ["phone":usernameView.textField.text!,"pwd":passwordView.textField.text!]
        let url = httpUrl + "/user/validateCredentials"
        Alamofire.request(url, method: .post, parameters:para, headers: nil).responseJSON { [unowned self](res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                //登录成功数据解析
                let jsonObj = jsonData["data"]
                self.model = jsonObj.arrayValue.compactMap { TokenModel(jsonData: $0) }
                XKeyChain.set(self.model[0].token, key: TOKEN)
                XKeyChain.set(self.usernameView.textField.text!, key: PHONE)
                XKeyChain.set(self.model[0].uid, key: UITOKEN_UID)

                
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
    @objc func registerAction(){
        self.present(RegisterViewController(), animated: true, completion: nil)
     
    }
    @objc func forgetPasswordAction(){

        self.present(ForgetPasswordViewController(), animated: true, completion: nil)
//        self.present(UpdatePasswordController(), animated: true, completion: nil)

    }
    
    override func bindEvent() {
        loginButton .addTarget(self, action: #selector(loginAction), for: .touchUpInside)
        registerButton .addTarget(self, action: #selector(registerAction), for: .touchUpInside)
        forgetPassordButton .addTarget(self, action: #selector(forgetPasswordAction), for: .touchUpInside)

       
    }
}
