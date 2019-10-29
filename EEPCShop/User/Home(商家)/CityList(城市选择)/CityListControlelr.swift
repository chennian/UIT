//
//  CityListControlelr.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/24.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class CityListControlelr: SNBaseViewController {
    
    var model:[CityModel] = []
    
    fileprivate let tableView:UITableView = UITableView().then{
        $0.backgroundColor = Color(0xf5f5f5)
        $0.register(CityCell.self)
        $0.separatorStyle = .none
    }
    
    override func loadData() {
        let url = imgUrl + "/common/cityList"
        Alamofire.request(url, method: .post, parameters:nil, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                //登录成功数据解析
                let jsonObj = jsonData["data"]
                self.model = jsonObj.arrayValue.compactMap { CityModel(jsonData: $0) }

                
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
        setupUI()
    }
    fileprivate func setupUI() {
        self.title = "选择城市"
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = false
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
    }

    @objc  func  submitData(_ city:String){
        let NotifMycation = NSNotification.Name(rawValue:"cityName")
        NotificationCenter.default.post(name: NotifMycation, object: city)
        self.navigationController?.popViewController(animated: true)
    }
}
extension CityListControlelr:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:CityCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.model = self.model[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return fit(110)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        submitData(self.model[indexPath.row].name)
    }
}

