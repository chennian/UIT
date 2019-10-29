//
//  CoolSlidingMenuCollectionViewCell.swift
//  CoolSlidingMenu
//
//  Created by 陈波 on 2017/7/15.
//  Copyright © 2017年 陈波. All rights reserved.
//

import UIKit
import Kingfisher

class CoolSlidingMenuCollectionViewCell: UICollectionViewCell {

//    @IBOutlet weak var imgViewIcon: UIImageView!
//    @IBOutlet weak var lblTitle: UILabel!
    
    var imgViewIcon = UIImageView().then{
        $0.contentMode = .scaleAspectFit
    }
    var lblTitle = UILabel().then{
        $0.font = Font(24)
        $0.textColor = Color(0x2a3457)
    }
    
    public var dicMenu:CatModel? = nil {
        didSet {
            imgViewIcon.kf.setImage(with: URL(string: "http://app.shijihema.cn/NewPublic/" + (dicMenu?.img)! + "@2x.png"))
            lblTitle.text = dicMenu?.name
            lblTitle.adjustsFontSizeToFitWidth = true
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
         setupUI()
    }
    
    func setupUI(){
        self.contentView.backgroundColor = Color(0xffffff)
        self.contentView.addSubview(imgViewIcon)
        self.contentView.addSubview(lblTitle)
        
        imgViewIcon.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().snOffset(20)
            make.height.width.snEqualTo(80)
        }
        
        lblTitle.snp.makeConstraints { (make) in
            make.top.equalTo(imgViewIcon.snp.bottom).snOffset(13)
            make.centerX.equalTo(imgViewIcon.snp.centerX)
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
