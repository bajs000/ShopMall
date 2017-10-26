//
//  AttentionViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/24.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class AttentionViewController: UITableViewController {

    var dataSource = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestAttention()
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
        cell.viewWithTag(4)?.layer.borderWidth = 1
        cell.viewWithTag(4)?.layer.borderColor = #colorLiteral(red: 0.7095867991, green: 0.7096036673, blue: 0.709594667, alpha: 1)
        (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["face"] as! String)), completed: nil)
        (cell.viewWithTag(2) as! UILabel).text = dic["name"] as? String
//        let time = dic["time"] as! String
        (cell.viewWithTag(3) as! UILabel).text = dic["jianjie"] as? String//String(time[..<time.index(time.startIndex, offsetBy: 10)])
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: BusinessViewController.self) {
            let cell = sender as! UITableViewCell
            let indexPath = self.tableView.indexPath(for: cell)
            (segue.destination as! BusinessViewController).businessInfo = self.dataSource[indexPath!.row] as? NSDictionary
        }
    }
    
    func requestAttention() {
        SVProgressHUD.show()
        Network.request(["user_id":UserModel.share.userId], url: "Public/guanzhu_list") { (dic) in
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
