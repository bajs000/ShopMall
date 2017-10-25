//
//  LicenseViewController.swift
//  ShopMall
//
//  Created by 果儿 on 2017/10/25.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class LicenseViewController: UITableViewController {

    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var placeText: UITextField!
    @IBOutlet weak var registText: UITextField!
    @IBOutlet weak var corporationText: UITextField!
    @IBOutlet weak var termText: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var rangeText: UITextField!
    
    let formatter = DateFormatter()
    var place: String = ""
    var placeDic = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        formatter.dateFormat = "yyyy-MM-dd"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            if placeText.text?.characters.count == 0{
                
            }
        }
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
            SVProgressHUD.showError(withStatus: "请输入身份证")
            return
        }
        if placeText.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入身份证")
            return
        }
        if registText.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入身份证")
            return
        }
        if corporationText.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入身份证")
            return
        }
        if termText.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入身份证")
            return
        }
        if rangeText.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入身份证")
            return
        }
        SVProgressHUD.show()
        Network.request(["name":titleText.text!,
                         "province":(self.placeDic["province"] as! NSDictionary)["id"] as! String,
                         "city":(self.placeDic["city"] as! NSDictionary)["id"] as! String,
                         "district":(self.placeDic["district"] as! NSDictionary)["id"] as! String,
                         "address":String(placeText.text![place.endIndex..<placeText.text!.endIndex]),
                         "zhuce_code":registText.text!,
                         "daibiao_name":corporationText.text!,
                         "end_time":termText.text!,
                         "rangeText":rangeText.text!,
                         "user_id":UserModel.share.userId], url: "User/licenseadd") { (dic) in
            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.dismiss()
                _ = self.navigationController?.popViewController(animated: true)
            }else {
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }
    
    
}
