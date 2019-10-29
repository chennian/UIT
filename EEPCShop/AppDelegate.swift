//
//  AppDelegate.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/3/28.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var  mapManager: BMKMapManager?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = .white

        if XKeyChain.get("USDT") == "" {
            XKeyChain.set("1", key: "USDT")
            XKeyChain.set("0", key: "EEPC")
            XKeyChain.set("0", key: "CBD")
        }
        
        XLocationManager.shareUserInfonManager.startUpLocation()

        // 初始化定位SDK
        BMKLocationAuth.sharedInstance()?.checkPermision(withKey: AK, authDelegate: self)

        //要使用百度地图，请先启动BMKMapManager
        mapManager = BMKMapManager()
        /**
         百度地图SDK所有API均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
         默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
         如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
         */
        if BMKMapManager.setCoordinateTypeUsedInBaiduMapSDK(BMK_COORD_TYPE.COORDTYPE_BD09LL) {
            NSLog("经纬度类型设置成功")
        } else {
            NSLog("经纬度类型设置失败")
        }
        //启动引擎并设置AK并设置delegate
        if !(mapManager!.start(AK, generalDelegate: self)) {
            NSLog("启动引擎失败")
        }
        
        window?.rootViewController = SNMainTabBarController.shared
        
        self.window?.makeKeyAndVisible()
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}

extension AppDelegate:BMKGeneralDelegate, BMKLocationAuthDelegate{

    /**
     联网结果回调
     
     @param iError 联网结果错误码信息，0代表联网成功
     */
    func onGetNetworkState(_ iError: Int32) {
        if 0 == iError {
            NSLog("联网成功")
        } else {
            NSLog("联网失败：%d", iError)
        }
    }
    
    /**
     鉴权结果回调
     
     @param iError 鉴权结果错误码信息，0代表鉴权成功
     */
    func onGetPermissionState(_ iError: Int32) {
        if 0 == iError {
            NSLog("授权成功")
        } else {
            NSLog("授权失败：%d", iError)
        }
    }
    
}
