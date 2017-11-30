//
//  MainCell.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/16.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import PYPhotoBrowser

class MainCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    
    open var nextResponder1: MainViewController!
    
    var imgArr: NSArray?{
        didSet{
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewHeight.constant = (Helpers.screanSize().width - 39) / 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    //MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imgArr == nil {
            return 0
        }
        return imgArr!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (Helpers.screanSize().width - 39) / 4, height: (Helpers.screanSize().width - 39) / 4)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let dic = self.imgArr?[indexPath.row] as! NSDictionary
//        let imgView = cell.viewWithTag(1) as! UIImageView
//        imgView.kt_addCorner(radius: 14)
        cell.viewWithTag(1)?.layer.cornerRadius = 4
        cell.viewWithTag(1)?.layer.borderColor = #colorLiteral(red: 0.8797392845, green: 0.8797599673, blue: 0.8797488809, alpha: 1)
        cell.viewWithTag(1)?.layer.borderWidth = 1
        cell.viewWithTag(1)?.layer.shouldRasterize = true
        (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["img"] as! String)), completed: nil)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        var urls = [String]()
        var sourceImgageViews = [UIImageView]()
        var i = 0
        for dic in self.imgArr! {
            let cell = collectionView.cellForItem(at: IndexPath(row: i, section: 0))
            sourceImgageViews.append(cell?.viewWithTag(1) as! UIImageView)
            let dict = dic as! NSDictionary
            urls.append(Helpers.baseImgUrl() + (dict["img"] as! String))
            i += 1
            if i == 4 {
                break
            }
        }
//        let browser = PYPhotosView(thumbnailUrls: thumbnailUrls, originalUrls: thumbnailUrls)
//        nextResponder1.view.addSubview(browser!)
        let browser = PYPhotoBrowseView()
        browser.sourceImgageViews = sourceImgageViews
        browser.imagesURL = urls
        browser.currentIndex = indexPath.row
        browser.show()
    }
    
}

class TapCollectionView: UICollectionView {
    
    var tapCollectionView: ((UITapGestureRecognizer) -> Void)!
    
    override func awakeFromNib() {
        super.awakeFromNib()
//        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapAction(_:))))
    }
    
    @objc func tapAction(_ sender: UITapGestureRecognizer) -> Void {
        tapCollectionView(sender)
    }
    
}
