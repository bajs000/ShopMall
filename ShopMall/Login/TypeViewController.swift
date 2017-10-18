//
//  TypeViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/18.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class TypeViewController: UICollectionViewController {
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    var type1Arr = NSArray()
    var type2Arr = NSArray()
    
    var completeType: ((NSDictionary) -> Void)?
    var choseCount = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "筛选"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor:#colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1)]
        let width = (Helpers.screanSize().width - 15) / 2
        let height = width * 200 / 360
        self.flowLayout.itemSize = CGSize(width: width, height: height)
        requestType(nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - UICollectionViewDelegate
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if choseCount == 0 {
            return type1Arr.count
        }else {
            return type2Arr.count
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        if  choseCount == 0 {
            let dic = type1Arr[indexPath.row] as! NSDictionary
            (cell.viewWithTag(1) as! UIImageView).contentMode = .scaleToFill
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["type_app_img"] as! String)), completed: nil)
        }else {
            let dic = type2Arr[indexPath.row] as! NSDictionary
            (cell.viewWithTag(1) as! UIImageView).contentMode = .center
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["type_app_img"] as! String)), completed: nil)
        }

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if choseCount == 0 {
            let dic = type1Arr[indexPath.row] as! NSDictionary
            requestType(dic["type_id"] as? String)
            choseCount = 1
        }else {
            if completeType != nil {
                let dic = type2Arr[indexPath.row] as! NSDictionary
                completeType!(dic)
            }
            _ = self.navigationController?.popViewController(animated: true)
        }

    }
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if  tableView == type1Table {
//            return type1Arr.count
//        }else {
//            return type2Arr.count
//        }
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "normalCell", for: indexPath)
//        if  tableView == type1Table {
//            let dic = type1Arr[indexPath.row] as! NSDictionary
//            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["type_app_img"] as! String)), completed: nil)
//            (cell.viewWithTag(2) as! UITextField).text = dic["type_title"] as? String
//        }else {
//            let dic = type2Arr[indexPath.row] as! NSDictionary
//            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["type_app_img"] as! String)), completed: nil)
//            (cell.viewWithTag(2) as! UITextField).text = dic["type_title"] as? String
//        }
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if  tableView == type1Table {
//            let dic = type1Arr[indexPath.row] as! NSDictionary
//            requestType(dic["type_id"] as? String)
//        }else {
//            if completeType != nil {
//                let dic = type2Arr[indexPath.row] as! NSDictionary
//                completeType!(dic)
//            }
//            _ = self.navigationController?.popViewController(animated: true)
//        }
//    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func requestType(_ sender: String?) -> Void {
        SVProgressHUD.show()
        var param = [String:String]()
        if sender != nil {
            param["type_id"] = sender
        }
        Network.request(param as NSDictionary, url: "Public/type_list") { (dic) in
            print(dic)
            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.dismiss()
                if sender == nil {
                    self.type1Arr = (dic as! NSDictionary)["list"] as! NSArray
                }else {
                    self.type2Arr = (dic as! NSDictionary)["list"] as! NSArray
                }
                self.collectionView?.reloadData()
            }else {
                if sender == nil {
                    self.type1Arr = NSArray()
                }else{
                    self.type2Arr = NSArray()
                }
                self.collectionView?.reloadData()
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }

}
