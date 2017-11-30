//
//  PublishViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/19.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import CoreLocation

class PublishViewController: UITableViewController, UITextViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var footerView: UIView!
    @IBOutlet weak var surePublishBtn: UIButton!
    
    var manager:CLLocationManager?
    var userLocation: CLLocationCoordinate2D?
    var lock = NSLock()
    
    var placeholader: UILabel!
    var textView: UITextView!
    var collectionView: UICollectionView!
    var collectionViewHeight: NSLayoutConstraint!
    var locationText: UITextView!
    var typeLabel: UILabel!
    var segument: UISegmentedControl!
    var labelTextField: UITextField!
    
    let imagePicker = UIImagePickerController()
    var imgArr = [UIImage]()
    var currentType: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imagePicker.delegate = self
        self.surePublishBtn.layer.cornerRadius = 8
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if CLLocationManager.locationServicesEnabled() {
            manager = CLLocationManager()
            manager?.delegate = self
            manager?.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            manager?.distanceFilter = 200
            manager?.requestWhenInUseAuthorization()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        userLocation = nil
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - CoreLocationDelegate
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if (status == CLAuthorizationStatus.authorizedWhenInUse) {
            manager.startUpdatingLocation()
        }else {
            SVProgressHUD.showError(withStatus: "请到设置里面打开定位，我们才能给你提供更好的服务")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        lock.lock()
        if userLocation == nil {
            let location = locations.last
            userLocation = location?.coordinate
            requestUserLocation()
            print("latitude:\(String((location?.coordinate.latitude)!)),longitude:\(String((location?.coordinate.longitude)!))")
        }
        lock.unlock()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
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
        }else if indexPath.row == 5 {
            cellIdentify = "labelCell"
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
        }else if indexPath.row == 4 {
            segument = cell.viewWithTag(9) as! UISegmentedControl
        }else if indexPath.row == 5 {
            labelTextField = cell.viewWithTag(1) as! UITextField
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
        if labelTextField.text?.characters.count == 0 {
            SVProgressHUD.showError(withStatus: "请输入标签")
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
                               "label":labelTextField.text!,
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
    
    func requestUserLocation() -> Void {
        SVProgressHUD.show()
        Network.requestLocation(url: "http://restapi.amap.com/v3/geocode/regeo?key=6632969fe0929070d2cd5c2a50f27ca9&location=" + String(userLocation!.longitude) + "," + String(userLocation!.latitude)) { (dic) in
            if Int((dic as! NSDictionary)["status"] as! String) == 1 {
                self.locationText?.text = ((dic as! NSDictionary)["regeocode"] as! NSDictionary)["formatted_address"] as? String
                SVProgressHUD.dismiss()
            }else {
                SVProgressHUD.showError(withStatus: "定位错误")
            }

        }
    }
    
}
