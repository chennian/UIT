//
//  PayLogViewController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/5/11.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import DZNEmptyDataSet

class PayLogViewController: SNBaseViewController {
    var model :[PayLogModel] = []

    
    fileprivate let tableView:UITableView = UITableView().then{
        $0.backgroundColor = Color(0xf5f5f5)
        $0.register(PayLogCell.self)
        $0.separatorStyle = .none
    }
    override func loadData() {
        
        let url = httpUrl + "/main/getUserPayment"
        Alamofire.request(url, method: .post, parameters:nil, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                //登录成功数据解析
                self.model.removeAll()
                self.model  = jsonData["data"].arrayValue.compactMap({PayLogModel(jsonData: $0)})
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
    
    override func setupView() {
        self.title = "我的账单"
        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.tableView.emptyDataSetSource = self
        self.tableView.emptyDataSetDelegate = self


        
        self.tableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
    
}
extension PayLogViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:PayLogCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.model = self.model[indexPath.row]
        return cell
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return fit(270)
    }
}
extension PayLogViewController:DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    func image(forEmptyDataSet scrollView: UIScrollView!) -> UIImage! {
        return UIImage(named: "empty")
    }
}
