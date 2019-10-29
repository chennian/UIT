//
//  RmdInfoViewController.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/5/21.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit

class RmdInfoViewController: UIViewController {
    
    let scrollView = UIScrollView().then{
        $0.backgroundColor = Color(0xffffff)
    }
    
    let image = UIImageView().then{
        $0.image = UIImage(named: "invite_background")
        $0.isUserInteractionEnabled = true
    }
    
    let button = UIButton().then{
        $0.backgroundColor = ColorRGB(red: 32.0, green: 176.0, blue: 253.0)
        $0.layer.cornerRadius = fit(20)
        $0.setTitle("知道啦~", for: .normal)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.isTranslucent = false
        
    }
    @objc func clickAction(){
        self.navigationController?.pushViewController(RmdCodeController(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "邀请商家进驻流程"
        self.view.addSubview(scrollView)
        scrollView.addSubview(image)
        
        image.addSubview(button)
        button.addTarget(self, action: #selector(clickAction), for: .touchUpInside)
        
        scrollView.contentSize = CGSize(width: ScreenW, height: fit(3037))

        scrollView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        image.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
        
        button.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().snOffset(-100)
            make.width.snEqualTo(fit(600))
            make.height.snEqualTo(95)
        }
    }
    



}
