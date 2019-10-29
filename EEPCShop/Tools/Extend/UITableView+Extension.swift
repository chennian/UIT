//
//  UITableView+Extension.swift
//  XHXMerchant
//
//  Created by Mac Pro on 2018/5/23.
//  Copyright © 2018年 CHENNIAN. All rights reserved.
//

import UIKit

extension UITableView{
    func tableViewWithEmptyMsg(_ msg:String,_ count:Int){
        if count == 0{
            let messagelable = UILabel()
            messagelable.text = msg
            messagelable.font = Font(32)
            messagelable.textColor = Color(0x8e8e8e)
            messagelable.textAlignment = .center
            messagelable.sizeToFit()
            self.backgroundView = messagelable
        }else{
            self.backgroundView = nil
        }
    }
    
}
