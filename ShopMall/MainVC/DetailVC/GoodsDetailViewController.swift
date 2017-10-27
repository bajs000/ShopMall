//
//  GoodsDetailViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class GoodsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var moreView: UIView!
    @IBOutlet weak var moreViewHeight: NSLayoutConstraint!
    
    var detailInfo: NSDictionary!
    var imgHeightDic = [String:CGFloat]()
    var dataSource: NSDictionary?{
        didSet {
            if (dataSource!["list"] as! NSDictionary)["graphic"] != nil && ((dataSource!["list"] as! NSDictionary)["graphic"] as! NSObject).isKind(of: NSArray.self){
                for i in 0...((dataSource!["list"] as! NSDictionary)["graphic"] as! NSArray).count - 1 {
                    imgHeightDic[String(i)] = 50
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bottomView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        bottomView.layer.shadowOpacity = 0.1
        bottomView.layer.shadowRadius = 4
        bottomView.layer.shadowOffset = CGSize(width: -2, height: -2)
        requestDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        if dataSource == nil {
            return 0
        }
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }else {
            if (dataSource!["list"] as! NSDictionary)["graphic"] != nil && ((dataSource!["list"] as! NSDictionary)["graphic"] as! NSObject).isKind(of: NSArray.self){
                return 1 + ((dataSource!["list"] as! NSDictionary)["graphic"] as! NSArray).count
            }
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        }else {
            if indexPath.row == 0 {
                return UITableViewAutomaticDimension
            }else {
                return imgHeightDic[String(indexPath.row - 1)]!
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        return v
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = ""
        if indexPath.section == 0 {
            cellIdentify = "infoCell"
        }else {
            if indexPath.row == 0 {
                cellIdentify = "detailCell"
            }else {
                cellIdentify = "imgCell"
            }
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if indexPath.section == 0 {
            cell.viewWithTag(1)?.layer.cornerRadius = 15
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + ((dataSource!["list"] as! NSDictionary)["img"] as! String)), completed: nil)
            (cell.viewWithTag(2) as! UILabel).text = (dataSource!["list"] as! NSDictionary)[""] as? String
            (cell.viewWithTag(3) as! UILabel).text = (dataSource!["list"] as! NSDictionary)["time"] as? String
            (cell.viewWithTag(4) as! UILabel).text = (dataSource!["list"] as! NSDictionary)["address"] as? String
        }else {
            if indexPath.row == 0 {
                (cell.viewWithTag(1) as! UILabel).text = (dataSource!["list"] as! NSDictionary)["describe"] as? String
            }else {
                let dic = ((dataSource!["list"] as! NSDictionary)["graphic"] as! NSArray)[indexPath.row - 1] as! NSDictionary
                (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["img"] as! String))!, completed: { (image, error, type, url) in
                    if image != nil{
                        let width = Helpers.screanSize().width - 30
                        let height = width * (image?.size.height)! / (image?.size.width)!
                        if self.imgHeightDic[String(indexPath.row - 1)] != height{
                            self.imgHeightDic[String(indexPath.row - 1)] = height
                            self.tableView.reloadData()
                        }
                    }
                })
            }
        }
        return cell
    }

    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return UserModel.checkUserLogin(at: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         if segue.destination.isKind(of: CommentViewController.self) {
            (segue.destination as! CommentViewController).dataSource = self.dataSource!
        }
    }
    
    @IBAction func bottomAction(_ sender: UIButton) {
        if !UserModel.checkUserLogin(at: self) {
            return
        }
        switch sender.tag {
        case 1:
            let alert = (Bundle.main.loadNibNamed("SMAlertView", owner: self, options: nil)![0]) as! SMAlertView
            alert.placeholderStr = "请评论"
            alert.keyboardType = .default
            alert.completeEnter = {(str) in
                SVProgressHUD.show()
                Network.request(["user_id":UserModel.share.userId,"release_id":self.detailInfo["release_id"] as! String,"content":str], url: "Public/ping_add", complete: { (dic) in
                    print(dic)
                    if (dic as! NSDictionary)["code"] as! String == "200" {
                        SVProgressHUD.showSuccess(withStatus: "评价成功")
                    }else {
                        SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
                    }
                })
            }
            alert.showOnWindows()
            break
        case 2:
            SVProgressHUD.show()
            var url = "Public/shoucang_add"
            if ((self.dataSource!["list"] as! NSDictionary)["shoucang_state"] as! NSNumber).intValue == 1{
                url = "Public/shoucang_del"
            }
            Network.request(["user_id":UserModel.share.userId,"release_id":self.detailInfo["release_id"] as! String], url: url, complete: { (dic) in
                print(dic)
                if (dic as! NSDictionary)["code"] as! String == "200" {
                    SVProgressHUD.showSuccess(withStatus: "收藏成功")
                    if ((self.dataSource!["list"] as! NSDictionary)["shoucang_state"] as! NSNumber).intValue == 1 {
                        SVProgressHUD.showSuccess(withStatus: "收藏成功")
                        (self.bottomView.viewWithTag(2) as! UIButton).setImage(#imageLiteral(resourceName: "detail-store"), for: .normal)
                    }else {
                        SVProgressHUD.showSuccess(withStatus: "删除收藏成功")
                        (self.bottomView.viewWithTag(2) as! UIButton).setImage(#imageLiteral(resourceName: "detail-store-not"), for: .normal)
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        self.requestDetail()
                    })
                }else {
                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
                }
            })
            break
        case 3:
            UIApplication.shared.openURL(URL(string:"tel://" + (((self.dataSource!["list"] as! NSDictionary)["user"] as! NSDictionary)["phone"] as! String))!)
            break
        default:
            break
        }
    }
    
    @IBAction func shareAction(_ sender: Any) {
        tapToHideAction(nil)
        UMSocialUIManager.setPreDefinePlatforms([UMSocialPlatformType.wechatSession,UMSocialPlatformType.wechatFavorite,UMSocialPlatformType.QQ])
        UMSocialUIManager.showShareMenuViewInWindow { (type, userInfo) in
            print(type)
            print(userInfo ?? "")
        }
    }
    
    @IBAction func reportAction(_ sender: Any) {
        tapToHideAction(nil)
    }
    
    @IBAction func moreAction(_ sender: Any) {
        if moreView.isHidden {
            moreView.isHidden = false
            UIView.animate(withDuration: 0.5, animations: {
                self.moreView.viewWithTag(1)?.alpha = 0.8
                self.moreViewHeight.constant = 88
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func tapToHideAction(_ sender: Any?) {
        if moreView.isHidden == false {
            UIView.animate(withDuration: 0.5, animations: {
                self.moreView.viewWithTag(1)?.alpha = 0
                self.moreViewHeight.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { (finish) in
                self.moreView.isHidden = true
            })
        }
    }
    
    func requestDetail() -> Void {
        SVProgressHUD.show()
        Network.request(["user_id":UserModel.share.userId,"release_id":detailInfo["release_id"] as! String], url: "Public/release_details") { (dic) in
            print(dic)
            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.dismiss()
                self.dataSource = dic as? NSDictionary
                self.tableView.reloadData()
                if ((self.dataSource!["list"] as! NSDictionary)["shoucang_state"] as! NSNumber).intValue == 1 {
                    (self.bottomView.viewWithTag(2) as! UIButton).setImage(#imageLiteral(resourceName: "detail-store"), for: .normal)
                }else {
                    (self.bottomView.viewWithTag(2) as! UIButton).setImage(#imageLiteral(resourceName: "detail-store-not"), for: .normal)
                }
            }else {
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }

}
