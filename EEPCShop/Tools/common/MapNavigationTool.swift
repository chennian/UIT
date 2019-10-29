//
//  LBMapNavigationTool.swift
//  LittleBlackBear
//
//  Created by Apple on 2018/1/15.
//  Copyright © 2018年 蘇崢. All rights reserved.
//

import UIKit
import MapKit
enum MapNavigationType:String{

    case apple = "苹果地图"
    case amap = "高度地图"
    case baidu = "百度地图"
}

final class MapNavigationManger {
    
    fileprivate static let shareIntance = MapNavigationManger()
    class var manger:MapNavigationManger{
        return shareIntance
    }
    var bolck:(()->())?
    func navigationActionWithCoordinate(coordinate:CLLocationCoordinate2D,
                                        type:String,
                                        name:String? = nil) {
        guard let type = MapNavigationType(rawValue: type) else{return}
        switch type {
        case .amap:
            openAMap(coordinate: coordinate, name: name)
        case .apple:
            openAppleMap(coordinate: coordinate,name: name)
        case .baidu:
            openBMKMap(coordinate: coordinate,name: name)
        }
        
    }
	

    func openAMap(coordinate:CLLocationCoordinate2D,
                                        name:String? = nil){

        if !UIApplication.shared.canOpenURL(URL(string: "iosamap://")!){
            SZHUD("暂未安装百度地图", type: .info, callBack: nil)
            return
        }
        
        
        
    }
    
    func openAppleMap(coordinate:CLLocationCoordinate2D,
                      name:String? = nil) {
        let startItem:MKMapItem = MKMapItem.forCurrentLocation()
        let placeMark = MKPlacemark(coordinate: coordinate, addressDictionary: nil)
        
        let endItem:MKMapItem = MKMapItem(placemark: placeMark)
        if name != nil,name!.count > 0{
            endItem.name = name
        }
		let launchOptions:[String:Any] = [MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving ,
												MKLaunchOptionsShowsTrafficKey:true,
												MKLaunchOptionsMapTypeKey:MKMapType.standard.rawValue]
        MKMapItem.openMaps(with: [startItem,endItem],
						   launchOptions:launchOptions )
        
    }
    
    func openBMKMap(coordinate:CLLocationCoordinate2D,
                      name:String? = nil) {
        
        if !UIApplication.shared.canOpenURL(URL(string: "baidumap://")!){
            SZHUD("暂未安装百度地图", type: .info, callBack: nil)
            return
        }
        
    }

}

