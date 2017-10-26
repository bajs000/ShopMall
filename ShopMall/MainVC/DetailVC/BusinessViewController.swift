//
//  BusinessViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/26.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class BusinessViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    var dataSource: NSDictionary?
    var businessInfo: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(self.businessInfo!)
        self.avatar.sd_setImage(with: URL(string: Helpers.baseImgUrl() + (self.businessInfo!["face"] as! String)), completed: nil)
        self.avatar.layer.cornerRadius = 36
        self.userName.text = self.businessInfo!["name"] as? String
        requestBusiness()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource == nil {
            return 0
        }
        return (self.dataSource!["list"] as! NSArray).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dic = (self.dataSource!["list"] as! NSArray)[indexPath.row] as! NSDictionary
        (cell as! MainCell).imgArr = dic["release_img"] as? NSArray
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

    // MARK: - Navigation
    
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
    
    @IBAction func attentionAction(_ sender: Any) {
        if UserModel.checkUserLogin(at: self) {
            SVProgressHUD.show()
            Network.request(["bus_id":self.businessInfo!["user_id"] as! String,"user_id":UserModel.share.userId], url: "Public/guanzhu_add", complete: { (dic) in
                print(dic)
                if (dic as! NSDictionary)["code"] as! String == "200" {
                    SVProgressHUD.showSuccess(withStatus: "关注成功")
                }else {
                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
                }
            })
        }
    }
    
    @IBAction func contactAction(_ sender: Any) {
        UIApplication.shared.openURL(URL(string: "tel://" + (self.businessInfo!["phone"] as! String))!)
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
                        self.requestBusiness()
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
                        self.requestBusiness()
                    })
                }else {
                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
                }
            })
        }
    }

    func requestBusiness() -> Void {
        SVProgressHUD.show()
        Network.request(["bus_id":self.businessInfo!["user_id"] as! String,"user_id":UserModel.share.userId], url: "Public/bus_list") { (dic) in
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
