//
//  SearchViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/27.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import EVNCustomSearchBar

class SearchViewController: UITableViewController, EVNCustomSearchBarDelegate {

    var dataSource: NSDictionary?
    var searchBar: EVNCustomSearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar = EVNCustomSearchBar(frame: CGRect(x: 0, y: UIApplication.shared.statusBarFrame.size.height, width: Helpers.screanSize().width, height: 44))
        searchBar?.backgroundColor = UIColor.clear
        searchBar.iconAlign = .center
        searchBar.placeholder = "搜索"
        searchBar.placeholderColor = #colorLiteral(red: 0.4756349325, green: 0.4756467342, blue: 0.4756404161, alpha: 1)
        searchBar.delegate = self
        searchBar.isHiddenCancelButton = true
        searchBar.sizeToFit()
        if #available(iOS 11.0, *) {
            searchBar.heightAnchor.constraint(lessThanOrEqualToConstant: 44).isActive = true
        }
        self.navigationItem.titleView = searchBar
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource == nil {
            return 0
        }
        return (self.dataSource!["list"] as! NSArray).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dic = (self.dataSource!["list"] as! NSArray)[indexPath.row] as! NSDictionary
        (cell as! MainCell).imgArr = dic["release_img"] as? NSArray
//        (cell as! MainCell).collectionView.tapCollectionView = {(tap) in
//            self.performSegue(withIdentifier: "detailPush", sender: tap)
//        }
        cell.viewWithTag(1)?.layer.cornerRadius = 15
        (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["img"] as! String)), completed: nil)
        (cell.viewWithTag(2) as! UILabel).text = dic[""] as? String
        (cell.viewWithTag(3) as! UILabel).text = dic["time"] as? String
        //        if (dic["gongqiu"] as! String) == "2" {
        //            (cell.viewWithTag(4) as! UIImageView).image = #imageLiteral(resourceName: "main-seek")
        //        }else {
        //            (cell.viewWithTag(4) as! UIImageView).image = #imageLiteral(resourceName: "main-offer")
        //        }
        (cell.viewWithTag(5) as! UILabel).text = dic["describe"] as? String
        (cell.viewWithTag(6) as! UILabel).text = dic["address"] as? String
        (cell.viewWithTag(7) as! UIButton).setTitle(dic["ping_num"] as? String, for: .normal)
        if (dic["shoucang_state"] as! NSNumber).stringValue == "1" {
            (cell.viewWithTag(8) as! UIButton).setTitleColor(#colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1), for: .normal)
            (cell.viewWithTag(8) as! UIButton).setImage(#imageLiteral(resourceName: "main-like-not"), for: .normal)
        }else {
            (cell.viewWithTag(8) as! UIButton).setTitleColor(#colorLiteral(red: 0.7095867991, green: 0.7096036673, blue: 0.709594667, alpha: 1), for: .normal)
            (cell.viewWithTag(8) as! UIButton).setImage(#imageLiteral(resourceName: "main-like"), for: .normal)
        }
        (cell.viewWithTag(8) as! UIButton).setTitle(dic["shoucang_num"] as? String, for: .normal)
        if (dic["zan_state"] as! NSNumber).stringValue == "1" {
            (cell.viewWithTag(9) as! UIButton).setTitleColor(#colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1), for: .normal)
            (cell.viewWithTag(9) as! UIButton).setImage(#imageLiteral(resourceName: "main-praise"), for: .normal)
        }else {
            (cell.viewWithTag(9) as! UIButton).setTitleColor(#colorLiteral(red: 0.7095867991, green: 0.7096036673, blue: 0.709594667, alpha: 1), for: .normal)
            (cell.viewWithTag(9) as! UIButton).setImage(#imageLiteral(resourceName: "main-praise-not"), for: .normal)
        }
        (cell.viewWithTag(9) as! UIButton).setTitle(dic["zan_num"] as? String, for: .normal)
        
        (cell.viewWithTag(7) as! UIButton).addTarget(self, action: #selector(goodsAction(_:)), for: .touchUpInside)
        (cell.viewWithTag(8) as! UIButton).addTarget(self, action: #selector(goodsAction(_:)), for: .touchUpInside)
        (cell.viewWithTag(9) as! UIButton).addTarget(self, action: #selector(goodsAction(_:)), for: .touchUpInside)
        return cell
    }

    //MARK:- SearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: EVNCustomSearchBar) {
        self.requestSearch()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: CommentViewController.self){
            let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender as! UIButton)
            let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
            (segue.destination as! CommentViewController).dataSource = ["list":(self.dataSource!["list"] as! NSArray)[indexPath!.section] as! NSDictionary]
        }else if segue.destination.isKind(of: GoodsDetailViewController.self) {
            if (sender as! NSObject).isKind(of: UITableViewCell.self){
                let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
                (segue.destination as! GoodsDetailViewController).detailInfo = (self.dataSource!["list"] as! NSArray)[indexPath!.section] as! NSDictionary
            }else{
                let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: ((sender as! UITapGestureRecognizer).view as! UICollectionView))
                let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
                (segue.destination as! GoodsDetailViewController).detailInfo = (self.dataSource!["list"] as! NSArray)[indexPath!.section] as! NSDictionary
            }
        }
    }
    
    @objc func goodsAction(_ sender: UIButton) {
        if sender.tag == 7 {//评价
            self.performSegue(withIdentifier: "commentPush", sender: sender)
        }else if sender.tag == 8 {//收藏
            let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender)
            let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
            let dict = (self.dataSource!["list"] as! NSArray)[indexPath!.section] as! NSDictionary
            SVProgressHUD.show()
            var url = "Public/shoucang_add"
            if (dict["shoucang_state"] as! NSNumber).intValue == 1{
                url = "Public/shoucang_del"
            }
            Network.request(["user_id":UserModel.share.userId,"release_id":dict["release_id"] as! String], url: url, complete: { (dic) in
                print(dic)
                if (dic as! NSDictionary)["code"] as! String == "200" {
                    if (dict["shoucang_state"] as! NSNumber).intValue == 1 {
                        SVProgressHUD.showSuccess(withStatus: "收藏成功")
                    }else {
                        SVProgressHUD.showSuccess(withStatus: "删除收藏成功")
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        self.requestSearch()
                    })
                }else {
                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
                }
            })
        }else {// 点赞
            let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender)
            let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
            let dict = (self.dataSource!["list"] as! NSArray)[indexPath!.section] as! NSDictionary
            SVProgressHUD.show()
            var url = "Public/zan_add"
            if (dict["zan_state"] as! NSNumber).intValue == 1{
                url = "Public/zan_del"
            }
            Network.request(["user_id":UserModel.share.userId,"release_id":dict["release_id"] as! String], url: url, complete: { (dic) in
                print(dic)
                if (dic as! NSDictionary)["code"] as! String == "200" {
                    if (dict["zan_state"] as! NSNumber).intValue == 0 {
                        SVProgressHUD.showSuccess(withStatus: "点赞成功")
                    }else {
                        SVProgressHUD.showSuccess(withStatus: "删除点赞成功")
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        self.requestSearch()
                    })
                }else {
                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
                }
            })
        }
    }
    
    func requestSearch() -> Void {
        SVProgressHUD.show()
        Network.request(["title":searchBar.text!], url: "Public/sousuo") { (dic) in
            print(dic)
//            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.dismiss()
                self.dataSource = dic as? NSDictionary
                self.tableView.reloadData()
//            }else {
//                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
//            }
        }
    }

    func __searchFieldBackgroundImage() -> UIImage {
        let color = #colorLiteral(red: 0.9593952298, green: 0.9594177604, blue: 0.959405601, alpha: 1)
        let rect = CGRect(x: 0, y: 0, width: 28, height: 28)
        let roundedRect = UIBezierPath(roundedRect: rect, cornerRadius: 3)
        roundedRect.lineWidth = 0
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        color.setFill()
        roundedRect.fill()
        roundedRect.stroke()
        roundedRect.addClip()
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
}

class SearchTitleView : UIView {
    override var intrinsicContentSize: CGSize{
        return UILayoutFittingExpandedSize
    }
}
