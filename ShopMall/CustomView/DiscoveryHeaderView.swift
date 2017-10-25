//
//  DiscoveryHeaderView.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/17.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit

class DiscoveryHeaderView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet var adCollectionView: UICollectionView!
    @IBOutlet var funcCollectionView: UICollectionView!
    var completeChose: ((NSDictionary) -> Void)!
    
    var dataSource: NSDictionary?{
        didSet{
            self.adCollectionView.reloadData()
            self.funcCollectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.dataSource == nil {
            return 0
        }
        if collectionView == adCollectionView{
            return (self.dataSource?["img"] as! NSArray).count
        }else{
            return (self.dataSource?["type"] as! NSArray).count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == adCollectionView{
            return CGSize(width: Helpers.screanSize().width, height: 150)
        }else{
            return CGSize(width: Helpers.screanSize().width / 5, height: 91)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if collectionView == adCollectionView{
            let dic = (self.dataSource!["img"] as! NSArray)[indexPath.row] as! NSDictionary
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["bigpic"] as! String)), completed: nil)
        }else{
            let dic = (self.dataSource!["type"] as! NSArray)[indexPath.row] as! NSDictionary
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["type_app_img"] as! String)), completed: nil)
            (cell.viewWithTag(2) as! UILabel).text = dic["type_title"] as? String
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == funcCollectionView {
            let dic = (self.dataSource!["type"] as! NSArray)[indexPath.row] as! NSDictionary
            completeChose(dic)
        }
    }
    
}
