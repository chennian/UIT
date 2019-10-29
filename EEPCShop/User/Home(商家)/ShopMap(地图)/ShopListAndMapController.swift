//
//  ShopListAndMapController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/25.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MapKit
class ShopListAndMapController:SNBaseViewController {
    
    var city:String?
    var cellType :[homePageType] = []
    var model:[HomePageModel] = []
    var MapCell:MapViewCell =  MapViewCell()
    var index:Int = 0
    var paopaoModel:HomePageModel?

    var mapView = BMKMapView().then{
        $0.zoomLevel = 14
        $0.showsUserLocation = true
    }
    
    lazy var locationManager: BMKLocationManager = {
        let manager = BMKLocationManager()
        manager.coordinateType = BMKLocationCoordinateType.BMK09LL
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = CLActivityType.automotiveNavigation
        manager.pausesLocationUpdatesAutomatically = false
        
        manager.allowsBackgroundLocationUpdates = false
        manager.locationTimeout = 8
        return manager
    }()
    
    fileprivate let tableView:UITableView = UITableView().then{
        $0.backgroundColor = Color(0xf5f5f5)
//        $0.register(MapViewCell.self)
        $0.register(MerchantHeadCell.self)
        $0.register(MerchantCell.self)
        $0.register(EmptyTableSetCell.self)
        $0.separatorStyle = .none
    }
    func getPaoPaoData(_ models:[HomePageModel], _ id:Int){
        
        if self.model.count > 0{
            
            for item in self.model{
                if item.id == String(id){
                    self.paopaoModel = item
                }
            }
        }
    }
    func loadShopData(_ city:String) {
        
        let url = imgUrl + "/common/shopList"
        let para:[String:String] = ["city":city]
        
        SZHUD("加载中.." , type: .loading, callBack: nil)
        Alamofire.request(url, method: .post, parameters:para, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                //登录成功数据解析
                let jsonObj = jsonData["data"]
                self.model = jsonObj.arrayValue.compactMap { HomePageModel(jsonData: $0) }
                
                
                self.cellType.removeAll()
                self.cellType.append(.merchantHeadType)
                if !self.model.isEmpty{
                    for item in self.model {
                        let annotation = BMKPointAnnotation()
                        annotation.coordinate = CLLocationCoordinate2D(latitude:Double(item.lat)! , longitude: Double(item.lng)!)
                        self.mapView.addAnnotation(annotation)
                        self.cellType.append(.merchantType(item))
                    }
                    
                    self.mapView.centerCoordinate =  CLLocationCoordinate2D(latitude:Double(self.model[0].lat)! , longitude: Double(self.model[0].lng)!)
                }else{
                    self.cellType.append(.emptyType)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.mapView.viewWillDisappear()
        self.mapView.delegate = nil
        
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
        
        
        MapCell.mapView .viewWillAppear()

        self.loadShopData(self.city!)
    }

    override func setupView() {
        
        self.title = "地图"
        self.view.backgroundColor = Color(0xffffff)
        self.view.addSubview(tableView)
        self.view.addSubview(mapView)
        self.mapView.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        mapView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.snEqualTo(505)
        }
        tableView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalTo(mapView.snp.bottom)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
}

extension ShopListAndMapController:UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    
        self.navigationController?.pushViewController(ShopSearchController(), animated: false)
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
        case .mapType:
            let cell:MapViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            self.MapCell = cell
            cell.model = self.model
            
            //            locationManager.startUpdatingLocation()
            //            cell.mapView.showsUserLocation = true
            return cell
        case  .merchantHeadType:
            let cell:MerchantHeadCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        case  .merchantType(let model):
            let cell:MerchantCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.model = model
            return cell
        case  .emptyType:
            let cell:EmptyTableSetCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        default:
            let cell:SpaceCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            return cell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.cellType[indexPath.row] {
        case .merchantHeadType:
            return fit(80)
        case .merchantType:
            return fit(220)
        case .mapType:
            return fit(505)
        case .emptyType:
            return fit(450)
        default:
            return 0
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch self.cellType[indexPath.row] {
//        case .merchantType(let model):
//            let vc = ShopDetailController()
//            vc.model = model
//            self.navigationController?.pushViewController(vc, animated: true)
//            
//        default:
//            return
//            
//        }
    }
}

extension ShopListAndMapController:BMKMapViewDelegate,BMKLocationManagerDelegate{

    
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        
        if annotation .isKind(of:BMKPointAnnotation.self) {
            let identifier = "BMKAnnotationView"
            let annotationView = BMKAnnotationView.init(annotation: annotation, reuseIdentifier: identifier)
            
            if index < self.model.count{
                let id = self.model[index].id
                annotationView?.tag = Int(id)!
                index += 1
            }
            
            
            annotationView?.image = UIImage(named: "Position")
            annotationView?.canShowCallout = true
            
            return annotationView
        }
        
        return nil;
    }
    func mapView(_ mapView: BMKMapView!, didSelect view: BMKAnnotationView!) {
        let  customView = PaoPaoView.init(frame: CGRect(x: 0, y: 0, width: fit(200), height: fit(150)))
        self.getPaoPaoData(self.model, view.tag)
        CNLog(view.tag)
        
        customView.tapEvent = {[unowned self] in
            self.jumpToMapClicked(Double(self.paopaoModel!.lat)!,Double(self.paopaoModel!.lng)!,self.paopaoModel!.address_detail)
        }
        customView.model = self.paopaoModel!
        let paopao = BMKActionPaopaoView.init(customView: customView)
        view.paopaoView = paopao
    }
    
}
//导航
extension ShopListAndMapController{
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
