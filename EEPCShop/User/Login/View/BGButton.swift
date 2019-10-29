//
//  BGButton.swift
//  sevenloan
//
//  Created by spectator Mr.Z on 2018/12/4.
//  Copyright © 2018 tangxers. All rights reserved.
//

import UIKit

class BGButton: UIButton {

    let dl = UILabel().then {
        $0.textColor = .white
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setTitleColor(.white, for: .normal)
        backgroundColor = Color(0x3660fb)
//        setBackgroundImage(Image("buttonbg"), for: .normal)
        
        addSubview(dl)
        
        dl.snp.makeConstraints { (make) in
          
            make.center.snEqualToSuperview()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func set(content: String) {
        dl.text = content
       
    }
}
