//
//  AuthenticationViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/25.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class AuthenticationViewController: UITableViewController {

    @IBOutlet weak var phoneStatus: UILabel!
    @IBOutlet weak var cardStatus: UILabel!
    @IBOutlet weak var wechatStatus: UILabel!
    @IBOutlet weak var qqStatus: UILabel!
    @IBOutlet weak var licenseStatus: UILabel!
    
    var dataSource: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAuthentication()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    // MARK: - Navigation

    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "cardPush" {
            if (dataSource!["shenfen_renzheng"] as! NSNumber).intValue == 1 {
                return false
            }
        }
        return true
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func setStatus(_ status: NSNumber, label: UILabel) {
        if status.intValue == 0 {
            label.text = "未认证"
            label.textColor = #colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1)
            label.superview?.viewWithTag(1)?.isHidden = false
        }else {
            label.text = "已认证"
            label.textColor = #colorLiteral(red: 0.7095867991, green: 0.7096036673, blue: 0.709594667, alpha: 1)
            label.superview?.viewWithTag(1)?.isHidden = true
        }
    }
    
    func requestAuthentication() -> Void {
        SVProgressHUD.show()
        Network.request(["user_id":UserModel.share.userId], url: "User/renzheng") { (dic) in
            print(dic)
            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.dismiss()
                self.dataSource = (dic as! NSDictionary)["list"] as? NSDictionary
                self.setStatus((((dic as! NSDictionary)["list"] as! NSDictionary)["phone_renzheng"] as! NSNumber), label: self.phoneStatus)
                self.setStatus((((dic as! NSDictionary)["list"] as! NSDictionary)["shenfen_renzheng"] as! NSNumber), label: self.cardStatus)
                self.setStatus((((dic as! NSDictionary)["list"] as! NSDictionary)["weixin_renzheng"] as! NSNumber), label: self.wechatStatus)
                self.setStatus((((dic as! NSDictionary)["list"] as! NSDictionary)["qq_renzheng"] as! NSNumber), label: self.qqStatus)
                self.setStatus((((dic as! NSDictionary)["list"] as! NSDictionary)["zhizhao_renzheng"] as! NSNumber), label: self.licenseStatus)
            }else {
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }

}
