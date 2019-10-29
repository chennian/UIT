//
//  MinePageController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/3.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MinePageController:SNBaseViewController {
    
    var cellType :[MinePageType] = []
    var model:UserModel?

    fileprivate let tableView:UITableView = UITableView().then{
        $0.backgroundColor = Color(0xf5f5f5)
        $0.register(MinePageHeadCell.self)
        $0.register(MinePageOneCell.self)
        $0.register(MinePageTwoCell.self)
        $0.register(SpaceCell.self)
        $0.register(LoginOutCell.self)
        $0.separatorStyle = .none
    }

    override func setupView() {

        self.view.backgroundColor = Color(0xffffff)
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        self.cellType.append(.MineHeadType)
        self.cellType.append(.MineCellOne)
        self.cellType.append(.SpaceCell)
        self.cellType.append(.MineCellTwo)
        self.cellType.append(.LoginOut)
        
        tableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
    override func loadData() {
        let url = httpUrl + "/main/userMsg"
        Alamofire.request(url, method: .post, parameters:nil, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                //登录成功数据解析
                let jsonObj = jsonData["data"][0]
                XKeyChain.set(jsonData["data"][0]["uid"].stringValue, key: "UID")
                self.model = UserModel.init(jsonData: jsonObj)
                
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

extension MinePageController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellType.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.cellType[indexPath.row] {
        case  .MineHeadType:
            let cell:MinePageHeadCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            if let model = self.model{
                cell.name.text = model.nick_name
                cell.contributeLable.text = "贡献值:" +  model.contribute_point
                if model.headimg == ""{
                    cell.headimg.image = UIImage(named: "Avatar")
                }else{
                    cell.headimg.kf.setImage(with: URL(string: httpUrl + model.headimg))
                }
            }
            
            return cell
        case  .MineCellOne:
            let cell:MinePageOneCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.clickBtnEvent = {[unowned self] (para) in
                if para == "1"{
                    let vc = MyInfoEditController()
                    vc.model = self.model
                    self.navigationController?.pushViewController(vc, animated: true)
                }else if para == "2"{
                    self.navigationController?.pushViewController(UpdatePayPasswordController(), animated: true)
                }else if para == "3"{
                    self.navigationController?.pushViewController(UpdatePasswordController(), animated: true)
                }
            }
            return cell
        case .MineCellTwo:
            let cell:MinePageTwoCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.clickBtnEvent = {[unowned self] in
                self.navigationController?.pushViewController(DownLoadCodeController(), animated: true)
            }
            cell.clickEvent = {[unowned self] in
                self.navigationController?.pushViewController(RmdProfitLogController(), animated: true)
            }
            return cell
        case .SpaceCell:
            let cell:SpaceCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        case .LoginOut:
            let cell:LoginOutCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.clickBtnEvent = {[unowned self] in
                XKeyChain.set("", key: UITOKEN_UID)
                self.present(LoginViewController(), animated: true, completion: nil)
            }
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.cellType[indexPath.row] {
        case .MineHeadType:
            return fit(320)
        case .MineCellOne:
            return fit(362)
        case .MineCellTwo:
            return fit(250)
        case .SpaceCell:
            return fit(40)
        case .LoginOut:
            return fit(200)
        }
    }
}

