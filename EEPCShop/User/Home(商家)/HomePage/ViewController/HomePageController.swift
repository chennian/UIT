//
//  HomePageController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/1.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class HomePageController: SNBaseViewController {
    
    
    var total:String = ""
    
    var num :String = ""
    
    var cellType :[homePageType] = []
    
    var model:[HomePageModel] = []
    
    var arrMenu :[CatModel] = []
    
    var bannerModel :[BannerModel] = []
    
    var bannerArray:[BannerModel] = []
    
    var adArray : [BannerModel] = []
    
    var jsonArr:JSON = []


    var city:String?
    
    
    var searchField = UITextField().then{
        $0.placeholder = "搜索商家"
        $0.borderStyle = .none
        $0.font = Font(28)
    }
    
    var leftBtn = UIButton().then{
        $0.setImage(UIImage(named: "Scan"), for: .normal)
    }
    
    var rightBtn = UIButton().then{
        $0.setImage(UIImage(named: "plus"), for: .normal)
    }
    
    let backImageView = UIImageView().then{
        $0.image = UIImage(named: "Backgroundimage")
    }
    
    let titleView = titleview().then{
        $0.backgroundColor = Color(0xffffff)
        $0.layer.cornerRadius = fit(8)
        $0.isUserInteractionEnabled = true
        
    }
    
    let cityButton = UIButton().then{
        $0.setTitle("深圳市", for: .normal)
        $0.setTitleColor(Color(0xa9aebe), for: .normal)
        $0.titleLabel?.font = Font(28)
        $0.setImage(UIImage(named: "Polygon1"), for: .normal)
    }

    fileprivate let tableView:UITableView = UITableView().then{
        $0.backgroundColor = Color(0xf5f5f5)
        $0.register(BannerCell.self)
        $0.register(ClassCell.self)
        $0.register(ADModuleCell.self)
        $0.register(MerchantHeadCell.self)
        $0.register(MerchantCell.self)
        $0.register(EmptyTableSetCell.self)
        $0.register(SpaceCell.self)

        $0.separatorStyle = .none
    }
    
    
    
    func loadShopCatData(){
        
        SZHUD("加载中.." , type: .loading, callBack: nil)

        
        let url = imgUrl + "/common/shopCat"
        Alamofire.request(url, method: .post, parameters:nil, headers:nil).responseJSON { [unowned self](res) in
            let jsonData = JSON(data: res.data!)
            if  jsonData["code"].intValue == 1000{
                self.bannerArray.removeAll()
                self.adArray.removeAll()
                CNLog(jsonData["newData"])
                //登录成功数据解析
                self.arrMenu = jsonData["newData"]["cat"].arrayValue.compactMap { CatModel(jsonData: $0) }
                self.bannerModel = jsonData["newData"]["banner"].arrayValue.compactMap { BannerModel(jsonData: $0) }
                
                self.total = jsonData["newData"]["coupon"]["base"].stringValue
                self.num = jsonData["newData"]["coupon"]["bonus"].stringValue
                
                for item in self.bannerModel {
                    if item.type == "1"{
                        self.bannerArray.append(item)
                    }else{
                        self.adArray.append(item)
                    }
                }
                
                self.loadShopData(XKeyChain.get(CITY))
                
            }else{
                SZHUD(jsonData["msg"].stringValue , type: .error, callBack: nil)
            }
        }
    }
    
     func loadShopData(_ city:String) {
  
        self.searchField.resignFirstResponder()
 
        let url = imgUrl + "/common/shopList"
        let para:[String:String] = ["city":city]


        Alamofire.request(url, method: .post, parameters:para, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                //登录成功数据解析
                let jsonObj = jsonData["data"]
                self.model = jsonObj.arrayValue.compactMap { HomePageModel(jsonData: $0) }
                
                self.cellType.removeAll()

                self.cellType.append(.bannerType)
                self.cellType.append(.spaceType)
                self.cellType.append(.classType)
                self.cellType.append(.spaceType)
                self.cellType.append(.adType)
                self.cellType.append(.spaceType)
                self.cellType.append(.merchantHeadType)
                
                if !self.model.isEmpty{
                    for item in self.model {
                        item.base = self.total
                        item.bouns = self.num
                        self.cellType.append(.merchantType(item))
                    }
                }
                
                if self.cellType.count <= 6 {
                    self.cellType.append(.emptyType)
                }
                
                self.tableView.reloadData()
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
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.navigationBar.isTranslucent = false
        let image =  self.imageFromColor(color: Color(0xf5f5f5), viewSize: CGSize.init(width: ScreenW, height: LL_StatusBarAndNavigationBarHeight))
        
        self.navigationController?.navigationBar.setBackgroundImage(image, for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = self.imageFromColor(color: Color(0xd8dade), viewSize: CGSize.init(width: ScreenW, height: fit(1)))

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
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Backgroundimage"), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = self.imageFromColor(color: Color(0xd8dade), viewSize: CGSize.init(width: ScreenW, height: fit(1)))
    }
    
    //接受通知
    func receiveNotify(){
        let NotifyOne = NSNotification.Name(rawValue:"cityName")
        NotificationCenter.default.addObserver(self, selector: #selector(getShopName(notify:)), name: NotifyOne, object: nil)
    }
    
    @objc func getShopName(notify: NSNotification) {
        guard let text: String = notify.object as! String? else { return }
        var str:String = ""
        if text.count > 3 {
            str = text.prefix(2) + "..."
        }else{
            str = text
        }
        self.cityButton.setTitle(str, for: .normal)
        self.loadShopData(text)
    }
    override func setupView() {
        
        
        receiveNotify()
        setTitleView()
        setNavigationBar()
        setNavigationBtn()
        self.view.backgroundColor = Color(0xf5f5f5)
        self.view.addSubview(backImageView)
        self.view.addSubview(tableView)
        tableView.backgroundColor = .clear
        tableView.delegate = self
        tableView.dataSource = self
        extendedLayoutIncludesOpaqueBars = true;
        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            automaticallyAdjustsScrollViewInsets = false
        }
      
    
        tableView.contentInset = UIEdgeInsets(top: LL_StatusBarAndNavigationBarHeight + fit(20), left: 0, bottom: 49, right: 0)
        tableView.scrollIndicatorInsets = tableView.contentInset
        
        backImageView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().snOffset(-LL_StatusBarAndNavigationBarHeight)
            make.height.snEqualTo(350 + LL_Extra)
        }
    
        tableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
        
//        tableView.contentInset = UIEdgeInsets(top: fit(20), left: 0, bottom: 0, right: 0)
    }
    func setNavigationBar(){
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    func setNavigationBtn(){
        
//        self.leftBtn.size = CGSize(width: fit(80), height: fit(60))
        self.rightBtn.size = CGSize(width: fit(80), height: fit(60))

        
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBtn)
        
//        self.leftBtn.addTarget(self, action: #selector(scanAction), for: .touchUpInside)
        self.rightBtn.addTarget(self, action: #selector(enterMap(_:)), for: .touchUpInside)

        self.cityButton.addTarget(self, action: #selector(selectCity), for: .touchUpInside)

        
        if XKeyChain.get(CITY).isEmpty{
            self.cityButton.setTitle("未定位", for: .normal)
        }else{
            self.cityButton.setTitle(XKeyChain.get(CITY), for: .normal)
        }
        self.loadShopCatData()
        
    }
    @objc func selectCity(){
        self.navigationController?.pushViewController(CityListControlelr(), animated: true)

    }
    
    @objc func enterMap(_ sender:UIBarButtonItem){
//
//        let vc = ShopListAndMapController()
//        vc.city = self.cityButton.title(for: .normal)!
//        self.navigationController?.pushViewController(vc, animated: true)
        //设置每一个弹出cell的大小跟坐标 - frmae
        
        self.showXYMenu(sender: sender, type: .XYMenuRightNavBar, isNav: true)

    }
    
    @objc func scanAction(){
        let vc = SWQRCodeViewController()
        self.navigationController?.pushViewController(vc, animated: true)
//        
//        let vc = SWQRCodeViewController()
//        self.navigationController?.pushViewController(vc, animated: true)
    }
   
    func setTitleView(){
        self.titleView.size = CGSize(width: fit(680), height: fit(70))
        self.navigationItem.titleView = self.titleView
        let line = UIView().then{
            $0.backgroundColor = Color(0xdcdcdc)
        }
        self.titleView.addSubview(self.cityButton)
        self.titleView.addSubview(line)
        self.titleView.addSubview(self.searchField)
        self.searchField.delegate = self
        let searchImg = UIImageView().then{
            $0.image = UIImage(named: "Layer4")
            $0.contentMode = .center
        }
        searchImg.size = CGSize(width: fit(90), height: fit(40))
        self.searchField.rightView = searchImg
        self.searchField.rightViewMode = .always
        
        self.cityButton.snp.makeConstraints { (make) in
            make.left.top.bottom.equalToSuperview()
            make.width.snEqualTo(150)
        }
    
        self.cityButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: fit(120), bottom: 0, right: 0)
        self.cityButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: fit(-40), bottom: 0, right: 0)
        
        line.snp.makeConstraints { (make) in
            make.left.equalTo(self.cityButton.snp.right).snOffset(15)
            make.top.bottom.equalToSuperview()
            make.width.snEqualTo(1)
        }
    
        searchField.snp.makeConstraints { (make) in
            make.left.equalTo(line.snp.right).snOffset(15)
            make.right.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        

        
    }
}

extension HomePageController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let vc  = ShopSearchController()
        vc.city = self.cityButton.title(for: .normal)!
        vc.total = self.total
        vc.num = self.num
        self.navigationController?.pushViewController(vc, animated: false)
        return false
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellType.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.cellType[indexPath.row] {
        case  .spaceType:
            let cell:SpaceCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        case  .classType:
            let cell:ClassCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.model = self.arrMenu
            cell.clickEvent = {[unowned self] (index,catName) in
                let vc = ShopCatListController()
                vc.city = self.cityButton.title(for: .normal)!
                vc.cat = index
                vc.selfTitle = catName
                vc.total = self.total
                vc.num = self.num
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        case  .adType:
            let cell:ADModuleCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.clickEventOne = {[unowned self] in
                let jsonData =  self.adArray[0].url.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data()
                let json = JSON(data: jsonData)
                if json["type"].stringValue == "1"{
                    
                    let vc = ShopCatListController()
                    vc.city = json["data"]["city"].stringValue
                    vc.cat =  json["data"]["category"].stringValue
                    vc.selfTitle =  json["data"]["name"].stringValue
                    vc.total = self.total
                    vc.num = self.num
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
            cell.clickEventTwo = {[unowned self] in
                let jsonData =  self.adArray[1].url.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data()
                let json = JSON(data: jsonData)
                if json["type"].stringValue == "1"{
                    
                    let vc = ShopCatListController()
                    vc.city = json["data"]["city"].stringValue
                    vc.cat =  json["data"]["category"].stringValue
                    vc.selfTitle =  json["data"]["name"].stringValue
                    vc.total = self.total
                    vc.num = self.num
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
            cell.clickEventThree = {[unowned self] in
                let jsonData =  self.adArray[2].url.data(using: String.Encoding.utf8, allowLossyConversion: false) ?? Data()
                let json = JSON(data: jsonData)
                if json["type"].stringValue == "1"{
                    
                    let vc = ShopCatListController()
                    vc.city = json["data"]["city"].stringValue
                    vc.cat =  json["data"]["category"].stringValue
                    vc.selfTitle =  json["data"]["name"].stringValue
                    vc.total = self.total
                    vc.num = self.num
                    self.navigationController?.pushViewController(vc, animated: true)
                    
                }
            }
            
            cell.clickEventFour = {[unowned self] in
                if XKeyChain.get(UITOKEN_UID).isEmpty || XKeyChain.get(UITOKEN_UID) == ""{
                    SZHUD("请登录...", type: .info, callBack: nil)
                    return
                }

                self.navigationController?.pushViewController(RmdInfoViewController(), animated: true)
            }
            cell.models = self.adArray
            return cell
        case  .merchantHeadType:
            let cell:MerchantHeadCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        case  .merchantType(let model):
            let cell:MerchantCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.model = model
            return cell
        case  .bannerType:
            let cell:BannerCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.models = self.bannerArray
            return cell
        case .emptyType:
            let cell:EmptyTableSetCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        default:
            let cell:SpaceCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.cellType[indexPath.row] {
        case .bannerType:
            return fit(349)
        case .classType:
            return fit(300)
        case .adType:
            return fit(608)
        case .merchantHeadType:
            return fit(80)
        case .merchantType:
            return fit(220)
        case .spaceType:
            return fit(20)
        case .emptyType:
            return fit(450)
        default :
            return fit(20)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.cellType[indexPath.row] {
        case .merchantType(let model):
            let vc = ShopDetailController()
            vc.model = model
            self.navigationController?.pushViewController(vc, animated: true)

        default:
            return

        }
    }
}
extension HomePageController:UIScrollViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView .isEqual(self.tableView) {
            if self.tableView.contentOffset.y  > -LL_StatusBarAndNavigationBarHeight{
                tableView.backgroundColor = Color(0xffffff)

                self.navigationController?.navigationBar.isTranslucent = false
//                let image =  self.imageFromColor(color: Color(0xf5f5f5), viewSize: CGSize.init(width: ScreenW, height: LL_StatusBarAndNavigationBarHeight))
                
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(named: "Backgroundimage"), for: UIBarMetrics.default)
                self.navigationController?.navigationBar.shadowImage = self.imageFromColor(color: Color(0xd8dade), viewSize: CGSize.init(width: ScreenW, height: fit(1)))
                
            }else{
                tableView.backgroundColor = .clear

                self.navigationController?.navigationBar.isTranslucent = true
                self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
                self.navigationController?.navigationBar.shadowImage = UIImage()
            }
        }
    }
}


extension HomePageController {
    
    func showXYMenu(sender: UIBarButtonItem, type: XYMenuType, isNav: Bool) {
        var images :[String] = []
        var titles:[String] = []
        
        images = ["icon1","icon3"]
        titles = ["扫一扫","地图"]

        sender.xy_showXYMenu(images: images,
                             titles: titles,
                             currentNavVC: self.navigationController!,
                             type: type,
                             closure: { [unowned self] (index) in
                                if index == 1{
                                    
                                    if XKeyChain.get(UITOKEN_UID).isEmpty || XKeyChain.get(UITOKEN_UID) == ""{
                                        SZHUD("请登录后再使用", type: .info, callBack: nil)
                                        return
                                    }
                                    
                                    let vc = SWQRCodeViewController()
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }else if index == 2{
                                    let vc = ShopListAndMapController()
                                    vc.city = self.cityButton.title(for: .normal)!
                                    self.navigationController?.pushViewController(vc, animated: true)
                                }
                })
    }
}
