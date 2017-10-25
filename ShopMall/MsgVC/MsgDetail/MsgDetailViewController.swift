//
//  MsgDetailViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/25.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

enum MsgType {
    case comment
    case praise
}

class MsgDetailViewController: UITableViewController {

    var type: MsgType = .comment
    var dataSource = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestMsgDetail()
        if type == .comment {
            self.title = "收到的评论"
        }else {
            self.title = "收到的赞"
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
        cell.viewWithTag(5)?.layer.borderColor = #colorLiteral(red: 0.8797392845, green: 0.8797599673, blue: 0.8797488809, alpha: 1)
        cell.viewWithTag(5)?.layer.borderWidth = 1
        if type == .comment {
//            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + ((dic["user"] as! NSDictionary)["face"] as! String)), completed: nil)
//            (cell.viewWithTag(2) as! UILabel).text = (dic["user"] as! NSDictionary)["name"] as? String
            cell.viewWithTag(6)?.isHidden = true
            (cell.viewWithTag(3) as! UILabel).text = dic["content"] as? String
            (cell.viewWithTag(4) as! UILabel).text = dic["time"] as? String
            (cell.viewWithTag(5) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + ((dic["release"] as! NSDictionary)["img"] as! String)), completed: nil)
        }else {
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + ((dic["user"] as! NSDictionary)["face"] as! String)), completed: nil)
            (cell.viewWithTag(2) as! UILabel).text = (dic["user"] as! NSDictionary)["name"] as? String
            cell.viewWithTag(6)?.isHidden = false
            (cell.viewWithTag(3) as! UILabel).text = ""
            (cell.viewWithTag(4) as! UILabel).text = (dic["user"] as! NSDictionary)["time"] as? String
            (cell.viewWithTag(5) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + ((dic["release"] as! NSDictionary)["img"] as! String)), completed: nil)
        }
        return cell
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func cleanAction(_ sender: Any) {
        SVProgressHUD.show()
        var url = ""
        if type == .comment {
            url = "Public/ping_qingkong"
        }else {
            url = "Public/zan_qingkong"
        }
        Network.request(["user_id":UserModel.share.userId], url: url) { (dic) in
            print(dic)
            if (dic as! NSDictionary)["code"] as! String == "200" {
                self.requestMsgDetail()
            }else {
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }
    
    func requestMsgDetail() -> Void {
        SVProgressHUD.show()
        var url = ""
        if type == .comment {
            url = "Public/ping_shou_list"
        }else {
            url = "Public/zan_shou_list"
        }
        Network.request(["user_id":"1"], url: url) { (dic) in
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
