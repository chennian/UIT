//
//  ShopSearchController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/17.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ShopSearchController: SNBaseViewController {
    
    var city:String?
    var cellType :[searchPageType] = []
    var model :[HomePageModel] = []
    
    var total :String = ""
    var num :String = ""

    var searchBar = UISearchBar().then{
        $0.placeholder = "搜索店铺"
        $0.showsCancelButton = false
        $0.searchBarStyle = .minimal
        $0.barTintColor = Color(0xf5f5f5)
        $0.showsCancelButton = true;
    }

    fileprivate let tableView:UITableView = UITableView().then{
        $0.backgroundColor = Color(0xf5f5f5)
        $0.register(MerchantCell.self)
        $0.separatorStyle = .none
    }
    
    func loadData(_ key:String) {
        
        let url = imgUrl + "/common/shopListByLable"
        let para:[String:String] = ["key":key,"city":city!]
        
        Alamofire.request(url, method: .post, parameters:para, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                //登录成功数据解析
                let jsonObj = jsonData["data"]
                self.model = jsonObj.arrayValue.compactMap { HomePageModel(jsonData: $0) }
                if self.model.count > 0{
                    
                    for item in self.model{
                        item.bouns = self.num
                        item.base =  self.total
                    }

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }else{
                    SZHUD(jsonData["msg"].stringValue , type: .info, callBack: nil)
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
    
    func imageFromColor(color: UIColor, viewSize: CGSize) -> UIImage{
        let rect: CGRect = CGRect(x: 0, y: 0, width: viewSize.width, height: viewSize.height)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(color.cgColor)
        context.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsGetCurrentContext()
        return image!
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = false
        let image =  self.imageFromColor(color: Color(0xffffff), viewSize: CGSize.init(width: ScreenW, height: LL_StatusBarAndNavigationBarHeight))
        
        self.navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = self.imageFromColor(color: Color(0xd8dade), viewSize: CGSize.init(width: ScreenW, height: fit(1)))
        //定位
    }
    override func setupView() {
        setupUI()
        setSearchBar()
    }
    fileprivate func setupUI() {
        self.navigationController?.navigationBar.isTranslucent = true
        
        extendedLayoutIncludesOpaqueBars = true;
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
        tableView.contentInset = UIEdgeInsets(top: LL_StatusBarAndNavigationBarHeight + fit(20), left: 0, bottom: 49, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        
        self.view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = false
        tableView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
    }
    func setSearchBar(){
        self.navigationItem.leftBarButtonItem = nil
        navigationItem.hidesBackButton = true
        // 创建搜索框
        searchBar.frame = CGRect(x: 0, y: 0, width:fit(493), height: 30)
        searchBar.delegate = self
        navigationItem.titleView = searchBar
        searchBar.becomeFirstResponder()
        let cancelBtn:UIButton = searchBar.value(forKey: "cancelButton") as! UIButton
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(ColorRGB(red: 169, green: 174, blue: 190), for: .normal)
        cancelBtn.addTarget(self, action: #selector(back), for: .touchUpInside)
    }
    
    @objc func back(){
        
        self.searchBar.resignFirstResponder()
        
        self.navigationController?.popViewController(animated: false)
    }
    


}
extension ShopSearchController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return model.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:MerchantCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        cell.model = self.model[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return fit(220)

    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ShopDetailController()
        vc.model = model[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ShopSearchController:UISearchBarDelegate{
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if searchBar.text! != "" {
            loadData(searchBar.text!)
        }else{
            SZHUD("请输入关键词", type: .info, callBack: nil)
        }
    }
    
}
