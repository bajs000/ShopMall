//
//  MsgViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/25.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit

class MsgViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
        if segue.destination.isKind(of: MsgDetailViewController.self) {
            if indexPath?.row == 0 {
                (segue.destination as! MsgDetailViewController).type = .comment
            }else {
                (segue.destination as! MsgDetailViewController).type = .praise
            }
        }
    }

}
