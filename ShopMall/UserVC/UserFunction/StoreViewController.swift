//
//  StoreViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/24.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class StoreViewController: UITableViewController {

    var dataSource = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestStore()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dic = self.dataSource[indexPath.row] as! NSDictionary
        (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["img"] as! String)), completed: nil)
        (cell.viewWithTag(2) as! UILabel).text = dic["describe"] as? String
        (cell.viewWithTag(3) as! UILabel).text = dic[""] as? String
        (cell.viewWithTag(4) as! UILabel).text = dic["time"] as? String
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: GoodsDetailViewController.self) {
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            let dic = dataSource[indexPath!.row] as! NSDictionary
            (segue.destination as! GoodsDetailViewController).detailInfo = dic
        }
    }
    
    func requestStore() {
        SVProgressHUD.show()
        Network.request(["user_id":UserModel.share.userId], url: "Public/shoucang_list") { (dic) in
            print(dic)
            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.dismiss()
                self.dataSource = (dic as! NSDictionary)["list"] as! NSArray
                self.tableView.reloadData()
            }else {
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }

}
