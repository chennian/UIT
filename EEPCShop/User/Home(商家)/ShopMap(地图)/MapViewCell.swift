//
//  MapViewCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/19.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MapViewCell: SNBaseTableViewCell {

    var model :[HomePageModel]?{
        didSet{
            guard let cellModel = model else {
                return
            }
            for i  in  0 ..< cellModel.count{
                let point = BMKPointAnnotation.init()
                
                var coor = CLLocationCoordinate2D()
                coor.latitude = Double(cellModel[i].lat)!
                coor.longitude = Double(cellModel[i].lng)!
                point.coordinate = coor
                self.mapView.addAnnotation(point)
            }
        }
    }

    var city:String?

    var userLocation: BMKUserLocation = BMKUserLocation()
    
    var paopaoModel:HomePageModel?
    
    var index:Int = 0
    
    lazy var locationManager: BMKLocationManager = {
        let manager = BMKLocationManager()
        manager.delegate = self
        manager.coordinateType = BMKLocationCoordinateType.BMK09LL
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = CLActivityType.automotiveNavigation
        manager.pausesLocationUpdatesAutomatically = false
        
        manager.allowsBackgroundLocationUpdates = false
        manager.locationTimeout = 10
        return manager
    }()
    
    var mapView = BMKMapView().then{
        $0.zoomLevel = 12
        $0.showsUserLocation = true
    }
    func getRootViewController() -> UIViewController? {
        
        let window  = (UIApplication.shared.delegate?.window)!
        assert(window != nil, "The window is empty")
        return window?.rootViewController
    }
    
    func getCurrentViewController() -> UIViewController? {
        
        var currentViewController: UIViewController? = getRootViewController()
        let runLoopFind = true
        while runLoopFind {
            if currentViewController?.presentedViewController != nil {
                
                currentViewController = currentViewController?.presentedViewController
            } else if (currentViewController is UINavigationController) {
                
                let navigationController = currentViewController as? UINavigationController
                currentViewController = navigationController?.children.last
            } else if (currentViewController is UITabBarController) {
                
                let tabBarController = currentViewController as? UITabBarController
                currentViewController = tabBarController?.selectedViewController
            } else {
                
                let childViewControllerCount = currentViewController?.children.count
                if childViewControllerCount! > 0 {
                    
                    currentViewController = currentViewController!.children.last
                    
                    return currentViewController
                } else {
                    
                    return currentViewController
                }
            }
        }
    }
    func getPaoPaoData(_ models:[HomePageModel], _ id:Int){
        
        if self.model!.count > 0{
            
            for item in self.model!{
                if item.id == String(id){
                    self.paopaoModel = item
                }
            }
        }
    }
    
   func loadData() {
        
        let url = httpUrl + "/main/shopList"
        let para:[String:String] = ["city":self.city!]
        
        Alamofire.request(url, method: .post, parameters:para, headers:["X-AUTH-TOKEN":XKeyChain.get(TOKEN)] ).responseJSON {[unowned self] (res) in
            let jsonData = JSON(data: res.data!)
            CNLog(jsonData)
            if  jsonData["code"].intValue == 1000{
                //登录成功数据解析
                let jsonObj = jsonData["data"]
                self.model = jsonObj.arrayValue.compactMap { HomePageModel(jsonData: $0) }
                
                for i  in  0 ..< self.model!.count{
                    let point = BMKPointAnnotation.init()
                    
                    var coor = CLLocationCoordinate2D()
                    coor.latitude = Double(self.model![i].lat)!
                    coor.longitude = Double(self.model![i].lng)!
                    point.coordinate = coor
                    self.mapView.addAnnotation(point)
                    
                }
            }else if jsonData["code"].intValue == 1006 {
                
                self.getCurrentViewController()!.present(LoginViewController(), animated: true, completion: nil)
            }else if !jsonData["msg"].stringValue.isEmpty{
                SZHUD(jsonData["msg"].stringValue , type: .error, callBack: nil)
                
            }else{
                SZHUD("网络异常" , type: .error, callBack: nil)
            }
        }
        
        
    }
    
    override func setupView() {
        
        self.addSubview(mapView)
  
        mapView.delegate = self
        locationManager.startUpdatingLocation()
        mapView.showsUserLocation = true
        
        mapView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }

    }

}
extension MapViewCell:BMKMapViewDelegate,BMKLocationManagerDelegate{
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate location: BMKLocation?, orError error: Error?) {
        if let _ = error?.localizedDescription {
            NSLog("locError:%@;", (error?.localizedDescription)!)
        }
        userLocation.location = location?.location
        //实现该方法，否则定位图标不出现
        mapView.updateLocationData(userLocation)
        mapView.centerCoordinate = userLocation.location.coordinate
    }
    
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate heading: CLHeading?) {
        NSLog("用户方向更新")
        userLocation.heading = heading
        mapView.updateLocationData(userLocation)
    }
    func bmkLocationManager(_ manager: BMKLocationManager, didFailWithError error: Error?) {
        NSLog("定位失败")
    }
    
    
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        
        
        if annotation .isKind(of:BMKPointAnnotation.self) {
            let identifier = "BMKAnnotationView"
            let annotationView = BMKAnnotationView.init(annotation: annotation, reuseIdentifier: identifier)
            
            
            if index < self.model!.count{
                let id = self.model![index].id
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
        self.getPaoPaoData(self.model!, view.tag)
        CNLog(view.tag)
        
        customView.tapEvent = {[unowned self] in
                        
        }
        customView.model = self.paopaoModel!
        let paopao = BMKActionPaopaoView.init(customView: customView)
        view.paopaoView = paopao
    }
    
}
