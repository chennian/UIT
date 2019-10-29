//
//  CoolSlidingMenuView.swift
//  CoolSlidingMenu
//
//  Created by 陈波 on 2017/7/15.
//  Copyright © 2017年 陈波. All rights reserved.
//

import UIKit

@objc protocol CoolSlidingMenuViewDelegate:NSObjectProtocol {
    
    /// coolSlidingMenu
    ///
    /// - Parameters:
    ///   - slidingBoxMenu: slidingBoxMenu
    ///   - index: index
    @objc optional func coolSlidingMenu(_ slidingBoxMenu: CoolSlidingMenuView, didSelectedItemAt index: Int);
    
}

class CoolSlidingMenuView: UIView,UICollectionViewDelegate,UICollectionViewDataSource {
    
    var countRow:Int!
    var countCol:Int!
    public var pgCtrlNormalColor: UIColor = .lightGray
    public var pgCtrlSelectedColor: UIColor = .orange
    public var pgCtrlIsHidden:Bool = false
    var collectionView:UICollectionView!
    var pgCtrl = UIPageControl()
    public var arrMenu:[CatModel] = [] {
        willSet {
            let layout = UICollectionViewFlowLayout()
            let sideLength = UIScreen.main.bounds.width / CGFloat(countCol)
            layout.itemSize = CGSize(width: sideLength , height: fit(141))
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.minimumInteritemSpacing = 0
            collectionView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: fit(282)), collectionViewLayout: layout)
            collectionView.backgroundColor = Color(0xffffff)
            collectionView.dataSource = self
            collectionView.delegate = self
            collectionView.isPagingEnabled = true
            collectionView.showsVerticalScrollIndicator = false
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.contentInset = UIEdgeInsets(top: 0.0, left: 0, bottom: 0.0, right: 0)
//            collectionView.register(UINib(nibName: "CoolSlidingMenuCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cCell")
            collectionView.register(CoolSlidingMenuCollectionViewCell.self, forCellWithReuseIdentifier: "cCell")
            collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "blankCell")
            self.addSubview(collectionView)
            self.addSubview(pgCtrl)
            if pgCtrlIsHidden == false {
                pgCtrl.currentPage = 0
                pgCtrl.pageIndicatorTintColor = pgCtrlNormalColor
                pgCtrl.currentPageIndicatorTintColor = pgCtrlSelectedColor
            }
            
        }
        didSet{
//            pgCtrl.numberOfPages = (arrMenu.count + countRow * countCol - 1) / (countRow * countCol)
            let num1 = countCol * countRow
            let num2 = (arrMenu.count + countRow * countCol - 1)
            let num3 = (countRow * countCol)
            let num4 = num2 / num3
//
            pgCtrl.numberOfPages = arrMenu.count > num1  ? num4 : 0
//            pgCtrl.numberOfPages = arrMenu.count > countCol * countRow ? (arrMenu.count + countRow * countCol - 1) / (countRow * countCol) : 0
            collectionView.reloadData()
        }
    }
    
    public var delegate:CoolSlidingMenuViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let widthPgCtrl = pgCtrl.size(forNumberOfPages: pgCtrl.numberOfPages).width
        pgCtrl.frame = CGRect(x: (self.bounds.width - widthPgCtrl) / 2, y: self.bounds.size.height - 12, width: widthPgCtrl, height: 12)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let num1 = (arrMenu.count + (countRow * countCol - 1))
        let num2 = (countRow * countCol)
//        let countSet = (arrMenu.count + (countRow * countCol - 1)) / (countRow * countCol) * (countRow * countCol)  // 先去掉尾数，再补缺
        let countSet = num1 / num2 * num2
        return countSet
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let indexChanged = CoolSlidingMenuManager.manager.convertDirectionCount(Number: indexPath.row, RowCount: countRow, ColCount: countCol)
            //.convertDirectionCount(Number: indexPath.row);
        if indexChanged < arrMenu.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cCell", for: indexPath) as! CoolSlidingMenuCollectionViewCell
            let dicMenu = arrMenu[indexChanged]
            cell.dicMenu = dicMenu
            return cell
        }
        else {
            let cell = collectionView .dequeueReusableCell(withReuseIdentifier: "blankCell", for: indexPath)
            cell.isUserInteractionEnabled = false
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let indexChanged = CoolSlidingMenuManager.manager.convertDirectionCount(Number: indexPath.row, RowCount: countRow, ColCount: countCol)
        if indexChanged < arrMenu.count {
            self.delegate?.coolSlidingMenu!(self, didSelectedItemAt: indexChanged)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(collectionView.contentOffset.x / self.bounds.width)
        pgCtrl.currentPage = page
    }
    
}

