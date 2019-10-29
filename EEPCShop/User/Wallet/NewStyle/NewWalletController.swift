//
//  NewWalletController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/5/7.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import PagingMenuController

//分页菜单配置
private struct PagingMenuOptions: PagingMenuControllerCustomizable {
    //第1个子视图控制器
    //第2个子视图控制器
    
     let viewController1 = WalletAddressController()
     let viewController2 = TransferOutController()
     let viewController3 = WalletLogController()


    
    //组件类型
    fileprivate var componentType: ComponentType {
        return .all(menuOptions: MenuOptions(), pagingControllers: pagingControllers)
    }
    
    //所有子视图控制器
    fileprivate var pagingControllers: [UIViewController] {
        return [viewController1, viewController2,viewController3]
    }
    
    //菜单配置项
    fileprivate struct MenuOptions: MenuViewCustomizable {
        //菜单显示模式
        var displayMode: MenuDisplayMode {
            return .segmentedControl
        }
        //菜单项
        var itemsOptions: [MenuItemViewCustomizable] {
            return [MenuItem1(), MenuItem2(),MenuItem3()]
        }
        var focusMode: MenuFocusMode{
            return .underline(height: 1.5, color: UIColor(red: 54.0 / 255.0, green: 96.0 / 255.0, blue: 251.0 / 255.0, alpha: 1.0), horizontalPadding: 20, verticalPadding: 0)
        }
        
    }
    //第1个菜单项
    fileprivate struct MenuItem1: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "转入"))
        }
    }
    
    //第2个菜单项
    fileprivate struct MenuItem2: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "转出"))
        }
    }
    
    //第3个菜单项
    fileprivate struct MenuItem3: MenuItemViewCustomizable {
        //自定义菜单项名称
        var displayMode: MenuItemDisplayMode {
            return .text(title: MenuItemText(text: "记录"))
        }
    }
}

class NewWalletController: SNBaseViewController {
    
    var type:String = ""
    
    override func setupView() {
        navigationController?.navigationBar.isHidden = false
        setUpUI()
        
    }

    
    func setUpUI() {
        if self.type == "1" {
            self.title = "USDT"
        }else if self.type == "2"{
            self.title = "EEPC"
        }else if self.type == "3"{
            self.title = "CBD"
        }
        self.view.backgroundColor = Color(0xf5f5f5)
        let options = PagingMenuOptions()
        options.viewController1.type = self.type
        options.viewController2.type = self.type
        options.viewController3.type = self.type
        let pagingMenuController = PagingMenuController(options: options)
//        pagingMenuController.view.frame.origin.y += fit(20)
//                pagingMenuController.view.frame.size.height -= 64
        addChild(pagingMenuController)
        view.addSubview(pagingMenuController.view)
    }
}
