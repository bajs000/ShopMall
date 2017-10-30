//
//  MineCommentViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/24.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage
import MJRefresh

class MineCommentViewController: UITableViewController {

    var dataSource = NSArray()
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            [unowned self] in
            self.page = 1
            self.requestComment()
        })
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            [unowned self] in
            self.page = self.page + 1
            self.requestComment()
        })
        requestComment()
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
        (cell.viewWithTag(3) as! UILabel).text = "评论了这篇内容"
        (cell.viewWithTag(4) as! UILabel).text = dic["time"] as? String
        (cell.viewWithTag(5) as! UILabel).text = dic["content"] as? String
        (cell.viewWithTag(6) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + ((dic["release"] as! NSDictionary)["img"] as! String)), completed: nil)
        cell.viewWithTag(6)?.layer.borderColor = #colorLiteral(red: 0.8797392845, green: 0.8797599673, blue: 0.8797488809, alpha: 1)
        cell.viewWithTag(6)?.layer.borderWidth = 1
        (cell.viewWithTag(7) as! UILabel).text = (dic["release"] as! NSDictionary)["describe"] as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
    
    override func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "删除"
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let dic = self.dataSource[indexPath.row] as! NSDictionary
        SVProgressHUD.show()
        Network.request(["ping_id":dic["ping_id"] as! String], url: "Public/ping_del") { (dic) in
            print(dic)
            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.dismiss()
                let tempArr = NSMutableArray(array: self.dataSource)
                tempArr.removeObject(at: indexPath.row)
                self.dataSource = tempArr
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }else {
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: GoodsDetailViewController.self) {
            let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender as! UIButton)
            let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
            let dic = dataSource[indexPath!.row] as! NSDictionary
            (segue.destination as! GoodsDetailViewController).detailInfo = dic
        }else if segue.destination.isKind(of: CommentViewController.self) {
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
            let dic = dataSource[indexPath!.row] as! NSDictionary
            (segue.destination as! CommentViewController).dataSource = ["list":dic]
        }
    }
    
    func requestComment() -> Void {
        SVProgressHUD.show()
        Network.request(["user_id":UserModel.share.userId,"page":String(self.page)], url: "Public/ping_list") { (dic) in
            print(dic)
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.dismiss()
                if self.page == 1 {
                    self.dataSource = (dic as! NSDictionary)["list"] as! NSArray
                }else {
                    let arr = NSMutableArray(array: self.dataSource)
                    arr.addObjects(from: (dic as! NSDictionary)["list"] as! [Any])
                    self.dataSource = arr
                }
                self.tableView.reloadData()
            }else {
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }

}
