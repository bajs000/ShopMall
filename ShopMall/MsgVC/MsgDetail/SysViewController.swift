//
//  SysViewController.swift
//  ShopMall
//
//  Created by 果儿 on 2017/11/30.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD

class SysViewController: UITableViewController {

    var dataSource = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
        requestSysMsg()
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
        cell.textLabel?.text = dic["content"] as? String
        return cell
    }
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
        let dic = dataSource[indexPath!.row] as! NSDictionary
        (segue.destination as! SysDetailViewController).sysInfo = dic
    }

    func requestSysMsg() -> Void {
        SVProgressHUD.show()
        var url = ""
        url = "Public/user_news"
        Network.request(["user_id":UserModel.share.userId], url: url) { (dic) in
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
