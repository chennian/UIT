//
//  ShopDetailController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/24.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import MapKit
import Alamofire
import SwiftyJSON
class ShopDetailController: SNBaseViewController {
    
    var  model:HomePageModel?
    
    var  cell : GoodShopCell = GoodShopCell()
    fileprivate let tableView:UITableView = UITableView().then{
        $0.backgroundColor = Color(0xf5f5f5)
        $0.register(ShopBannerCell.self)
        $0.register(ShopDesCell.self)
        $0.register(NameCell.self)
        $0.register(ShopCouponCell.self)
        $0.register(SpaceCell.self)
        $0.register(GoodShopCell.self)
        
        $0.separatorStyle = .none
    }
    

    
    fileprivate func setupUI() {
//        self.navigationController?.navigationBar.isHidden = true
 
        self.view.backgroundColor = Color(0xf5f5f5)
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
    func openUrl(_ urlStr:String){
        let url = URL(string: urlStr)
        let application = UIApplication.shared
        if !application.canOpenURL(url!){
            return
        }
        application.openURL(url!)
    }

    
    func getCouponAction() {
        SZHUD("请求中...", type: .loading, callBack: nil)
        
        let url = imgUrl + "/main/getcoupon"
        Alamofire.request(url, method: .post, parameters:nil, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                
                SZHUD(jsonData["msg"].stringValue , type: .success, callBack: nil)
                
            }else if jsonData["code"].intValue == 1006 {
                SZHUDDismiss()
                self.present(LoginViewController(), animated: true, completion: nil)
            }else if !jsonData["msg"].stringValue.isEmpty{
                SZHUD(jsonData["msg"].stringValue , type: .error, callBack: nil)
                
            }else{
                SZHUD("网络异常" , type: .error, callBack: nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.tableView.contentInset = UIEdgeInsets(top: -LL_StatusBarAndNavigationBarHeight, left: 0, bottom: 0, right: 0)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}

extension ShopDetailController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 0{
            let cell:ShopBannerCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            if  model?.detail_img == ""{
                cell.banner = imgUrl +  (model?.main_img)!
            }else{
                cell.banner = imgUrl +  (model?.detail_img)!
            }
            
            return cell
        }else if indexPath.row == 1{
            let cell:NameCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.nameLable.text = model?.shop_name
            cell.price.text = (model?.province)! + (model?.city)! +  (model?.address_detail)!   //地址
            let discount = (Float(model!.user_discount)!) * 10
            cell.num.text = String(format: "%.1f", discount) + "折"
            return cell
        }else if indexPath.row == 2{
            let cell:SpaceCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.styleColor = Color(0xf5f5f5)
            return cell
        }else if indexPath.row == 3{
            let cell:ShopDesCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.des = (self.model?.describtion)!
            return cell
        }else if indexPath.row == 4{
            let cell:SpaceCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.styleColor = Color(0xf5f5f5)
            return cell
        }else if indexPath.row == 5{
            let cell:SpaceCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.styleColor = Color(0xf5f5f5)
            return cell
        }else{
            let cell:GoodShopCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.model = self.model!
            cell.click = {[unowned self] in
                let url = "telprompt://\(self.model?.phone ?? "#")"
                //这种方式会提示用户确认是否拨打电话
                self.openUrl(url)
            }
            cell.clickbtn = {[unowned self] in
          
                self.jumpToMapClicked(Double(self.model!.lat)!,Double(self.model!.lng)!,self.model!.address_detail)
            }
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0{
            return fit(504)
        }else if indexPath.row == 1{
            return fit(175)
        }else if indexPath.row == 2{
            return fit(20)
        }else if indexPath.row == 3{
            let size = countWidth(text: (self.model?.describtion)!, size: CGSize(width: fit(710), height: CGFloat.greatestFiniteMagnitude), font: Font(30))
            return fit(130) + size.height
        }else if indexPath.row == 4{
            return fit(20)
        }else  if indexPath.row == 5{
            return fit(20)
        }else{
            return fit(230)
        }
    }
}

//导航
extension ShopDetailController{
    func jumpToMapClicked(_ latitute:Double,_ longitute:Double,_ endAddress:String) {
        
        let alter = UIAlertController.init(title: "请选择导航应用程序", message: "", preferredStyle: UIAlertController.Style.actionSheet)
        
        let cancle = UIAlertAction.init(title: "取消", style: UIAlertAction.Style.cancel) { (a) in
        }
        
        let action1 = UIAlertAction.init(title: "苹果地图", style: UIAlertAction.Style.default) { (b) in
            self.appleMap(lat: latitute, lng: longitute, destination: endAddress)
        }
        
        let action2 = UIAlertAction.init(title: "高德地图", style: UIAlertAction.Style.default) { (b) in
            self.amap(dlat: latitute, dlon: longitute, dname: endAddress, way: 0)
        }
        
        let action3 = UIAlertAction.init(title: "百度地图", style: UIAlertAction.Style.default) { (b) in
            self.baidumap(endAddress: endAddress, way: "driving", lat: latitute,lng: longitute)
        }
        
        alter.addAction(action1)
        alter.addAction(action2)
        alter.addAction(action3)
        alter.addAction(cancle)
        
        self.present(alter, animated: true, completion: nil)
    }
    
    
    // 打开苹果地图
    func appleMap(lat:Double,lng:Double,destination:String){
        
        let loc = CLLocationCoordinate2DMake(lat - 0.006, lng - 0.0065)
        let currentLocation = MKMapItem.forCurrentLocation()
        let toLocation = MKMapItem(placemark:MKPlacemark(coordinate:loc,addressDictionary:nil))
        toLocation.name = destination
        let launchOptions:[String:Any] = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving ,
                                          MKLaunchOptionsShowsTrafficKey:true,
                                          MKLaunchOptionsMapTypeKey:MKMapType.standard.rawValue]
        MKMapItem.openMaps(with: [currentLocation,toLocation],
                           launchOptions:launchOptions )
        
    }
    
    // 打开高德地图
    func amap(dlat:Double,dlon:Double,dname:String,way:Int) {
        let appName = "UIT"
        
//        let baidu_coordinate = getBaiDuCoordinateByGaoDeCoordinate(coordinate: coordinate)
        
        let urlString = "iosamap://path?sourceApplication=\(appName)&dname=\(dname)&dlat=\(dlat - 0.006)&dlon=\(dlon - 0.0065)&t=\(way)" as NSString
        
        if self.openMap(urlString) == false {
            SZHUD("您还未安装高德地图", type: .info, callBack: nil)
            return
        }
    }
    
    // 打开百度地图
    func baidumap(endAddress:String,way:String,lat:Double,lng:Double) {
        
        let coordinate = CLLocationCoordinate2DMake(lat, lng)
        
        let destination = "\(coordinate.latitude),\(coordinate.longitude)"
        
        
        let urlString = "baidumap://map/direction?" + "&destination=" + endAddress + "&mode=" + way + "&destination=" + destination
        
        let str = urlString as NSString
        
        if self.openMap(str) == false {
            SZHUD("您还未安装百度地图", type: .info, callBack: nil)
            return
            
        }
    }
    
    // 打开第三方地图
    private func openMap(_ urlString: NSString) -> Bool {
        
//        let url = NSURL(string:urlString.addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)
        let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!)
        
        if UIApplication.shared.canOpenURL(url! as URL) == true {
            UIApplication.shared.openURL(url! as URL)
            return true
        } else {
            return false
        }
    }
    
    // 高德经纬度转为百度地图经纬度
    // 百度经纬度转为高德经纬度，减掉相应的值就可以了。
    func getBaiDuCoordinateByGaoDeCoordinate(coordinate:CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        return CLLocationCoordinate2DMake(coordinate.latitude - 0.006, coordinate.longitude - 0.0065)
    }
}
