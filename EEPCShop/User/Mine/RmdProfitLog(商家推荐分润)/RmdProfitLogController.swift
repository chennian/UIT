//
//  RmdProfitLogController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/5/1.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import DZNEmptyDataSet

class RmdProfitLogController: SNBaseViewController {
    
    var cellType:[RmdType] = []
    var model :[RmdProfitModel] = []
    
    fileprivate let tableView:UITableView = UITableView().then{
        $0.backgroundColor = Color(0xf5f5f5)
        $0.register(RmdProfitCell.self)
        $0.register(RmdProitHeadCell.self)
        $0.separatorStyle = .none
    }
    
    override func setupView() {
        
        self.title = "推荐分润"
        
        self.view.backgroundColor = Color(0xffffff)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    override func loadData() {
        
        let url = httpUrl + "/main/rmdProfitLog"
        Alamofire.request(url, method: .post, parameters:nil, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            if  jsonData["code"].intValue == 1000{
                CNLog(jsonData)
                self.cellType.removeAll()
                //登录成功数据解析
                let jsonObj = jsonData["data"]["list"]
                self.model  = jsonObj.arrayValue.compactMap({RmdProfitModel(jsonData: $0)})
                
                self.cellType.append(.headType(str:jsonData["data"]["total"].stringValue))
                if !self.model.isEmpty {
                    for item in self.model {
                        self.cellType.append(.infoType(model: item))
                    }
                }
                
                DispatchQueue.main.async {
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
    
}

extension RmdProfitLogController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellType.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch cellType[indexPath.row] {
        case .headType(let str):
            let cell:RmdProitHeadCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.model = str
            return cell
        case .infoType(let model):
            let cell:RmdProfitCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.model = model
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch cellType[indexPath.row] {
        case .headType:
            return fit(100)
        case .infoType:
            return fit(100)
        }
    }
}
extension RmdProfitLogController:DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty");
    }
}
