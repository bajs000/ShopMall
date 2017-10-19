//
//  PublishViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/19.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class PublishViewController: UITableViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var surePublishBtn: UIButton!
    
    var placeholader: UILabel!
    var textView: UITextView!
    var collectionView: UICollectionView!
    var collectionViewHeight: NSLayoutConstraint!
    var locationText: UITextView!
    var typeLabel: UILabel!
    var segument: UISegmentedControl!
    
    let imagePicker = UIImagePickerController()
    var imgArr = [UIImage]()
    var currentType: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        self.surePublishBtn.layer.cornerRadius = 8
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = ""
        if indexPath.row == 0 {
            cellIdentify = "textCell"
        }else if indexPath.row == 1 {
            cellIdentify = "imgCell"
        }else if indexPath.row == 2 {
            cellIdentify = "locationCell"
        }else if indexPath.row == 3{
            cellIdentify = "Cell"
        }else if indexPath.row == 4 {
            cellIdentify = "supplyCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if indexPath.row == 0 {
            textView = cell.viewWithTag(2) as! UITextView
            placeholader = cell.viewWithTag(1) as! UILabel
        }else if indexPath.row == 1 {
            collectionView = cell.viewWithTag(1) as! UICollectionView
            for constraint in collectionView.constraints {
                if constraint.identifier == "height" {
                    collectionViewHeight = constraint
                    break
                }
            }
        }else if indexPath.row == 2 {
            locationText = cell.viewWithTag(1) as! UITextView
        }else if indexPath.row == 3 {
            typeLabel = cell.viewWithTag(2) as! UILabel
        }else {
            segument = cell.viewWithTag(9) as! UISegmentedControl
        }
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if indexPath.row == imgArr.count {
            (cell.viewWithTag(1) as! UIImageView).image = #imageLiteral(resourceName: "publish-add")
        }else {
            (cell.viewWithTag(1) as! UIImageView).image = imgArr[indexPath.row]
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == imgArr.count {
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
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imgArr.append(info[UIImagePickerControllerOriginalImage] as! UIImage)
        self.collectionView.reloadData()
        self.dismiss(animated: true, completion: nil)
        
        let totalCount = (Helpers.screanSize().width - 26) / (44 + 5)
        let num = (imgArr.count + 1) / Int(totalCount)
        if num >= 1 {
            collectionViewHeight.constant = CGFloat(44 * num) + CGFloat((num - 1) * 5)
            if (imgArr.count + 1) % Int(totalCount) > 0 {
                collectionViewHeight.constant = collectionViewHeight.constant + 44 + 5
            }
        }
        self.tableView.reloadData()
    }
    
    // MARK : - UITextView delegate
    func textViewDidChange(_ textView: UITextView) {
        if textView == self.textView {
            if textView.text.characters.count == 0 {
                placeholader.isHidden = false
            }else {
                placeholader.isHidden = true
            }
        }
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: TypeViewController.self) {
            (segue.destination as! TypeViewController).completeType = {(dic) in
                print(dic)
                self.currentType = dic
                self.typeLabel.text = dic["type_title"] as? String
            }
        }
    }
    
    @IBAction func surePublishAction(_ sender: Any) {
        if textView.text.characters.count == 0 && imgArr.count == 0 {
            SVProgressHUD.showError(withStatus: "描述和图片任选一")
            return
        }
        if locationText.text.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "未获取定位")
            return
        }
        if typeLabel.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请选择类目")
            return
        }
        SVProgressHUD.show()
        var gongqiu = ""
        if segument.selectedSegmentIndex == 0 {
            gongqiu = "1"
        }else{
            gongqiu = "2"
        }
        UploadNetwork.request(["user_id":UserModel.share.userId,
                               "describe":textView.text,
                               "address":locationText.text,
                               "gongqiu":gongqiu,
                               "type_roue_id":currentType!["type_roue_id"] as! String], datas: imgArr, paramName: "img[]", url: "Public/release_add") { (dic) in
                                print(dic)
                                if (dic as! NSDictionary)["code"] as! String == "200" {
                                    SVProgressHUD.showSuccess(withStatus: "发布成功")
                                    
                                    // clean all info
                                    self.textView.text = ""
                                    self.imgArr = [UIImage]()
                                    self.typeLabel.text = ""
                                    self.currentType = nil
                                    self.tableView.reloadData()
                                    self.collectionView.reloadData()
                                }else {
                                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
                                }
        }
    }
    
}
