//
//  FindPwdViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/26.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class FindPwdViewController: UITableViewController {

    @IBOutlet weak var phoneNum: UITextField!
    @IBOutlet weak var verifyCode: UITextField!
    @IBOutlet weak var newPwd: UITextField!
    @IBOutlet weak var surePwd: UITextField!
    
    var verify: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
//        self.tableView.scrollIndicatorInsets =  UIEdgeInsetsMake(64, 0, 0, 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func getVerifyAction(_ sender: Any) {
        if phoneNum.text?.characters.count != 11 {
            SVProgressHUD.showError(withStatus: "请正确输入手机号")
            return
        }
        SVProgressHUD.show()
        Network.request(["phone":phoneNum.text!], url: "Register/gain_yzm") { (dic) in
            print(dic)
            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.showSuccess(withStatus: "成功发送验证码，请稍后查收")
                self.verify = (dic as! NSDictionary)["verify"] as? String
            }else {
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }
    
    @IBAction func commitAction(_ sender: Any) {
        requestFindPwd()
    }
    
    func requestFindPwd() -> Void {
        if phoneNum.text?.characters.count != 11 {
            SVProgressHUD.showError(withStatus: "请正确输入手机号")
            return
        }
        if verify == nil {
            SVProgressHUD.showError(withStatus: "请选获取验证码")
            return
        }
        if verifyCode.text != verify{
            SVProgressHUD.showError(withStatus: "请正确输入验证码")
            return
        }
        
        if (newPwd.text?.characters.count)! < 6 {
            SVProgressHUD.showError(withStatus: "请输入6位以上密码")
            return
        }
        if newPwd.text != surePwd.text {
            SVProgressHUD.showError(withStatus: "两次密码不一致")
            return
        }
        SVProgressHUD.show()
        Network.request(["phone":phoneNum.text!,"pass":newPwd.text!], url: "Register/pwd_wjedit") { (dic) in
            print(dic)
            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.showSuccess(withStatus: "修改成功，请重新登录")
                _ = self.navigationController?.popViewController(animated: true)
            }else {
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }

}
