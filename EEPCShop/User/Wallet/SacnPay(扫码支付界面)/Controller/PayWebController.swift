//
//  PayWebViewController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/5/17.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import WebKit

class PayWebController: UIViewController {
    
    var shop_id :String = ""
    var uid :String = ""

    
    let webView = UIWebView().then{
        $0.backgroundColor = Color(0xf5f5f5)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.webView)
        self.webView.loadRequest(URLRequest(url: URL(string: "http://app.shijihema.cn/common/confirmOrder/\(uid)/\(shop_id)")!))
        
        self.webView.delegate = self
        
        self.webView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        
    }

}
extension PayWebController:UIWebViewDelegate{
    

}
