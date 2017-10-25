//
//  UserViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/17.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class UserViewController: UITableViewController {

    @IBOutlet weak var mainFuncView: UIView!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainFuncView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mainFuncView.layer.shadowOpacity = 0.08
        mainFuncView.layer.shadowRadius = 4
        mainFuncView.layer.shadowOffset = CGSize(width: 4, height: 4)
        avatarImg.layer.cornerRadius = 36
        avatarImg.sd_setImage(with: URL(string: Helpers.baseImgUrl() + UserModel.share.face)!, completed: nil)
        userName.text = UserModel.share.name
    }

    override func viewWillAppear(_ animated: Bool) {
        if UserModel.share.userId.characters.count == 0 {
            avatarImg.image = nil
            userName.text = ""
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                self.tabBarController?.selectedIndex = 0
            })
        }else {
            requestUser()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    func requestUser() {
        SVProgressHUD.show()
        Network.request(["user_id":UserModel.share.userId], url: "User") { (dic) in
            print(dic)
            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.dismiss()
                UserModel.saveUserinfo(dic)
                self.avatarImg.sd_setImage(with: URL(string: Helpers.baseImgUrl() + UserModel.share.face)!, completed: nil)
                self.userName.text = UserModel.share.name
            }else {
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }
    
}
