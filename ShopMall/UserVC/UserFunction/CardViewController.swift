//
//  CardViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/25.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class CardViewController: UITableViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var commitBtn: UIButton!
    @IBOutlet weak var cardText: UITextField!
    @IBOutlet weak var frontImg: UIImageView!
    @IBOutlet weak var behindImg: UIImageView!
    
    let imgPicker = UIImagePickerController()
    var currentIndexPath: IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        commitBtn.layer.cornerRadius = 8
        imgPicker.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if  indexPath.row == 2 || indexPath.row == 3 {
            if indexPath.row == 2 {
                currentIndexPath = indexPath
            }else if indexPath.row == 3 {
                currentIndexPath = indexPath
            }
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "拍照", style: .default, handler: { (action) in
                self.imgPicker.sourceType = .camera
                self.present(self.imgPicker, animated: true, completion: nil)
            }))
            sheet.addAction(UIAlertAction(title: "相册", style: .default, handler: { (action) in
                self.imgPicker.sourceType = .savedPhotosAlbum
                self.present(self.imgPicker, animated: true, completion: nil)
            }))
            sheet.addAction(UIAlertAction(title: "取消", style: .cancel, handler: nil))
            self.present(sheet, animated: true, completion: nil)
        }
    }

    // Mark: - UIImagePickerViewDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if currentIndexPath?.row == 2 {
            frontImg.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }else if currentIndexPath?.row == 3 {
            behindImg.image = info[UIImagePickerControllerOriginalImage] as? UIImage
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

    @IBAction func commitAction(_ sender: Any) {
        if cardText.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入身份证")
            return
        }
        if frontImg.image == nil {
            SVProgressHUD.showError(withStatus: "请选择身份证正面照")
            return
        }
        if behindImg.image == nil {
            SVProgressHUD.showError(withStatus: "请选择身份证背面照")
            return
        }
        SVProgressHUD.show()
        UploadNetwork.request(["ID_name":"身份证","IDnumber":cardText.text!,"user_id":UserModel.share.userId], datas: ["ID_zimg":frontImg.image!,"ID_fimg":behindImg.image!], paramName: nil, url: "User/IDcardadd") { (dic) in
            print(dic)
            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.dismiss()
                _ = self.navigationController?.popViewController(animated: true)
            }else {
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }
    
}
