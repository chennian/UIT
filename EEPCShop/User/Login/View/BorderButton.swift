//
//  BorderButton.swift
//  sevenloan
//
//  Created by spectator Mr.Z on 2018/12/4.
//  Copyright © 2018 tangxers. All rights reserved.
//

import UIKit

class BorderButton: UIButton {

    let dl = UILabel().then {
        $0.textColor =  Color(0xfefefe)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(Color(0xfefefe), for: .normal)
        
        
        addSubview(dl)
        
        dl.snp.makeConstraints { (make) in
            
            make.center.snEqualToSuperview()
        }
        
        layer.borderColor = Color(0xffffff).cgColor
        layer.borderWidth = fit(2)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(content: String) {
        dl.text = content
        
    }
    
    func set(color: UIColor, borderColor: UIColor?) {
        layer.borderColor = borderColor == nil ? color.cgColor : borderColor?.cgColor
        dl.textColor = color
    }

}
