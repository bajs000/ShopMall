//
//  PlaceViewController.swift
//  ShopMall
//
//  Created by 果儿 on 2017/10/25.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class PlaceViewController: UITableViewController {

    var dataSource = NSArray()
    var province: NSDictionary?
    var city: NSDictionary?
    var count = 0
    var completeChose: ((String,NSDictionary) -> Void)!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        requestPlace("0")
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
        let dic = self.dataSource[indexPath.row] as! NSDictionary
        cell.textLabel?.text = dic["name"] as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dic = self.dataSource[indexPath.row] as! NSDictionary
        if count == 0 {
            self.requestPlace(dic["id"] as! String)
            province = dic
            count = count + 1
        }else if count == 1 {
            self.requestPlace(dic["id"] as! String)
            city = dic
            count = count + 1
        }else {
            completeChose(province!["name"] as! String + (city!["name"] as! String) + (dic["name"] as! String),["province":province!,"city":city!,"district":dic])
            self.navigationController?.popViewController(animated: true)
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    func requestPlace(_ pid: String) -> Void {
        SVProgressHUD.show()
        Network.request(["pid":pid], url: "Public/addrelist") { (dic) in
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
