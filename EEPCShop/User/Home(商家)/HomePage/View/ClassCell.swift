//
//  ClassCell.swift
//  EEPCShop
//
//  Created by Mac Pro on 2019/4/2.
//  Copyright © 2019年 CHENNIAN. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ClassCell: SNBaseTableViewCell {
    
    var model:[CatModel]?{
        didSet{
            guard let cellModel = model else {
                return
            }
            self.slidingMenuView.arrMenu = cellModel
        }
    }
    
    var clickEvent:((_ index:String,_ catName:String)->())?
    
    var slidingMenuView = CoolSlidingMenuView().then{
        $0.pgCtrl.isHidden = false
        $0.contentMode = .scaleAspectFit
        $0.pgCtrlNormalColor = Color(0xf5f5f5)
        $0.pgCtrlSelectedColor = Color(0xffffff)
        $0.countRow = 2
        $0.countCol = 5
    }
    
    var arrMenu :[CatModel] = []
    
    func clickAction(_ index:String,_ catName:String){
        guard let action = clickEvent else {
            return
        }
        action(index,catName)
    }
    
    override func setupView() {
        hidLine()
        self.contentView.backgroundColor = Color(0xffffff)
        self.contentView.addSubview(self.slidingMenuView)
        self.slidingMenuView.delegate = self
        
        self.slidingMenuView.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
        }
    }
}
extension ClassCell:CoolSlidingMenuViewDelegate{
    @objc func coolSlidingMenu(_ slidingBoxMenu: CoolSlidingMenuView, didSelectedItemAt index: Int){
        self.clickAction(self.model![index].id,self.model![index].name)
    }

}
