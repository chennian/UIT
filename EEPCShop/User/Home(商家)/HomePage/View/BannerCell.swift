//
//  BannarCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/2.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import SDCycleScrollView

class BannerCell: SNBaseTableViewCell {
    var models : [BannerModel] = []{
        didSet{
            let arry = models.map({return  "http://app.shijihema.cn/NewPublic/" +  $0.img + "@2x.png"})
            sdScrollBanner.imageURLStringsGroup = arry
        }
    }
    
    override func setupView() {
        hidLine()
        contentView.addSubview(sdScrollBanner)
        sdScrollBanner.backgroundColor = .clear
        contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        sdScrollBanner.snp.makeConstraints { (make) in
            make.left.equalToSuperview().snOffset(20)
            make.right.equalToSuperview().snOffset(-20)
            make.top.equalToSuperview()
            make.height.snEqualTo(349)
        }
//        sdScrollBanner.localizationImageNamesGroup = [UIImage(named: "banner") as Any]
//        sdScrollBanner.imageURLStringsGroup  = ["https://f12.baidu.com/it/u=1090114303,2414848395&fm=72","https://f12.baidu.com/it/u=1090114303,2414848395&fm=72"];
        
    }
    
    lazy var sdScrollBanner : SDCycleScrollView = {
        let obj = SDCycleScrollView(frame: CGRect.zero, delegate: nil, placeholderImage: UIImage())
        obj?.bannerImageViewContentMode = .scaleAspectFill
        obj?.pageDotColor = UIColor(white: 1.0, alpha: 0.6)
        obj?.currentPageDotColor = .white
        return obj!
    }()
    
}
