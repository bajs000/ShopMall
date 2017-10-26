//
//  GuideView.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/26.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit

class GuideView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var complete: (() -> Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.register(UINib(nibName: "GuideCell", bundle: nil), forCellWithReuseIdentifier: "Cell")
        self.delegate = self
        self.dataSource = self
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return UIScreen.main.bounds.size
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: "guide-" + String(indexPath.row))!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            self.removeFromSuperview()
            complete()
        }
    }
    
}
