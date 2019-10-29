//
//  UpdatePasswordController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/21.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class UpdatePasswordController:  SNBaseViewController {
    
    fileprivate var cell:UpdatePwdCell = UpdatePwdCell()
    
    fileprivate let tableView:UITableView = UITableView().then{
        $0.backgroundColor = color_bg_gray_f5
        $0.register(UpdatePwdCell.self)
        $0.separatorStyle = .none
    }
    
    override func setupView() {
        self.title = "修改密码"
        self.view.backgroundColor = UIColor.white
        navigationController?.navigationBar.isHidden = false
        self.view.addSubview(tableView)
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    
    func sendSMS() {
        if cell.phone.textfield.text! == "" {
            SZHUD("请填写手机号", type: .info, callBack: nil)
            return
        }
        let url = httpUrl + "/common/sendSMS"
        let para = ["phone":cell.phone.textfield.text!,
                    "vtype":"1"];
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
    
    @objc func submitAction(){
        if cell.phone.textfield.text! == "" {
            SZHUD("请填写手机号", type: .info, callBack: nil)
            return
        }
        if cell.oldPwd.textfield.text! == "" {
            SZHUD("请填写旧密码", type: .info, callBack: nil)
            return
        }
        if cell.pwd.textfield.text! == "" {
            SZHUD("请填写新密码", type: .info, callBack: nil)
            return
        }
        if cell.confirmPwd.textfield.text! == "" {
            SZHUD("请填写确认新密码", type: .info, callBack: nil)
            return
        }
        
        if cell.pwd.textfield.text != cell.confirmPwd.textfield.text {
            SZHUD("两次密码不一致", type: .info, callBack: nil)
            return
        }
        
        if cell.code.textfield.text! == "" {
            SZHUD("请填写验证码", type: .info, callBack: nil)
            return
        }
        
        let url = httpUrl + "/member/alterLoginPwd"
        let para = ["phone":cell.phone.textfield.text!,
                    "old_pay_pwd":cell.oldPwd.textfield.text!,
                    "new_pay_pwd":cell.pwd.textfield.text!,
                    "verifycode":cell.code.textfield.text!];
        Alamofire.request(url, method: .post, parameters:para, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                SZHUD("提交成功", type: .success, callBack: nil)
                self.navigationController?.popViewController(animated: true)
            }else{
                if !jsonData["msg"].stringValue.isEmpty{
                    SZHUD(jsonData["msg"].stringValue , type: .info, callBack: nil)
                }else{
                    SZHUD("请求错误" , type: .error, callBack: nil)
                }
            }
        }
     
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}
extension UpdatePasswordController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UpdatePwdCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.phone.textfield.text = XKeyChain.get(PHONE)
        cell.phone.textfield.isUserInteractionEnabled = false
        self.cell = cell
        cell.code.smsButton.clickBtnEvent = {[unowned self] in
            self.sendSMS()
        }
        cell.clickEvent = {[unowned self] in
            self.submitAction()
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return fit(782)
    }
}
