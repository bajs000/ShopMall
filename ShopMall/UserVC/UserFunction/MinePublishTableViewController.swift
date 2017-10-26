//
//  MinePublishTableViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class MinePublishTableViewController: UITableViewController {

    var dataSource: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestMine()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource == nil {
            return 0
        }
        return (self.dataSource!["list"] as! NSArray).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dic = (self.dataSource!["list"] as! NSArray)[indexPath.row] as! NSDictionary
        let imgArr = (dic["release_img"] as! NSArray)
        var cellIdentify = "Cell"
        if imgArr.count == 0 {
            cellIdentify = "Cell"
        }else if imgArr.count < 3 {
            cellIdentify = "Cell1"
        }else if imgArr.count > 2{
            cellIdentify = "Cell2"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        (cell.viewWithTag(1) as! UILabel).text = dic["day"] as? String
        (cell.viewWithTag(2) as! UILabel).text = (dic["month"] as! String) + "月"
        var address = dic["address"] as! String
        if address.characters.count == 0 {
            address = "无地址"
        }else {
            let arr = (address as NSString).components(separatedBy: "市")
            if arr.count == 0 {
                address = arr[0]
            }else {
                address = arr[0] + "市"
            }
        }
        (cell.viewWithTag(3) as! UILabel).text = address
        (cell.viewWithTag(5) as! UILabel).text = dic["describe"] as? String
        if (dic["release_img"] as! NSArray).count == 0 {
            
        }else {
            for i in 0...min(imgArr.count - 1, 3) {
                let dict = imgArr[i] as! NSDictionary
                (cell.viewWithTag(41 + i) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dict["img"] as! String)), completed: nil)
                cell.viewWithTag(41 + i)?.layer.cornerRadius = 2
                cell.viewWithTag(41 + i)?.layer.borderWidth = 1
                cell.viewWithTag(41 + i)?.layer.borderColor = #colorLiteral(red: 0.8797392845, green: 0.8797599673, blue: 0.8797488809, alpha: 1)
            }
        }
        return cell
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: GoodsDetailViewController.self) {
            if (sender as! NSObject).isKind(of: UITableViewCell.self){
                let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
                (segue.destination as! GoodsDetailViewController).detailInfo = (self.dataSource!["list"] as! NSArray)[indexPath!.row] as! NSDictionary
            }else{
                let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: ((sender as! UITapGestureRecognizer).view as! UICollectionView))
                let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
                (segue.destination as! GoodsDetailViewController).detailInfo = (self.dataSource!["list"] as! NSArray)[indexPath!.row] as! NSDictionary
            }
        }
    }

    func requestMine() {
        SVProgressHUD.show()
        Network.request(["user_id":UserModel.share.userId,"page":"1"] as NSDictionary, url: "Public/release_list") { (dic) in
            print(dic)
            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.dismiss()
                self.dataSource = dic as? NSDictionary
                self.tableView.reloadData()
            }else {
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }
    
}