//
//  WalletInfoController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/2.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class WalletInfoController: SNBaseViewController {
    
    var cellType :[WalletInfoType] = []
    
    var coinValue:CoinValue?
    var userModel:UserModel?
    var total:Float = 0.0
    
    fileprivate let tableView:UITableView = UITableView().then{
        $0.backgroundColor = Color(0xf5f5f5)
        $0.register(WalletInfoCell.self)
        $0.register(WalletHeadInfoCell.self)
        $0.register(SpaceCell.self)
        $0.separatorStyle = .none
    }
    
    func loadMyInfo(_ coinValue:CoinValue){
        let url = httpUrl + "/main/userMsg"
        Alamofire.request(url, method: .post, parameters:nil, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                self.cellType.removeAll()
                //登录成功数据解析
                let jsonObj = jsonData["data"][0]
                self.userModel = UserModel.init(jsonData: jsonObj)
                
                if let model = self.userModel {
                    let usdt = Float(model.usdt)! * Float(coinValue.usdtValue)!
                    let eepc = Float(model.eepc)! * Float(coinValue.eepcValue)!
                    let cbd = Float(model.cbd)! * Float(coinValue.cbdValue)!
//                    let ido = Float(model.ido)! * Float(coinValue.idoValue)!

                    self.total = usdt
                    if XKeyChain.get("EEPC") == "1"{
                        self.total +=  eepc
                    }
                    
                    if XKeyChain.get("CBD") == "1"{
                        self.total += cbd
                    }

                    
                    self.cellType.append(.walletHeadType(num: String(self.total)))
                    self.cellType.append(.walletUSDTType(img:UIImage(named: "usdt")!, name: "USDT", num:model.usdt))
                    
                    if XKeyChain.get("EEPC") == "1"{
                        self.cellType.append(.walletEEPCType(img:UIImage(named: "eepc")!, name: "EEPC", num: model.eepc))
                    }
                    
                    if XKeyChain.get("CBD") == "1"{
                        self.cellType.append(.walletCBDType(img:UIImage(named: "cbd")!, name: "CBD", num: model.cbd))
                    }
                    
//                    self.cellType.append(.walletInfoType(img:UIImage(named: "ido")!, name: "IDO", num: model.ido))
                    
                    self.tableView.reloadData()
                }else{
                    self.cellType.append(.walletHeadType(num:"0.0000"))
                    self.cellType.append(.walletUSDTType(img:UIImage(named: "usdt")!, name: "USDT", num: "0.0000"))
                    
                    if XKeyChain.get("EEPC") == "1"{
                        self.cellType.append(.walletEEPCType(img:UIImage(named: "eepc")!, name: "EEPC", num: "0.0000"))
                    }
                    
                    if XKeyChain.get("CBD") == "1"{
                        self.cellType.append(.walletCBDType(img:UIImage(named: "cbd")!, name: "CBD", num: "0.0000"))

                    }
                    
//                    self.cellType.append(.walletInfoType(img:UIImage(named: "ido")!, name: "IDO", num: "0.0000"))
                    self.tableView.reloadData()

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
    
    override func loadData() {
        SZHUD("加载中.." , type: .loading, callBack: nil)

        let url = "http://eepcapp.thebacoin.com/common/getCoinValue"
        Alamofire.request(url, method: .post, parameters:nil, headers:nil ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                //登录成功数据解析
                self.coinValue = CoinValue.init(jsonData: jsonData["data"])
                
                if let model = self.coinValue{
                    XKeyChain.set(model.eepcValue, key:"eepc")
                    XKeyChain.set(model.usdtValue, key:"usdt")
                    self.loadMyInfo(model)
                }
                SZHUDDismiss()
                
            }else if !jsonData["msg"].stringValue.isEmpty{
                SZHUD(jsonData["msg"].stringValue , type: .error, callBack: nil)
                
            }else{
                SZHUD("网络异常" , type: .error, callBack: nil)
            }
        }
        
        
      

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.isHidden = true
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isTranslucent = false
    }

    override func setupView() {
        navigationController?.navigationBar.isTranslucent = true
        navigationController?.navigationBar.isHidden = true
    
        self.view.backgroundColor = Color(0xffffff)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }

        tableView.contentInset = UIEdgeInsets(top: -LL_StatusBarHeight, left: 0, bottom: 0, right: 0)
    }
    
    fileprivate func startScan(){
//        let vc = ScanPayController()
//        vc.shop_id = "2"
//        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.pushViewController(SWQRCodeViewController(), animated: true)
    }
}

extension WalletInfoController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellType.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.cellType[indexPath.row] {
        case  .walletHeadType(let num):
            let cell:WalletHeadInfoCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.set(num: num)
            cell.clickEvent = { [unowned self]  in
                self.startScan()
            }
            cell.addEvent = {[unowned self] in
                self.navigationController?.pushViewController(AddCoinController(), animated: true)
            }
            return cell
        case  .walletCBDType(let img,let name ,let num):
            let cell:WalletInfoCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.set(img: img, name: name, num: num)
            return cell
        case .walletUSDTType(let img, let name, let num):
            let cell:WalletInfoCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.set(img: img, name: name, num: num)
            return cell
        case .walletEEPCType(let img, let name, let num):
            let cell:WalletInfoCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.set(img: img, name: name, num: num)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.cellType[indexPath.row] {
        case .walletHeadType:
            return fit(460)
        case .walletUSDTType:
            return fit(180)
        case .walletEEPCType:
            return fit(180)
        case .walletCBDType:
            return fit(180)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = NewWalletController()
        switch self.cellType[indexPath.row] {
        case .walletHeadType:
            return
        case .walletUSDTType:
            vc.type = "1"
            self.navigationController?.pushViewController(vc, animated: true)
        case .walletEEPCType:
            vc.type = "2"
            self.navigationController?.pushViewController(vc, animated: true)
        case .walletCBDType:
            vc.type = "3"
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


