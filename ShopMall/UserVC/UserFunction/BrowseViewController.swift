//
//  BrowseViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/24.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class BrowseViewController: UITableViewController {

    var dataSource = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestBrowse()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dic = self.dataSource[indexPath.row] as! NSDictionary
        if dic["img"] != nil && (dic["img"] as! NSObject).isKind(of: NSString.self)  {
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["img"] as! String)), completed: nil)
        }
        (cell.viewWithTag(2) as! UILabel).text = dic["describe"] as? String
        (cell.viewWithTag(3) as! UILabel).text = dic[""] as? String
        (cell.viewWithTag(4) as! UILabel).text = dic["time"] as? String
        return cell
    }

    // MARK: - Navigation
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
        let dic = self.dataSource[indexPath!.row] as! NSDictionary
        if dic["release_id"] == nil {
            SVProgressHUD.showError(withStatus: "该信息有误，请联系管理员")
            return false
        }
        return true
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: GoodsDetailViewController.self) {
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            let dic = dataSource[indexPath!.row] as! NSDictionary
            (segue.destination as! GoodsDetailViewController).detailInfo = dic
        }
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        requestDelAllBrowse()
    }
    
    func requestBrowse() {
        SVProgressHUD.show()
        Network.request(["user_id":UserModel.share.userId], url: "Public/jilu_list") { (dic) in
            print(dic)
            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.dismiss()
                self.dataSource = (dic as! NSDictionary)["list"] as! NSArray
                self.tableView.reloadData()
            }else {
                self.dataSource = NSArray()
                self.tableView.reloadData()
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }
    
    func requestDelAllBrowse() {
        SVProgressHUD.show()
        Network.request(["user_id":UserModel.share.userId], url: "Public/jilu_del") { (dic) in
            print(dic)
            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.dismiss()
                self.requestBrowse()
            }else {
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }

}
