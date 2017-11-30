//
//  LicenseViewController.swift
//  ShopMall
//
//  Created by 果儿 on 2017/10/25.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class LicenseViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var placeText: UITextField!
    @IBOutlet weak var registText: UITextField!
    @IBOutlet weak var corporationText: UITextField!
    @IBOutlet weak var termText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var rangeText: UITextField!
    @IBOutlet weak var licenseImg: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    let formatter = DateFormatter()
    var place: String = ""
    var placeDic = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "yyyy-MM-dd"
        imagePicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            if placeText.text?.characters.count == 0{
                
            }
        }else if indexPath.row == 6 {
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
    }
    // MARK:- UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        self.licenseImg.image = (info[UIImagePickerControllerOriginalImage] as! UIImage)
        self.dismiss(animated: true, completion: nil)
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "placePush" {
            if placeText.text?.characters.count != 0 {
                return false
            }
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        (segue.destination as! PlaceViewController).completeChose = {(str,dic) in
            self.placeText.text = str
            self.placeText.isEnabled = true
            self.place = str
            self.placeDic = dic
        }
    }
    
    @IBAction func placeEditChanged(_ sender: UITextField) {
        if (sender.text?.hasPrefix(place))! {
            
        }else {
            sender.text = place
        }
    }
    
    @IBAction func datePickerAction(_ sender: UIDatePicker) {
        termText.text = formatter.string(from: sender.date)
    }
    
    @IBAction func commitAction(_ sender: Any) {
        if titleText.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入厂家名称")
            return
        }
        if placeText.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请选择地址")
            return
        }
        if registText.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入注册号")
            return
        }
        if corporationText.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入法定代表人名字")
            return
        }
        if termText.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请选择营业期限")
            return
        }
        if rangeText.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入经验范围")
            return
        }
        if licenseImg.image == nil {
            SVProgressHUD.showError(withStatus: "请选择营业执照")
            return
        }
        SVProgressHUD.show()
        UploadNetwork.request(["name":titleText.text!,
                               "province":(self.placeDic["province"] as! NSDictionary)["id"] as! String,
                               "city":(self.placeDic["city"] as! NSDictionary)["id"] as! String,
                               "district":(self.placeDic["district"] as! NSDictionary)["id"] as! String,
                               "address":String(placeText.text![place.endIndex..<placeText.text!.endIndex]),
                               "zhuce_code":registText.text!,
                               "daibiao_name":corporationText.text!,
                               "end_time":termText.text!,
                               "rangeText":rangeText.text!,
                               "user_id":UserModel.share.userId], data: self.licenseImg.image!, paramName: "img", url: "User/licenseadd") { (dic) in
                                if (dic as! NSDictionary)["code"] as! String == "200" {
                                    SVProgressHUD.dismiss()
                                    _ = self.navigationController?.popViewController(animated: true)
                                }else {
                                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
                                }
        }
        
//        Network.request(["name":titleText.text!,
//                         "province":(self.placeDic["province"] as! NSDictionary)["id"] as! String,
//                         "city":(self.placeDic["city"] as! NSDictionary)["id"] as! String,
//                         "district":(self.placeDic["district"] as! NSDictionary)["id"] as! String,
//                         "address":String(placeText.text![place.endIndex..<placeText.text!.endIndex]),
//                         "zhuce_code":registText.text!,
//                         "daibiao_name":corporationText.text!,
//                         "end_time":termText.text!,
//                         "rangeText":rangeText.text!,
//                         "user_id":UserModel.share.userId], url: "User/licenseadd") { (dic) in
//            if (dic as! NSDictionary)["code"] as! String == "200" {
//                SVProgressHUD.dismiss()
//                _ = self.navigationController?.popViewController(animated: true)
//            }else {
//                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
//            }
//        }
    }
    
    
}
