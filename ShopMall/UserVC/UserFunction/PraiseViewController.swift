//
//  PraiseViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/24.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class PraiseViewController: UITableViewController {

    var dataSource = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPraise()
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
        let dic = dataSource[indexPath.row] as! NSDictionary
        cell.viewWithTag(1)?.layer.cornerRadius = 22
        (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + UserModel.share.face), completed: nil)
        (cell.viewWithTag(2) as! UILabel).text = "我"
        (cell.viewWithTag(3) as! UILabel).text = "赞了这篇内容"
        (cell.viewWithTag(4) as! UILabel).text = dic["time"] as? String
        (cell.viewWithTag(5) as! UILabel).text = ""
        (cell.viewWithTag(6) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["img"] as! String)), completed: nil)
        cell.viewWithTag(6)?.layer.borderColor = #colorLiteral(red: 0.8797392845, green: 0.8797599673, blue: 0.8797488809, alpha: 1)
        cell.viewWithTag(6)?.layer.borderWidth = 1
        (cell.viewWithTag(7) as! UILabel).text = dic["describe"] as? String
        return cell
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: GoodsDetailViewController.self) {
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            let dic = dataSource[indexPath!.row] as! NSDictionary
            (segue.destination as! GoodsDetailViewController).detailInfo = dic
        }else if segue.destination.isKind(of: CommentViewController.self) {
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            let dic = dataSource[indexPath!.row] as! NSDictionary
            (segue.destination as! CommentViewController).dataSource = ["list":dic]
        }
    }
    
    func requestPraise() {
        SVProgressHUD.show()
        Network.request(["user_id":UserModel.share.userId], url: "Public/wo_zan_list") { (dic) in
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
