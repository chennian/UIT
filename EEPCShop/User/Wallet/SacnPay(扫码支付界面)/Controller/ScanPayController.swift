//
//  ScanPayController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/18.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

class ScanPayController: SNBaseViewController {
    
    var shop_id:String?
    
    var discount:String?
    
    var eepcRatio:String?
    
    var usdtRatio:String?

    
    var shop_img :String?
    var shop_name:String?
    var pay_num :String?
    
    
    
    
    let passwordView = PassWordField().then{
        $0.backgroundColor = Color(0xffffff)
        $0.layer.cornerRadius = fit(8)
    }
    
    let mask = UIView().then{
        $0.backgroundColor = Color(0x000000)
        $0.alpha = 0.3
    }
    
    let mainView = UIView().then{
        $0.backgroundColor = Color(0xffffff)
        $0.layer.cornerRadius = fit(8)
    }
    
    let deleteBtn = UIButton().then{
        $0.setImage(UIImage(named: "back_white"), for: .normal)
    }
    
    let notice = UILabel().then{
        $0.font = Font(36)
        $0.textColor = Color(0x2a3457)
        $0.text = "请输入支付密码"
    }
    
    
    let payLine = UIView().then{
        $0.backgroundColor = Color(0xd2d2d2)
    }
    

    
    //---------------------------------------------------------------------------//
    
    let shopImage = UIImageView().then{
        $0.layer.cornerRadius = fit(8)
        $0.layer.masksToBounds = true
    }
    
    let shopName = UILabel().then{
        $0.text = "假日酒店"
        $0.textColor = Color(0x2a3457)
        $0.font = BoldFont(30)
        $0.isHidden = true
    }

    let payLable = UILabel().then{
        $0.text = "付款金额"
        $0.textColor = Color(0x2a3457)
        $0.font = Font(30)
    }
    
    let moneyField = UITextField().then{
        $0.placeholder = "请输入金额"
        $0.font = Font(48)
        $0.textColor = Color(0x2a3457)
        $0.borderStyle = .none
        $0.keyboardToolbar.isHidden = true
        $0.keyboardType = .numberPad
    }


    let line = UIView().then{
        $0.backgroundColor = Color(0xe5e5e5)
    }
    
    let eepcLable = UILabel().then{
        $0.text = "需要EEPC:"
        $0.textColor = Color(0x2a3457)
        $0.font = Font(30)
    }
    
    let eepcNum =  UILabel().then{
        $0.text = "0.0000"
        $0.textColor = Color(0x2a3457)
        $0.font = BoldFont(30)
    }
    
    let usdtLable = UILabel().then{
        $0.text = "需要USDT:"
        $0.textColor = Color(0x2a3457)
        $0.font = Font(30)
    }
    
    let usdtNum = UILabel().then{
        $0.text = "0.0000"
        $0.textColor = Color(0x2a3457)
        $0.font = BoldFont(30)
    }
    
    let  doneButton = UIButton().then{
        $0.setTitle("确定", for: .normal)
        $0.layer.cornerRadius = fit(49)
        $0.backgroundColor = Color(0x3660fb)
        $0.titleLabel?.font = Font(30)
        $0.setTitleColor(Color(0xffffff), for: .normal)
    }
    
    
    let bottonView = UIView().then{
        $0.backgroundColor = ColorRGB(red: 49.0, green: 49.0, blue: 49.0)
    }
    
    let realPayButton = UIButton().then{
        $0.backgroundColor = ColorRGB(red: 77, green: 202, blue: 100)
        $0.setTitleColor(Color(0xffffff), for: .normal)
        $0.setTitle("确认支付", for: .normal)
        $0.titleLabel?.font = Font(30)
    }
    
    let realNum = UILabel().then{
        $0.text = "￥0.00"
        $0.textColor = Color(0xffffff)
        $0.font = BoldFont(45)
    }
    
    let discountDes = UILabel().then{
        $0.text = "|  已优惠0.00"
        $0.textColor = ColorRGB(red: 111.0 , green: 111.0  , blue: 111.0)
        $0.font = Font(26)
    }
    
    
    override func bindEvent() {
        realPayButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deleteBack), for: .touchUpInside)

    }
    
    @objc func doneAction() {
        
        if moneyField.text! == "" {
            SZHUD("请输入支付金额", type: .info, callBack: nil)
            return
        }
        
        setPasswordView()
//        self.navigationController?.popToRootViewController(animated: true)
    
    }
    
    func setPasswordView(){
        self.view.addSubview(mask)
        mask.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
        self.view.addSubview(mainView)
        
        mainView.addSubviews(views: [deleteBtn,notice,payLine,passwordView])
        
        passwordView.delegate = self
        passwordView.textField.becomeFirstResponder()
        
        
        mainView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.height.snEqualTo(343)
            make.bottom.equalToSuperview().snOffset(-432)
        }
        
        deleteBtn.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(47)
            make.top.equalToSuperview().snOffset(40)
            make.width.snEqualTo(40)
            make.height.snEqualTo(40)
        }
        notice.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(deleteBtn.snp.centerY)
        }
        
        payLine.snp.makeConstraints { (make) in
            make.left.equalTo(mainView.snp.left)
            make.right.equalTo(mainView.snp.right)
            make.height.snEqualTo(1)
            make.top.equalTo(notice.snp.bottom).snOffset(40)
        }

        passwordView.snp.makeConstraints { (make) in
            make.width.snEqualTo(547)
            make.height.snEqualTo(88)
            make.top.equalTo(payLine.snp.bottom).snOffset(35)
            make.centerX.equalToSuperview()

        }
        
    }
    
    
    @objc func deleteBack(){
        passwordView.textField.resignFirstResponder()
        passwordView.textFieldText = ""
        passwordView.textField.text = ""
        passwordView.view1.isHidden = true
        passwordView.view2.isHidden = true
        passwordView.view3.isHidden = true
        passwordView.view4.isHidden = true
        passwordView.view5.isHidden = true
        passwordView.view6.isHidden = true
        mainView.removeFromSuperview()
        mask.removeFromSuperview()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.moneyField.resignFirstResponder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        IQKeyboardManager.shared().isEnabled = false
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        IQKeyboardManager.shared().isEnabled = true
    }
    
    
    override func loadData() {
        let url = httpUrl + "/main/shopMsg"
        let para:[String:String] = ["shop_id":shop_id!]
        Alamofire.request(url, method: .post, parameters:para, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                //登录成功数据解析
                let jsonObj = jsonData["data"]["main_img"].stringValue
                
                DispatchQueue.main.async {
                    //装数据
                    self.shopImage.kf.setImage(with: URL(string: imgUrl + jsonObj))
                    self.discount  = jsonData["data"]["discount"].stringValue
                    self.eepcRatio = jsonData["data"]["eepc_ratio"].stringValue
                    self.usdtRatio = jsonData["data"]["usdt_ratio"].stringValue

                    
                    let discount = Float(self.eepcRatio!)!  + Float(self.usdtRatio!)!
                    
                    self.shopName.text = jsonData["data"]["shop_name"].stringValue + "  (折扣比例:\(String(format: "%.2f",discount)))"

                    
                    self.shop_name = jsonData["data"]["shop_name"].stringValue
                    self.shop_img =  imgUrl + jsonData["data"]["main_img"].stringValue
                    
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
    
    private func getCoinNum(_ num:String){
        let total = Float(num)!
        
        let eepcTotal = total * Float(self.eepcRatio!)!
        let usdtRatio = Float(self.usdtRatio!)!
        let discount = Float(self.discount!)!
        let usdtTotal = total * usdtRatio;
        
    
        let eepcPrice = Float(XKeyChain.get("eepc"))!
        let usdtPrice = Float(XKeyChain.get("usdt"))!
        
        CNLog(usdtTotal)
        CNLog(usdtPrice)

        let eepcNum = eepcTotal/eepcPrice
        let usdtNum = usdtTotal/usdtPrice
     
        self.eepcNum.text =  String(format: "%.4f", eepcNum) + "    "  +  "(￥\(String(format: "%.2f",eepcTotal)))"
        self.usdtNum.text =  String(format: "%.4f", usdtNum) + "    "  +  "(￥\(String(format: "%.2f",usdtTotal)))"
        
        self.realNum.text =  "￥" + String(format: "%.2f",eepcTotal + usdtTotal)
        
        let discountNum = total - eepcTotal - usdtTotal
        self.discountDes.text = "|  已优惠￥\(String(format: "%.2f", discountNum))"

    }
    
    func payAction(_ pay_pwd:String){
        
        let url = httpUrl + "/main/payAction"
        let para:[String:String] = ["shop_id":shop_id!,"num":self.moneyField.text!,"pay_pwd":pay_pwd]
        CNLog(para)
        Alamofire.request(url, method: .post, parameters:para, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                
                let vc = PaySuccessController()
                vc.shop_img = self.shop_img!
                
                vc.shop_name = self.shop_name!
                vc.pay_num = self.moneyField.text ?? "0"
                
                self.navigationController?.pushViewController(vc, animated: true)
//                SZHUD(jsonData["msg"].stringValue , type: .info, callBack: nil)
//
//                for i in 0..<(self.navigationController?.viewControllers.count)! {
//                    if self.navigationController?.viewControllers[i].isKind(of: WalletInfoController.self) == true {
//                        _ = self.navigationController?.popToViewController(self.navigationController?.viewControllers[i] as! WalletInfoController, animated: true)
//                        break
//                    }
//                }
                
                
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
        self.title = "付款"
        self.navigationController?.navigationBar.isHidden = false
        
        self.view.addSubviews(views: [shopImage,shopName,payLable,moneyField,line,eepcLable,usdtLable,eepcNum,usdtNum,bottonView])
        
        bottonView.addSubviews(views: [realPayButton,realNum,discountDes])
        
    
        moneyField.delegate = self

        
        shopImage.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().snOffset(100)
            make.width.height.snEqualTo(120)
        }
        
        shopName.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(shopImage.snp.bottom).snOffset(25)
        }
        
        payLable.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(48)
            make.top.equalTo(shopName.snp.bottom).snOffset(65)
        }
        
        moneyField.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(48)
            make.top.equalTo(payLable.snp.bottom).snOffset(47)
            make.right.equalToSuperview().snOffset(-48)
        }
        
        line.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(49)
            make.right.equalToSuperview().snOffset(71)
            make.top.equalTo(moneyField.snp.bottom).snOffset(24)
            make.height.snEqualTo(1)
        }
        
        eepcLable.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(55)
            make.top.equalTo(line.snp.bottom).snOffset(55)
        }
        
        eepcNum.snp.makeConstraints { (make) in
            make.left.equalTo(eepcLable.snp.right).snOffset(25)
            make.centerY.equalTo(eepcLable.snp.centerY)
        }
        
        usdtLable.snp.makeConstraints { (make) in
            make.top.equalTo(eepcLable.snp.bottom).snOffset(30)
            make.left.equalToSuperview().snOffset(55)
        }
        
        usdtNum.snp.makeConstraints { (make) in
            make.left.equalTo(usdtLable.snp.right).snOffset(25)
            make.centerY.equalTo(usdtLable.snp.centerY)
        }
        
    
        bottonView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().snOffset(-LL_TabbarSafeBottomMargin)
            make.height.snEqualTo(120)
        }
        
        realNum.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(30)
            make.centerY.equalToSuperview()
        }
        
        discountDes.snp.makeConstraints { (make) in
            make.left.equalTo(realNum.snp.right).snOffset(20)
            make.centerY.equalTo(realNum.snp.centerY)
        }
        
        realPayButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.snEqualTo(250)
        }
    }
}
extension ScanPayController:PassWordFieldDelegate{
    func inputTradePasswordFinish(tradePasswordView: PassWordField, password: String) {
        
        CNLog(password)
        payAction(password)
        
    }
    
}
extension ScanPayController:UITextFieldDelegate{
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let fullStr = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        CNLog(fullStr)
        
        if fullStr.count > 0 {
            getCoinNum(fullStr)
        }else{
            self.eepcNum.text = ""
            self.usdtNum.text = ""
            self.moneyField.text = ""
            self.moneyField.resignFirstResponder()
            
            self.realNum.text  = "0.00"
            self.discountDes.text = "|  已优惠 ￥0.00"
        }
        return true
    }
}
