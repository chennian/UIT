//
//  WalletDetailController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/4.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
class WalletDetailController:SNBaseViewController {
    
    var cellType :[WalletDetailType] = []
    
    
    var model :[WalletDetailModel] = []
    
    var type:String?
    
    var url:String?
    
    fileprivate let tableView:UITableView = UITableView().then{
        $0.backgroundColor = Color(0xf5f5f5)
        $0.register(WalletDetailHeadCell.self)
        $0.register(WalletDetailInfoCell.self)
        $0.register(EmptyTableSetCell.self)
        $0.register(SpaceCell.self)
        $0.separatorStyle = .none
    }
    
    let leftBtn = UIButton().then{
        $0.setTitleColor(Color(0x313131), for: .normal)
        $0.titleLabel?.font = Font(32)
        $0.backgroundColor = Color(0xffffff)
    }
    
    override func loadData() {
//        self.cellType.append(.WalletDetailInfo)
//        self.cellType.append(.WalletDetailInfo)
//        self.cellType.append(.WalletDetailInfo)
//        self.cellType.append(.WalletDetailInfo)
//        
        
        if self.type! == "1" {
            self.url = httpUrl + "/member/creatUsdtWallet"
        }else if self.type! == "2"{
            self.url = httpUrl + "/member/creatEepcWallet"
        }else if self.type! == "3"{
            self.url = httpUrl + "/member/creatEepcWallet"
        }
        

        Alamofire.request(self.url!, method: .post, parameters:nil, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                //登录成功数据解析
                let jsonObj = jsonData["data"].stringValue

                self.getCoinInoutLog(jsonObj)
            
            }else if jsonData["code"].intValue == 1006 {
                self.present(LoginViewController(), animated: true, completion: nil)
            }else if !jsonData["msg"].stringValue.isEmpty{
                SZHUD(jsonData["msg"].stringValue , type: .error, callBack: nil)
                
            }else{
                SZHUD("网络异常" , type: .error, callBack: nil)
            }
        }
    }
    
    
    func getCoinInoutLog(_ address:String){
        let url = httpUrl + "/main/getCoinInoutLog"
        let para = ["type":self.type!];
        
        SZHUD("加载中.." , type: .loading, callBack: nil)
        
        Alamofire.request(url, method: .post, parameters:para, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                 self.cellType.removeAll()
                //登录成功数据解析
                let jsonObj = jsonData["data"]
                self.cellType.append(.WalletDetailHead(address: address))

                self.model  = jsonObj.arrayValue.compactMap({WalletDetailModel(jsonData: $0)})

                if !self.model.isEmpty{
                    for item  in self.model{
                        self.cellType.append(.WalletDetailInfo(model: item))
                    }
                }else{
                    self.cellType.append(.EmptyType)
                }
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                
                SZHUDDismiss()
            }else if jsonData["code"].intValue == 1006 {
                self.present(LoginViewController(), animated: true, completion: nil)
            }else if !jsonData["msg"].stringValue.isEmpty{
                SZHUD(jsonData["msg"].stringValue , type: .error, callBack: nil)
                
            }else{
                SZHUD("网络异常" , type: .error, callBack: nil)
            }
        }
    }

    @objc func transferOut() {
        let vc = TransferOutViewController()
        vc.type  = self.type
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    override func setupView() {
        
        
        if self.type! == "1" {
            self.title = "USDT"
            leftBtn.setTitle("转出USDT", for: .normal)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        }else if self.type! == "2"{
            self.title = "EEPC"
            leftBtn.setTitle("转出EEPC", for: .normal)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        }
        else if self.type! == "3"{
            self.title = "CBD"
            leftBtn.setTitle("转出CBD", for: .normal)
            self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        }
        
        self.leftBtn.addTarget(self, action: #selector(transferOut), for: .touchUpInside)

        
        navigationController?.navigationBar.isHidden = false

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
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        navigationController?.navigationBar.isHidden = true
//
//    }
}

extension WalletDetailController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellType.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.cellType[indexPath.row] {
        case  .WalletDetailHead(let address):
            let cell:WalletDetailHeadCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.setAddress(address)
            
            cell.copyEvent = {()in
                let pasteboard = UIPasteboard.general
                pasteboard.string = address
                SZHUD("复制成功", type: .success, callBack: nil)

            }
            
            return cell
        case  .WalletDetailInfo(let model):
            let cell:WalletDetailInfoCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            if self.type! == "1" {
                if model.in_out == "1"{
                    cell.setData("转入USDT","+" + model.num, model.add_time)
                }else{
                    cell.setData("转出USDT","-" + model.num, model.add_time)
                }
                
            }else if self.type! == "2"{
                if model.in_out == "1"{
                    cell.setData("转入EEPC","+" + model.num,model.add_time)
                }else{
                    cell.setData("转出EEPC","-" + model.num,model.add_time)
                }
                
            }else{
                if model.in_out == "1"{
                    cell.setData("转入CBD","+" + model.num, model.add_time)
                }else{
                    cell.setData("转出CBD","-" + model.num, model.add_time)
                }
            }
            return cell
        case .EmptyType:
            let cell:EmptyTableSetCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.cellType[indexPath.row] {
        case .WalletDetailHead:
            return fit(480)
        case .WalletDetailInfo:
            return fit(158)
        case .EmptyType:
            return fit(450)
        }
    }
}
