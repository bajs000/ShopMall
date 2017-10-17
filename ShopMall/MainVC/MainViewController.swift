//
//  MainViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/16.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import Masonry
import SVProgressHUD
import SDWebImage

class MainViewController: UITableViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UITabBarControllerDelegate {
    
    @IBOutlet var functionView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet var menuView: UIView!
    @IBOutlet weak var menuBtnBgHeight: NSLayoutConstraint!
    @IBOutlet weak var headerView: UIView!
    
    var dataSource: NSDictionary?
    var currentTypeBtn: UIButton?
    var currentSupplyBtn: UIButton?
    var bgHeight:CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
        self.tabBarController!.view.addSubview(functionView)
        functionView.frame = CGRect(x: 0, y: 64, width: Helpers.screanSize().width, height: 44)
        self.tableView.tableHeaderView = headerView
        self.tabBarController?.delegate = self
        requestMain()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        functionView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        functionView.isHidden = true
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.dataSource == nil {
            return 0
        }
        if currentSupplyBtn?.tag == 3 {
            return 1
        }
        return (self.dataSource!["list"] as! NSArray).count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentSupplyBtn?.tag == 3 {
            return 5
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        return v
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = "Cell"
        if currentSupplyBtn?.tag == 3 {
            cellIdentify = "supplyCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if currentSupplyBtn?.tag == 3 {
            
            return cell
        }
        let dic = (self.dataSource!["list"] as! NSArray)[indexPath.row] as! NSDictionary
        (cell as! MainCell).imgArr = dic["release_img"] as? NSArray
        cell.viewWithTag(1)?.layer.cornerRadius = 15
        (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["img"] as! String)), completed: nil)
        (cell.viewWithTag(2) as! UILabel).text = dic[""] as? String
        (cell.viewWithTag(3) as! UILabel).text = Helpers.updateTimeForRow(dic["time"] as! String)
        if (dic["gongqiu"] as! String) == "1" {
            (cell.viewWithTag(4) as! UIImageView).image = #imageLiteral(resourceName: "main-seek")
        }
        (cell.viewWithTag(5) as! UILabel).text = dic["describe"] as? String
        (cell.viewWithTag(6) as! UILabel).text = dic["address"] as? String
        (cell.viewWithTag(7) as! UIButton).setTitle(dic["ping_num"] as? String, for: .normal)
        if (dic["shoucang_state"] as! NSNumber).stringValue == "1" {
            (cell.viewWithTag(8) as! UIButton).setTitleColor(#colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1), for: .normal)
        }
        (cell.viewWithTag(8) as! UIButton).setTitle(dic["shoucang_num"] as? String, for: .normal)
        if (dic["shoucang_state"] as! NSNumber).stringValue == "1" {
            (cell.viewWithTag(9) as! UIButton).setTitleColor(#colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1), for: .normal)
        }
        (cell.viewWithTag(9) as! UIButton).setTitle(dic["zan_num"] as? String, for: .normal)
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.dataSource == nil {
            return 0
        }
        return (self.dataSource!["img"] as! NSArray).count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: Helpers.screanSize().width, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath)
        let dic = (self.dataSource!["img"] as! NSArray)[indexPath.row] as! NSDictionary
        (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["bigpic"] as! String)), completed: nil)
        return cell
    }
    
    // MARK: - UITabBarControllerDelegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let vc = (viewController as! UINavigationController).topViewController
        if (vc?.isKind(of: UserViewController.self))! {
            return UserModel.checkUserLogin(at: tabBarController)
        }
        return true
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }
    
    @IBAction func filterAction(_ sender: Any) {
        if menuView.superview == nil {
            self.tabBarController?.view.addSubview(menuView)
            menuView.frame = CGRect(x: 0, y: 64 + 44, width: Helpers.screanSize().width, height: Helpers.screanSize().height - 64 - 44)
            self.menuBtnBgHeight.constant = 0
            menuView.layoutIfNeeded()
            UIView.animate(withDuration: 0.5, animations: {
                self.menuView.viewWithTag(1)?.alpha = 0.8
                self.menuBtnBgHeight.constant = self.bgHeight
                self.menuView.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func supplyAndDemandAction(_ sender: UIButton) {
        if currentSupplyBtn == nil {
            currentSupplyBtn = sender
            sender.setTitleColor(#colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1), for: .normal)
        }else{
            if currentSupplyBtn == sender{
                sender.setTitleColor(#colorLiteral(red: 0.4078176022, green: 0.407827884, blue: 0.4078223705, alpha: 1), for: .normal)
                currentSupplyBtn = nil
            }else {
                currentSupplyBtn?.setTitleColor(#colorLiteral(red: 0.4078176022, green: 0.407827884, blue: 0.4078223705, alpha: 1), for: .normal)
                sender.setTitleColor(#colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1), for: .normal)
                currentSupplyBtn = sender
            }
        }
        if sender.tag == 3 {
            self.tableView.tableHeaderView = nil
        }else{
            self.tableView.tableHeaderView = headerView
        }
        self.tableView.reloadData()
    }
    
    @IBAction func sureTypeAction(_ sender: Any) {
        UIView.animate(withDuration: 0.5, animations: {
            self.menuBtnBgHeight.constant = 0
            self.menuView.viewWithTag(1)?.alpha = 0
            self.menuView.layoutIfNeeded()
        }) { (finish) in
            self.menuView.removeFromSuperview()
        }
        if (sender as! NSObject).isKind(of: UITapGestureRecognizer.self) {
            return
        }
        if currentTypeBtn != nil {
            print("tag:\(currentTypeBtn!.tag)")
        }
    }
    
    @objc func typeAction(_ sender: UIButton) {
        sender.backgroundColor = #colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1)
        sender.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        if currentTypeBtn == nil {
            currentTypeBtn = sender
        }else {
            currentTypeBtn?.setTitleColor(#colorLiteral(red: 0.4078176022, green: 0.407827884, blue: 0.4078223705, alpha: 1), for: .normal)
            currentTypeBtn?.backgroundColor = #colorLiteral(red: 0.8797392845, green: 0.8797599673, blue: 0.8797488809, alpha: 1)
            if currentTypeBtn == sender {
                currentTypeBtn = nil
            }else{
                currentTypeBtn = sender
            }
        }
    }
    
    func requestMain() {
        SVProgressHUD.show()
        Network.request(["type_id":"1","page":"1"], url: "Public") { (dic) in
            print(dic)
            SVProgressHUD.dismiss()
            self.dataSource = dic as? NSDictionary
            self.tableView.reloadData()
            self.collectionView.reloadData()
            
            var totalWidth:CGFloat = 15
            var totalHeight:CGFloat = 15
            if self.dataSource?["type"] != nil {
                for i in 0...(self.dataSource?["type"] as! NSArray).count - 1 {
                    let dict = (self.dataSource?["type"] as! NSArray)[i] as! NSDictionary
                    let title = dict["type_title"] as! String
                    let width = (title as NSString).boundingRect(with: CGSize(width: 200, height: 29), options: .usesLineFragmentOrigin, attributes: [NSAttributedStringKey.font:UIFont.systemFont(ofSize: 13)], context: nil).size.width + 10
                    let button = UIButton(type: .custom)
                    button.tag = i + 1
                    button.backgroundColor = #colorLiteral(red: 0.8797392845, green: 0.8797599673, blue: 0.8797488809, alpha: 1)
                    button.layer.cornerRadius = 4
                    button.clipsToBounds = true
                    button.setTitle(dict["type_title"] as? String, for: .normal)
                    button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                    button.setTitleColor(#colorLiteral(red: 0.4078176022, green: 0.407827884, blue: 0.4078223705, alpha: 1), for: .normal)
                    button.addTarget(self, action: #selector(self.typeAction), for: .touchUpInside)
                    self.menuView.viewWithTag(2)?.addSubview(button)
                    
                    if totalWidth + width + 3 > Helpers.screanSize().width - 30 {
                        totalHeight = totalHeight + 29 + 15
                        totalWidth = 15
                    }
                    
                    button.mas_makeConstraints({ (make) in
                        _ = make?.width.equalTo()(width)
                        _ = make?.height.equalTo()(29)
                        _ = make?.left.equalTo()(totalWidth)
                        _ = make?.top.equalTo()(totalHeight)
                    })
                    totalWidth = totalWidth + width + 3
                }
            }
            
            self.bgHeight  = totalHeight + 80 + 29
            self.menuView.viewWithTag(2)?.bringSubview(toFront: self.menuView.viewWithTag(3)!)
        }
    }

}
