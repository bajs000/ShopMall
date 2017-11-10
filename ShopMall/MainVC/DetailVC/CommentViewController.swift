//
//  CommentViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/20.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SDWebImage
import SVProgressHUD

class CommentViewController: UITableViewController {

    var dataSource: NSDictionary!
    var commentInfo: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestDetail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if commentInfo == nil {
            return 0
        }
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return (self.commentInfo!["ping"] as! NSArray).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = ""
        if indexPath.section == 0 {
            cellIdentify = "headerCell"
        }else {
            cellIdentify = "Cell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if indexPath.section == 0 {
            (cell as! MainCell).imgArr = (self.commentInfo!["list"] as! NSDictionary)["graphic"] as? NSArray
            let dic = self.commentInfo!["list"] as! NSDictionary
            cell.viewWithTag(1)?.layer.cornerRadius = 22
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["img"] as! String)), completed: nil)
            (cell.viewWithTag(2) as! UILabel).text = dic[""] as? String
            (cell.viewWithTag(3) as! UILabel).text = dic["describe"] as? String
            (cell.viewWithTag(5) as! UILabel).text = dic["time"] as? String
            (cell.viewWithTag(6) as! UILabel).text = dic["address"] as? String
        }else {
            let dic = (self.commentInfo!["ping"] as! NSArray)[indexPath.row] as! NSDictionary
            print(dic)
            cell.viewWithTag(1)?.layer.cornerRadius = 17
            if dic["face"] != nil && (dic["face"] as! NSObject).isKind(of: NSString.self) {
                (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["face"] as! String)), completed: nil)
            }
            (cell.viewWithTag(2) as! UILabel).text = dic["name"] as? String
            (cell.viewWithTag(3) as! UILabel).text = dic["time"] as? String
            (cell.viewWithTag(4) as! UILabel).text = dic["content"] as? String
        }
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func commentAction(_ sender: UIBarButtonItem) {
        let alert = (Bundle.main.loadNibNamed("SMAlertBottomView", owner: self, options: nil)![0]) as! SMAlertBottomView
        alert.placeholderStr = "请评论"
        alert.keyboardType = .default
        alert.completeEnter = {(str) in
            SVProgressHUD.show()
            Network.request(["user_id":UserModel.share.userId,"release_id":(self.dataSource["list"] as! NSDictionary)["release_id"] as! String,"content":str], url: "Public/ping_add", complete: { (dic) in
                print(dic)
                if (dic as! NSDictionary)["code"] as! String == "200" {
                    SVProgressHUD.showSuccess(withStatus: "评价成功")
                    self.requestDetail()
                }else {
                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
                }
            })
        }
        alert.showOnWindows()
    }
    
    func requestDetail() -> Void {
        SVProgressHUD.show()
        Network.request(["user_id":UserModel.share.userId,"release_id":(self.dataSource["list"] as! NSDictionary)["release_id"] as! String], url: "Public/release_details") { (dic) in
            print(dic)
            if (dic as! NSDictionary)["code"] as! String == "200" {
                SVProgressHUD.dismiss()
                self.commentInfo = dic as? NSDictionary
                self.tableView.reloadData()
            }else {
                SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
            }
        }
    }

}
