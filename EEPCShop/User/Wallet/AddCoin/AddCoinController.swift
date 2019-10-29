//
//  AddCoinController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/30.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class AddCoinController: SNBaseViewController {
    
    fileprivate let tableView:UITableView = UITableView().then{
        $0.backgroundColor = Color(0xf5f5f5)
        $0.register(AddCoinCell.self)
        $0.register(SpaceCell.self)
        $0.separatorStyle = .none
    }
    
    override func setupView() {
        
        self.title = "添加"
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
}

extension AddCoinController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
            let cell:AddCoinCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.label.text = "EEPC"
            cell.img.image = UIImage(named: "eepc")

            if XKeyChain.get("EEPC") == "1" {
                cell.btn.setTitle("删除", for: .normal)
                cell.btn.setTitleColor(.red, for: .normal)
                cell.btn.layer.borderColor = UIColor.red.cgColor
            }else{
                cell.btn.setTitle("添加", for: .normal)
                cell.btn.setTitleColor(Color(0x3660fb), for: .normal)
                cell.btn.layer.borderColor = Color(0x3660fb).cgColor

            }
            
            cell.clickEvent = {[unowned self] in
                if XKeyChain.get("EEPC") == "1" {
                    XKeyChain.set("0", key: "EEPC")
                    SZHUD("删除成功", type: .success, callBack: nil)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    XKeyChain.set("1", key: "EEPC")

                    SZHUD("添加成功", type: .success, callBack: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            }
        
            return cell
        }else{
            let cell:AddCoinCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.label.text = "CBD"
            cell.img.image = UIImage(named: "cbd")

            if XKeyChain.get("CBD") == "1" {
                cell.btn.setTitle("删除", for: .normal)
                cell.btn.setTitleColor(.red, for: .normal)
                cell.btn.layer.borderColor = UIColor.red.cgColor

            }else{
                cell.btn.setTitle("添加", for: .normal)
                cell.btn.setTitleColor(Color(0x3660fb), for: .normal)
                cell.btn.layer.borderColor = Color(0x3660fb).cgColor

            }
            
            cell.clickEvent = {[unowned self] in
                if XKeyChain.get("CBD") == "1" {
                    XKeyChain.set("0", key: "CBD")
                    SZHUD("删除成功", type: .success, callBack: nil)
                    self.navigationController?.popViewController(animated: true)
                }else{
                    XKeyChain.set("1", key: "CBD")
                    SZHUD("添加成功", type: .success, callBack: nil)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
            return cell

        }
      
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return fit(180)
  
    }
}
