//
//  LoginViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/17.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

enum registType:Int {
    case user = 11
    case vender = 12
}

class LoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tagLeading: NSLayoutConstraint!
    @IBOutlet weak var loginViewLeading: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var occlusionView: UIView!
    @IBOutlet weak var registBtn: UIButton!
    @IBOutlet weak var tableViewBottom: NSLayoutConstraint!
    @IBOutlet weak var registBg: UIView!
    @IBOutlet weak var userPhone: UITextField!
    @IBOutlet weak var userPwd: UITextField!
    
    var type: registType = .user
    var registArr:[[String:Any]]!
    var verifyCode: String?
    var currentVenderType: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tagLeading.constant = Helpers.screanSize().width / 4 - 9
        self.registBtn.layer.cornerRadius = 12
        self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 0, 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - UIKeyboard Show And Hide
    @objc func keyboardWillShow(_ notification: NSNotification) -> Void {
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let keyboardRect:CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        UIView.animate(withDuration: duration, animations: {
            self.tableViewBottom.constant = -keyboardRect.size.height
            self.view.layoutIfNeeded()
        }) { (finish) in
            
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) -> Void {
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration, animations: {
            self.tableViewBottom.constant = 0
            self.view.layoutIfNeeded()
        }) { (finish) in
            
        }
    }
    
    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.occlusionView.isHidden {
            return 0
        }
        if type == .user {
            return 4
        }else {
            return 7
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = "normalCell"
        if indexPath.row == 2 {
            cellIdentify = "specialCell"
        }else if indexPath.row == 6 {
            cellIdentify = "sortCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        (cell.viewWithTag(1) as! UIImageView).image = UIImage(named: registArr[indexPath.row]["icon"] as! String)
        (cell.viewWithTag(2) as! UITextField).text = registArr[indexPath.row]["text"] as? String
        (cell.viewWithTag(2) as! UITextField).placeholder = registArr[indexPath.row]["placeholder"] as? String
        (cell.viewWithTag(2) as! UITextField).keyboardType = registArr[indexPath.row]["keyboardType"] as! UIKeyboardType
        (cell.viewWithTag(2) as! UITextField).addTarget(self, action: #selector(textFieldChangeAction(_:)), for: .editingChanged)
        if indexPath.row == 3 {
            (cell.viewWithTag(2) as! UITextField).isSecureTextEntry = true
        }else {
            (cell.viewWithTag(2) as! UITextField).isSecureTextEntry = false
        }
        if indexPath.row == 2 {
            (cell.viewWithTag(3) as! UIButton).addTarget(self, action: #selector(getVerifyAction), for: .touchUpInside)
        }
        if indexPath.row == 6 {
            (cell.viewWithTag(2) as! UITextField).text = "所属类目"
            (cell.viewWithTag(3) as! UILabel).text = registArr[indexPath.row]["text"] as? String
        }
        return cell
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: TypeViewController.self){
            let type = segue.destination as! TypeViewController
            type.completeType = {(dic) in
                print(dic)
                self.currentVenderType = dic
                let tempDic = NSMutableDictionary(dictionary: self.registArr[6])
                tempDic["text"] = dic["type_title"] as! String + "    "
                self.registArr.remove(at: 6)
                self.registArr.insert(tempDic as! [String : Any], at: 6)
                self.occlusionView.isHidden = false//防止注册信息不显示
                self.tableView.reloadData()
                self.occlusionView.isHidden = true
            }
        }
    }
    
    @objc func textFieldChangeAction(_ sender: UITextField) -> Void {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender)
        let indexPath = tableView.indexPath(for: cell as! UITableViewCell)
        let tempDic = NSMutableDictionary(dictionary: registArr[indexPath!.row])
        tempDic["text"] = sender.text
        registArr.remove(at: indexPath!.row)
        registArr.insert(tempDic as! [String : Any], at: indexPath!.row)
    }

    @IBAction func tapToHideKeyboard(_ sender: Any) {
        UIApplication.shared.keyWindow?.endEditing(true)
    }
    
    @IBAction func swicthAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            if sender.tag == 1 {
                self.tagLeading.constant = Helpers.screanSize().width / 4 - 9
                UIView.animate(withDuration: 0.5, animations: {
                    self.loginViewLeading.constant = 0
                    self.view.layoutIfNeeded()
                }){ (finish) in
                    self.tableView.reloadData()
                    self.registBg.isHidden = true
                }
            }else{
                self.tagLeading.constant = Helpers.screanSize().width / 4 * 3 - 9
                self.occlusionView.isHidden = false
                UIView.animate(withDuration: 0.5, animations: {
                    self.occlusionView.viewWithTag(1)?.alpha = 0.8
                    self.occlusionView.viewWithTag(2)?.alpha = 1
                    self.loginViewLeading.constant = -Helpers.screanSize().width
                    self.view.layoutIfNeeded()
                })
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func registAction(_ sender: UIButton) -> Void {
        type = registType(rawValue: sender.tag)!
        if type == .user {
            registArr = [["icon":"login-username","placeholder":"请输入用户名称（设定后无法更改）","text":"","keyboardType":UIKeyboardType.default],
            ["icon":"login-phone","placeholder":"请输入手机号","text":"","keyboardType":UIKeyboardType.numberPad],
            ["icon":"login-verify","placeholder":"请输入验证码","text":"","keyboardType":UIKeyboardType.numberPad],
            ["icon":"login-pwd","placeholder":"请输入请设置密码","text":"","keyboardType":UIKeyboardType.default]]
        }else {
            registArr = [["icon":"login-username","placeholder":"请输入商家名称（设定后无法更改）","text":"","keyboardType":UIKeyboardType.default],
                         ["icon":"login-phone","placeholder":"请输入手机号","text":"","keyboardType":UIKeyboardType.numberPad],
                         ["icon":"login-verify","placeholder":"请输入验证码","text":"","keyboardType":UIKeyboardType.numberPad],
                         ["icon":"login-pwd","placeholder":"请输入请设置密码","text":"","keyboardType":UIKeyboardType.default],
                         ["icon":"login-wechat-icon","placeholder":"请输入微信号","text":"","keyboardType":UIKeyboardType.default],
                         ["icon":"login-qq-icon","placeholder":"请输入QQ号","text":"","keyboardType":UIKeyboardType.numberPad],
                         ["icon":"main-menu","placeholder":"请选择所属类目","text":"","keyboardType":UIKeyboardType.default]]
        }
        UIView.animate(withDuration: 0.5, animations: {
            self.occlusionView.viewWithTag(1)?.alpha = 0
            self.occlusionView.viewWithTag(2)?.alpha = 0
        }) { (finish) in
            self.tableView.reloadData()
            self.registBg.isHidden = false
            self.occlusionView.isHidden = true
        }
    }
    
    @IBAction func swipeAction(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .down {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func getVerifyAction() {
        if (registArr[0]["text"] as? String)?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: registArr[0]["placeholder"] as? String)
            return
        }
        if (registArr[1]["text"] as? String)?.characters.count != 11 {
            SVProgressHUD.showError(withStatus: "请正确输入手机号")
            return
        }
        SVProgressHUD.show()
        Network.request(["phone":(registArr[1]["text"] as! String)], url: "Register/register_yzm") { (dic) in
            print(dic)
            if (dic as! NSDictionary)["code"] as! String == "200" {
                self.verifyCode = (dic as! NSDictionary)["verify"] as? String
                SVProgressHUD.showSuccess(withStatus: "成功发送验证码，请稍后查收")
            }else {
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }
    
    @IBAction func registDidClick(_ sender: Any) {
        if verifyCode == nil {
            return SVProgressHUD.showError(withStatus: "请先获取验证码")
        }
        for i in 0...registArr.count - 1 {
            if i == 1 {
                if (registArr[1]["text"] as? String)?.characters.count != 11 {
                    SVProgressHUD.showError(withStatus: "请正确输入手机号")
                    return
                }
            }else if i == 2 {
                if (registArr[2]["text"] as? String) != verifyCode {
                    SVProgressHUD.showError(withStatus: "请正确输入验证码")
                    return
                }
            }else if i == 3 {
                if ((registArr[3]["text"] as? String)?.characters.count)! < 6 {
                    SVProgressHUD.showError(withStatus: "请输入6位以上密码")
                    return
                }
            }else {
                if (registArr[i]["text"] as? String)?.characters.count == 0 {
                    SVProgressHUD.showError(withStatus: registArr[i]["placeholder"] as? String)
                    return
                }
            }
        }
        SVProgressHUD.show()
        var url = ""
        var param = [String:String]()
        if type == .user {
            url = "Register"
            param = ["name":registArr[0]["text"] as! String,
                     "phone":registArr[1]["text"] as! String,
                     "pass":registArr[3]["text"] as! String]
        }else {
            url = "Register/bus_register"
            param = ["name":registArr[0]["text"] as! String,
                     "phone":registArr[1]["text"] as! String,
                     "pass":registArr[3]["text"] as! String,
                     "weixin":registArr[4]["text"] as! String,
                     "qq":registArr[5]["text"] as! String,
                     "type":currentVenderType!["type_roue_id"] as! String,
                     "address":""]
        }
        Network.request(param as NSDictionary, url: url) { (dic) in
            print(dic)
            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.showSuccess(withStatus: "注册成功")
                UserModel.saveUserinfo(dic)
                self.dismiss(animated: true, completion: nil)
            }else {
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if self.userPhone.text?.characters.count != 11 {
            SVProgressHUD.showError(withStatus: "请正确输入手机号")
            return
        }
        if (self.userPwd.text?.characters.count)! < 6 {
            SVProgressHUD.showError(withStatus: "请输入密码")
            return
        }
        SVProgressHUD.show()
        Network.request(["phone":self.userPhone.text!,"pass":self.userPwd.text!], url: "Login") { (dic) in
            print(dic)
            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.showSuccess(withStatus: "登陆成功")
                UserModel.saveUserinfo(dic)
                self.dismiss(animated: true, completion: nil)
            }else {
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }
    
}
