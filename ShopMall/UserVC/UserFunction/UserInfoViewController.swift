//
//  UserInfoViewController.swift
//  ShopMall
//
//  Created by 果儿 on 2017/10/17.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

enum UserInfoType {
    case qq
    case wechat
    case abstract
}

class UserInfoViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var qqLabel: UILabel!
    @IBOutlet weak var wechatLabel: UILabel!
    @IBOutlet weak var abstractLabel: UILabel!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.avatar.layer.cornerRadius = 30
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        avatar.sd_setImage(with: URL(string: Helpers.baseImgUrl() + UserModel.share.face)!, completed: nil)
        userName.text = UserModel.share.name
        
        setupInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func setupInfo() -> Void {
        qqLabel.text = UserModel.share.qq
        if (qqLabel.text?.characters.count)! > 0 {
            qqLabel.superview?.viewWithTag(1)?.isHidden = true
        }
        wechatLabel.text = UserModel.share.weixin
        if (wechatLabel.text?.characters.count)! > 0 {
            wechatLabel.superview?.viewWithTag(1)?.isHidden = true
        }
        abstractLabel.text = UserModel.share.jianjie
        if (abstractLabel.text?.characters.count)! > 0 {
            abstractLabel.superview?.viewWithTag(1)?.isHidden = true
        }
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let alert = (Bundle.main.loadNibNamed("SMAlertView", owner: self, options: nil)![0]) as! SMAlertView
        if indexPath.row == 0 {
            alert.placeholderStr = "请输入QQ"
            alert.text = UserModel.share.qq
            alert.keyboardType = .numberPad
        }else if indexPath.row == 1 {
            alert.placeholderStr = "请输入微信"
            alert.text = UserModel.share.weixin
        }else {
            alert.placeholderStr = "请输入个人简介"
            alert.text = UserModel.share.jianjie
        }
        alert.completeEnter = {(str) in
            if indexPath.row == 0 {
                self.qqLabel.text = str
                if (self.qqLabel.text?.characters.count)! > 0 {
                    self.qqLabel.superview?.viewWithTag(1)?.isHidden = true
                }
                self.requestSaveInfo("User/qqedit",param: ["qq":str,"user_id":UserModel.share.userId],type: .qq)
            }else if indexPath.row == 1 {
                self.wechatLabel.text = str
                if (self.wechatLabel.text?.characters.count)! > 0 {
                    self.wechatLabel.superview?.viewWithTag(1)?.isHidden = true
                }
                self.requestSaveInfo("User/weixinedit",param: ["weixn":str,"user_id":UserModel.share.userId],type: .wechat)
            }else {
                self.abstractLabel.text = str
                self.tableView.reloadData()
                if (self.abstractLabel.text?.characters.count)! > 0 {
                    self.abstractLabel.superview?.viewWithTag(1)?.isHidden = true
                }
                self.requestSaveInfo("User/jianjieedit",param: ["jianjie":str,"user_id":UserModel.share.userId],type: .abstract)
            }
        }
        alert.showOnWindows()
    }
    
    // MARK:- UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.avatar.image = (info[UIImagePickerControllerEditedImage] as! UIImage)
        self.dismiss(animated: true, completion: nil)
        UploadNetwork.request(["user_id":UserModel.share.userId], data: self.avatar.image!, paramName: "face", url: "User/faceedit") { (dic) in
            print(dic)
            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.showSuccess(withStatus: "修改成功")
                UserModel.share.resetAvatar()
            }else {
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func changeAvatarAction(_ sender: Any) {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "拍照", style: .default, handler: { (action) in
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "相册", style: .default, handler: { (action) in
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.present(self.imagePicker, animated: true, completion: nil)
        }))
        actionSheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func requestSaveInfo(_ url: String, param: [String:String], type: UserInfoType) -> Void {
        SVProgressHUD.show()
        Network.request(param as NSDictionary, url: "User/useredit") { (dic) in
            print(dic)
            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.dismiss()
                let userDefault = UserDefaults.standard
                if type == .qq {
                    UserModel.share.resetQQ()
                    userDefault.set(param["qq"], forKey: "QQ")
                }else if type == .wechat {
                    UserModel.share.resetWeixin()
                    userDefault.set(param["weixin"], forKey: "WEIXIN")
                }else {
                    UserModel.share.resetJianjie()
                    userDefault.set(param["jianjie"], forKey: "JIANJIE")
                }
                userDefault.synchronize()
            }else {
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }
}
