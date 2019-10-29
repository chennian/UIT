//
//  MyKeyViewController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/26.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyKeyViewController: SNBaseViewController {
    
    var key:String?
    
    let noticeLable = UILabel().then{
        $0.textColor = Color(0x2a3457)
        $0.text = "抄写下你的钱包私钥"
        $0.font = Font(30)
    }
    
    let noticeDes = UILabel().then{
        $0.textColor = Color(0xa9aebe)
        $0.text = "私钥用于恢复钱包或重置钱包密码，将他准确的抄写到纸上，并存放在的只有你知道的地方"
        $0.font = Font(26)
        $0.numberOfLines = 0
    }
    
    let contentLable = UILabel().then{
        $0.textColor = Color(0x313131)
        $0.text = "私钥用于恢复钱包或重置钱包密码，将他准确的抄写到纸上，并存放在的只有你知道的地方"
        $0.font = Font(30)
        $0.numberOfLines = 0
        $0.backgroundColor = Color(0xa9aebe)
    }
    
    
    let backView = UIView().then{
        $0.backgroundColor = Color(0xffffff)
        $0.layer.cornerRadius = fit(20)
    }
    
    let backBtn = UIButton().then{
        $0.setImage(Image("back_black"), for: .normal)
    }
    
    let name = UILabel().then{
        $0.text = "备份私钥"
        $0.textColor = Color(0x262626)
        $0.font = Font(36)
    }
    
    let nextStepButton = BGButton().then {
        $0.set(content: "确认")
        $0.layer.cornerRadius = fit(50)
        
    }
    
    
    let noticeView = UIView().then{
        $0.backgroundColor = ColorRGB(red: 14.0, green: 84.0, blue: 169.0)
    }
    
    let lable1 = UILabel().then{
        $0.text = "o  密码用于保护私钥和交易授权,强度非常重要"
        $0.font = Font(30)
        $0.textColor  = Color(0xffffff)
    }
    let lable2 = UILabel().then{
        $0.text = "o  UIToken不存储密码也无法帮你找回,请务必牢记"
        $0.font = Font(30)
        $0.textColor  = Color(0xffffff)
    }
    
}


extension MyKeyViewController {
    
    
    /// setup view -- 加载视图
    override func setupView() {
        self.title = "备份密钥"
        
        view.backgroundColor = Color(0xf5f2f7)
        
        
        view.addSubviews(views: [backView,noticeView,noticeLable,noticeDes,contentLable,nextStepButton])
        backView.addSubviews(views: [backBtn,name])
        noticeView.addSubviews(views: [lable1,lable2])
        
        self.contentLable.text = self.key
        
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
        noticeView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(backView.snp.bottom)
            make.height.snEqualTo(100)
        }
        
        lable1.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(30)
            make.top.equalToSuperview().snOffset(10)
        }
        lable2.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(30)
            make.bottom.equalToSuperview().snOffset(-10)
        }
        
        
        noticeLable.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(noticeView.snp.bottom).snOffset(60)
        }
        
        noticeDes.snp.makeConstraints { (make) in
            make.top.equalTo(noticeLable.snp.bottom).snOffset(40)
            make.left.equalToSuperview().snOffset(30)
            make.right.equalToSuperview().snOffset(-30)
        }
        
        contentLable.snp.makeConstraints { (make) in
            make.top.equalTo(noticeDes.snp.bottom).snOffset(40)
            make.left.equalToSuperview().snOffset(30)
            make.right.equalToSuperview().snOffset(-30)
            make.height.snEqualTo(135)
        }
        
        nextStepButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(98)
            make.right.equalToSuperview().snOffset(-98)
            make.top.equalTo(contentLable.snp.bottom).snOffset(90)
            make.height.snEqualTo(88)
        }
        
        
    }
    
    @objc func backAction(){
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
    ///  bind event -- 绑定事件处理
    override func bindEvent() {
        
        backBtn.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        nextStepButton .addTarget(self, action: #selector(nextStep), for: .touchUpInside)

    }
    @objc func nextStep(){
        self.presentingViewController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        
    }
}
