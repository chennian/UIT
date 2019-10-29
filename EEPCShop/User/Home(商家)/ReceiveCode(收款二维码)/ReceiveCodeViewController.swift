//
//  ReceiveCodeViewController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/5/15.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ReceiveCodeViewController: SNBaseViewController {
    
    var main_img:String?
    var shop_id:String?

    let shopImage = UIImageView().then{
        $0.backgroundColor = .clear
    }
    
    let shopName = UILabel().then{
        $0.textColor = Color(0xffffff)
        $0.font = Font(30)
    }
    
    
    let codeView = QRCodeView().then({
        $0.layer.cornerRadius = fit(10)
        $0.layer.masksToBounds = true
    })
    
    
    let downBtn = UIButton().then{
        $0.setTitle("点击下载二维码", for: .normal)
        $0.titleLabel?.font = Font(30)
    }
    
    let bottonView  = UIView().then{
        $0.backgroundColor = Color(0xffffff)
    }
    
    let bottonImage = UIImageView().then{
        $0.image = UIImage(named: "receive")
    }
    
    
    override func loadData() {
        let url = httpUrl + "/main/shopMsg"
        Alamofire.request(url, method: .post, parameters:nil, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                //登录成功数据解析
                let jsonObj = jsonData["data"]

                DispatchQueue.main.async {
                    //装数据
                    
                    self.main_img = jsonObj["main_img"].stringValue
                    self.shop_id = jsonObj["shop_id"].stringValue
                    self.shopName.text = jsonObj["shop_name"].stringValue
                    self.shopImage.kf.setImage(with: URL(string: httpUrl + jsonObj["main_img"].stringValue ))
                    self.codeView.creatErcode("UITOKEN://"  + jsonObj["shop_id"].stringValue)
                    
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
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false

    }
    
    override func bindEvent() {
        downBtn.addTarget(self, action: #selector(downloadCode), for: .touchUpInside)
    }
    
    @objc func downloadCode(){
        
//        let data = NSData(contentsOf: URL(string: httpUrl + self.main_img!)!)
//        let icon = UIImage(data: data! as Data)
//        
//        
//        let image1 = QRCodeTool.creatQRCodeImage(text: "UITOKEN://" + self.shop_id!, size: fit(700), icon: icon)
//        
//        
//        let image = QRCodeTool.creatCodeImage(bgImage: UIImage(named: "img")!, iconImage: image1, size: fit(700))
//        
//        
//        
//        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.saveImage(image:didFinishSavingWithError:contextInfo:)), nil)
        
    }
    
    @objc private func saveImage(image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: AnyObject) {
        if error != nil{
            SZHUD("保存失败", type: .error, callBack: nil)
        }else{
            SZHUD("保存成功", type: .success, callBack: nil)
        }
    }

    
    override func setupView() {
        self.title = "我的收款码"
        self.view.backgroundColor = ColorRGB(red: 26.0, green: 55.0, blue: 163.0)
        
        
        self.view.addSubviews(views: [shopImage,shopName,codeView,downBtn,bottonView])
        bottonView.addSubview(bottonImage)
        
        shopImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().snOffset(100)
            make.width.height.snEqualTo(100)
        }
        
        shopName.snp.makeConstraints { (make) in
            make.top.equalTo(shopImage.snp.bottom).snOffset(30)
            make.centerX.equalToSuperview()
        }
        
        codeView.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(shopName.snp.bottom).snOffset(120)
            make.width.height.snEqualTo(300)
        }
        
        downBtn.snp.makeConstraints { (make) in
            make.width.snEqualTo(300)
            make.height.snEqualTo(80)
            make.top.equalTo(codeView.snp.bottom).snOffset(10)
            make.centerX.equalTo(codeView.snp.centerX)
        }

        bottonView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.snEqualTo(150)
            make.bottom.equalToSuperview().snOffset(-LL_TabbarSafeBottomMargin)
        }
        bottonImage.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.snEqualTo(330)
            make.height.snEqualTo(120)
        }
    }
}
