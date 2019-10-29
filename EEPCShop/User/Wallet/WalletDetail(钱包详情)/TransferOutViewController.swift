//
//  TransferOutViewController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/28.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class TransferOutViewController: SNBaseViewController {
    
    var type:String?
    
    let numLabel = UILabel().then{
        $0.textColor = Color(0x2a3457)
        $0.text = "转出数量"
        $0.font = Font(36)
    }
    
    let numField = UITextField().then{
        $0.textColor = Color(0x2a3457)
        $0.font = Font(36)
        $0.placeholder = "请输出你需要转出的数量"
        $0.keyboardType = UIKeyboardType.decimalPad
        $0.textAlignment = .left
        $0.borderStyle = .none
//        $0.layer.borderWidth = fit(1)
//        $0.layer.borderColor = Color(0x2a3457).cgColor
    }
    
    let addressLabel = UILabel().then{
        $0.textColor = Color(0x2a3457)
        $0.text = "钱包地址"
        $0.font = Font(36)
    }

    let addressField = UITextField().then{
        $0.textColor = Color(0x2a3457)
        $0.font = Font(36)
        $0.placeholder = "请输入你的钱包地址"
        $0.textAlignment = .left
    }
    
    let doneButton = UIButton().then{
        $0.setTitle("提交", for: .normal)
        $0.backgroundColor = Color(0x3660fb)
        $0.layer.cornerRadius = fit(49)
        $0.titleLabel?.font = Font(30)
    }
    
    
    let feeLable = UILabel().then{
        $0.text = ""
        $0.textColor = Color(0x2a9aebe)
        $0.font = Font(32)
    }
    
    let notice = UILabel().then{
        $0.text = "为保证资金安全,当您账户安全策略变更、密码修改、我们会对提币进行人工审核,请耐心等待工作人员电话或邮件联系。"
        $0.textColor = Color(0x2a9aebe)
        $0.font = Font(32)
        $0.numberOfLines = 0
    }
    
    
    let eepcAddress = UILabel().then{
        $0.textColor = Color(0x2a3457)
        $0.font = Font(32)
        $0.text = ""
        $0.numberOfLines = 0
    }
    
    let phone = UILabel().then{
        $0.textColor = Color(0x2a3457)
        $0.font = Font(32)
        $0.text = ""
    }
    
    @objc func doneAction(){
        
        if  numField.text! == "" {
            SZHUD("请输入数量", type: .info, callBack: nil)
            return
        }
        
        
        if self.type == "1" {
            if Float(numField.text!)! < 205.0 {
                SZHUD("USDT提取数量不能低于205", type: .info, callBack: nil)
                return
            }
            if  addressField.text! == "" {
                SZHUD("请输入钱包地址", type: .info, callBack: nil)
                return
            }
            
        }
        

        let url = httpUrl + "/main/transferOut"
        let para:[String:String]?
        
        
        if self.type == "1" {
            para = ["type":self.type!,"address":addressField.text!,"num":self.numField.text!]
        }else{
            para = ["type":self.type!,"num":self.numField.text!]
        }
        
        
        CNLog(para)
        Alamofire.request(url, method: .post, parameters:para, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                SZHUD(jsonData["msg"].stringValue , type: .success, callBack: nil)
                self.navigationController?.popViewController(animated: true)
                
            }else if jsonData["code"].intValue == 1006 {
                self.present(LoginViewController(), animated: true, completion: nil)
            }else if !jsonData["msg"].stringValue.isEmpty{
                SZHUD(jsonData["msg"].stringValue , type: .error, callBack: nil)
                
            }else{
                SZHUD("网络异常" , type: .error, callBack: nil)
            }
        }
    }
    
    
    override func loadData() {
        let url = httpUrl + "/main/userMsg"
        Alamofire.request(url, method: .post, parameters:nil, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                //登录成功数据解析
                DispatchQueue.main.async {
                    
                    if jsonData["data"][0]["bac_eepc_address"].stringValue == ""{
                        
                        self.eepcAddress.text =  "转出地址       "  +  "暂无绑定"
                        self.phone.text       =  "手机号           "  +  "暂无绑定"
                    }else{
                        self.eepcAddress.text =  "转出地址       "  +  jsonData["data"][0]["bac_eepc_address"].stringValue
                        self.phone.text       =  "手机号           "  +  jsonData["data"][0]["eepc_bind_phone"].stringValue
                    }


                }
            }else if jsonData["code"].intValue == 1006 {
                self.present(LoginViewController(), animated: true, completion: nil)
            }else if !jsonData["msg"].stringValue.isEmpty{
                SZHUD(jsonData["msg"].stringValue , type: .error, callBack: nil)
                
            }else{
                SZHUD("网络异常" , type: .error, callBack: nil)
            }
        }
    }
    
    
    override func setupView() {
        self.view.addSubviews(views: [numLabel,numField,doneButton,feeLable,notice,addressLabel,addressField,eepcAddress,phone])
        
        
        navigationController?.navigationBar.isHidden = false

        doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        
        if self.type == "1"{
            self.title = "转出USDT"
            self.feeLable.text = "手续费5个USDT,最小提取数量205个"
        }else if self.type == "2"{
            self.title = "转出EEPC"
            self.feeLable.text = "手续费0.05个EEPC"

        }else{
            self.title = "转出CBD"
            self.feeLable.text = "手续费0.05个EEPC"
        }
        
        numLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(65)
            make.top.equalToSuperview().snOffset(100)
        }
        
        numField.snp.makeConstraints { (make) in
            make.right.equalToSuperview().snOffset(-65)
            make.left.equalTo(numLabel.snp.right).snOffset(30)
            make.centerY.equalTo(numLabel.snp.centerY)
            make.height.snEqualTo(45)
        }
        
        if self.type == "1"{
            addressLabel.snp.makeConstraints { (make) in
                make.left.equalToSuperview().snOffset(65)
                make.top.equalTo(numLabel.snp.bottom).snOffset(40)
            }
            addressField.snp.makeConstraints { (make) in
                make.right.equalToSuperview().snOffset(-65)
                make.left.equalTo(numLabel.snp.right).snOffset(30)
                make.centerY.equalTo(addressLabel.snp.centerY)
                make.height.snEqualTo(45)
            }
            feeLable.snp.makeConstraints { (make) in
                make.left.equalToSuperview().snOffset(65)
                make.top.equalTo(addressField.snp.bottom).snOffset(80)
            }
            
            
            doneButton.snp.makeConstraints { (make) in
                make.left.equalToSuperview().snOffset(65)
                make.right.equalToSuperview().snOffset(-65)
                make.top.equalTo(feeLable.snp.bottom).snOffset(40)
                make.height.snEqualTo(98)
            }
            
            notice.snp.makeConstraints { (make) in
                make.left.equalToSuperview().snOffset(65)
                make.top.equalTo(doneButton.snp.bottom).snOffset(40)
                make.right.equalToSuperview().snOffset(-65)
            }
            
            
        }else{
            
            eepcAddress.snp.makeConstraints { (make) in
                make.left.equalToSuperview().snOffset(65)
                make.top.equalTo(numLabel.snp.bottom).snOffset(60)
                make.right.equalToSuperview().snOffset(-65)
            }
            
            phone.snp.makeConstraints { (make) in
                make.left.equalToSuperview().snOffset(65)
                make.top.equalTo(eepcAddress.snp.bottom).snOffset(30)
            }
            
            
            feeLable.snp.makeConstraints { (make) in
                make.left.equalToSuperview().snOffset(65)
                make.top.equalTo(phone.snp.bottom).snOffset(60)
            }
            
            
            doneButton.snp.makeConstraints { (make) in
                make.left.equalToSuperview().snOffset(65)
                make.right.equalToSuperview().snOffset(-65)
                make.top.equalTo(feeLable.snp.bottom).snOffset(40)
                make.height.snEqualTo(98)
            }
            
            notice.snp.makeConstraints { (make) in
                make.left.equalToSuperview().snOffset(65)
                make.top.equalTo(doneButton.snp.bottom).snOffset(40)
                make.right.equalToSuperview().snOffset(-65)
            }
            
        }
    }
}
