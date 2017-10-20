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
    var typeBtns = [UIButton]()
    var type1 = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Helpers.barInit(self.tabBarController!)
        self.tableView.contentInset = UIEdgeInsetsMake(44, 0, 0, 0)
        self.tabBarController!.view.addSubview(functionView)
        functionView.frame = CGRect(x: 0, y: 64, width: Helpers.screanSize().width, height: 44)
        self.tableView.tableHeaderView = headerView
        self.tabBarController?.delegate = self
        requestMain(nil,type2: nil)
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
        if currentSupplyBtn?.tag == 3  || currentSupplyBtn?.tag == 4 {
            return 1
        }
        return (self.dataSource!["list"] as! NSArray).count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if currentSupplyBtn?.tag == 3  || currentSupplyBtn?.tag == 4 {
            return (self.dataSource!["list"] as! NSArray).count
        }
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if currentSupplyBtn?.tag == 3  || currentSupplyBtn?.tag == 4 {
            return 0
        }
        return 10
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
        return v
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = "Cell"
        if currentSupplyBtn?.tag == 3 || currentSupplyBtn?.tag == 4{
            cellIdentify = "supplyCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        if currentSupplyBtn?.tag == 3  || currentSupplyBtn?.tag == 4{
            let dic = (self.dataSource!["list"] as! NSArray)[indexPath.row] as! NSDictionary
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["face"] as! String)), completed: nil)
            (cell.viewWithTag(2) as! UILabel).text = dic["name"] as? String
            (cell.viewWithTag(3) as! UILabel).text = dic["jianjie"] as? String
            return cell
        }
        let dic = (self.dataSource!["list"] as! NSArray)[indexPath.section] as! NSDictionary
        (cell as! MainCell).imgArr = dic["release_img"] as? NSArray
        cell.viewWithTag(1)?.layer.cornerRadius = 15
        (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["img"] as! String)), completed: nil)
        (cell.viewWithTag(2) as! UILabel).text = dic[""] as? String
        (cell.viewWithTag(3) as! UILabel).text = Helpers.updateTimeForRow(dic["time"] as! String)
        if (dic["gongqiu"] as! String) == "2" {
            (cell.viewWithTag(4) as! UIImageView).image = #imageLiteral(resourceName: "main-seek")
        }else {
            (cell.viewWithTag(4) as! UIImageView).image = #imageLiteral(resourceName: "main-offer")
        }
        (cell.viewWithTag(5) as! UILabel).text = dic["describe"] as? String
        (cell.viewWithTag(6) as! UILabel).text = dic["address"] as? String
        (cell.viewWithTag(7) as! UIButton).setTitle(dic["ping_num"] as? String, for: .normal)
        if (dic["shoucang_state"] as! NSNumber).stringValue == "1" {
            (cell.viewWithTag(8) as! UIButton).setTitleColor(#colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1), for: .normal)
            (cell.viewWithTag(8) as! UIButton).setImage(#imageLiteral(resourceName: "main-like-not"), for: .normal)
        }else {
            (cell.viewWithTag(8) as! UIButton).setTitleColor(#colorLiteral(red: 0.7095867991, green: 0.7096036673, blue: 0.709594667, alpha: 1), for: .normal)
            (cell.viewWithTag(8) as! UIButton).setImage(#imageLiteral(resourceName: "main-like"), for: .normal)
        }
        (cell.viewWithTag(8) as! UIButton).setTitle(dic["shoucang_num"] as? String, for: .normal)
        if (dic["zan_state"] as! NSNumber).stringValue == "1" {
            (cell.viewWithTag(9) as! UIButton).setTitleColor(#colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1), for: .normal)
            (cell.viewWithTag(9) as! UIButton).setImage(#imageLiteral(resourceName: "main-praise"), for: .normal)
        }else {
            (cell.viewWithTag(9) as! UIButton).setTitleColor(#colorLiteral(red: 0.7095867991, green: 0.7096036673, blue: 0.709594667, alpha: 1), for: .normal)
            (cell.viewWithTag(9) as! UIButton).setImage(#imageLiteral(resourceName: "main-praise-not"), for: .normal)
        }
        (cell.viewWithTag(9) as! UIButton).setTitle(dic["zan_num"] as? String, for: .normal)
        
        (cell.viewWithTag(7) as! UIButton).addTarget(self, action: #selector(goodsAction(_:)), for: .touchUpInside)
        (cell.viewWithTag(8) as! UIButton).addTarget(self, action: #selector(goodsAction(_:)), for: .touchUpInside)
        (cell.viewWithTag(9) as! UIButton).addTarget(self, action: #selector(goodsAction(_:)), for: .touchUpInside)
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
        if segue.destination.isKind(of: TypeViewController.self) {
            let type = segue.destination as! TypeViewController
            type.pushByMain = true
            type.completeType = {(dic) in
                self.requestMain(dic["type_id"] as? String,type2: nil)
                self.type1 = dic["type_id"] as! String
            }
        }else if segue.destination.isKind(of: GoodsDetailViewController.self) {
            if (sender as! NSObject).isKind(of: UITableViewCell.self){
                let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)
                (segue.destination as! GoodsDetailViewController).detailInfo = (self.dataSource!["list"] as! NSArray)[indexPath!.section] as! NSDictionary
            }else{
                let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: ((sender as! UITapGestureRecognizer).view as! UICollectionView))
                let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
                (segue.destination as! GoodsDetailViewController).detailInfo = (self.dataSource!["list"] as! NSArray)[indexPath!.section] as! NSDictionary
            }
        }else if segue.destination.isKind(of: CommentViewController.self){
            let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender as! UIButton)
            let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
            (segue.destination as! CommentViewController).dataSource = ["list":(self.dataSource!["list"] as! NSArray)[indexPath!.section] as! NSDictionary]
        }
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
        if currentTypeBtn != nil {
            self.requestMain(self.type1, type2: ((self.dataSource!["type"] as! NSArray)[currentTypeBtn!.tag - 1] as! NSDictionary)["type_id"] as? String)
        }else {
            self.requestMain(self.type1, type2: nil)
        }
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
            self.requestMain(self.type1, type2: ((self.dataSource!["type"] as! NSArray)[currentTypeBtn!.tag - 1] as! NSDictionary)["type_id"] as? String)
        }else {
            self.requestMain(self.type1, type2: nil)
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
    
    @objc func goodsAction(_ sender: UIButton) {
        if sender.tag == 7 {//评价
            self.performSegue(withIdentifier: "commentPush", sender: sender)
        }else if sender.tag == 8 {//收藏
            let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender)
            let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
            let dict = (self.dataSource!["list"] as! NSArray)[indexPath!.section] as! NSDictionary
            SVProgressHUD.show()
            var url = "Public/shoucang_add"
            if (dict["shoucang_state"] as! NSNumber).intValue == 1{
                url = "Public/shoucang_del"
            }
            Network.request(["user_id":UserModel.share.userId,"release_id":dict["release_id"] as! String], url: url, complete: { (dic) in
                print(dic)
                if (dic as! NSDictionary)["code"] as! String == "200" {
                    if (dict["shoucang_state"] as! NSNumber).intValue == 1 {
                        SVProgressHUD.showSuccess(withStatus: "收藏成功")
                    }else {
                        SVProgressHUD.showSuccess(withStatus: "删除收藏成功")
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        if self.currentTypeBtn != nil {
                            self.requestMain(self.type1, type2: ((self.dataSource!["type"] as! NSArray)[self.currentTypeBtn!.tag - 1] as! NSDictionary)["type_id"] as? String)
                        }else {
                            self.requestMain(self.type1, type2: nil)
                        }
                    })
                }else {
                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
                }
            })
        }else {// 点赞
            let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender)
            let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
            let dict = (self.dataSource!["list"] as! NSArray)[indexPath!.section] as! NSDictionary
            SVProgressHUD.show()
            var url = "Public/zan_add"
            if (dict["zan_state"] as! NSNumber).intValue == 1{
                url = "Public/zan_del"
            }
            Network.request(["user_id":UserModel.share.userId,"release_id":dict["release_id"] as! String], url: url, complete: { (dic) in
                print(dic)
                if (dic as! NSDictionary)["code"] as! String == "200" {
                    if (dict["zan_state"] as! NSNumber).intValue == 1 {
                        SVProgressHUD.showSuccess(withStatus: "点赞成功")
                    }else {
                        SVProgressHUD.showSuccess(withStatus: "删除点赞成功")
                    }
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                        if self.currentTypeBtn != nil {
                            self.requestMain(self.type1, type2: ((self.dataSource!["type"] as! NSArray)[self.currentTypeBtn!.tag - 1] as! NSDictionary)["type_id"] as? String)
                        }else {
                            self.requestMain(self.type1, type2: nil)
                        }
                    })
                }else {
                    SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
                }
            })
        }
    }
    
    func requestMain(_ sender: String?, type2: String?) {
        SVProgressHUD.show()
        var param = ["type_id":"1","page":"1"]
        if sender != nil {
            param["type_id"] = sender!
        }
        if type2 != nil {
            param["type_two_id"] = type2!
        }
        if UserModel.share.userId.characters.count > 0 {
            param["user_id"] = UserModel.share.userId
        }
        var url = "Public"
        if currentSupplyBtn != nil {
            if currentSupplyBtn?.tag == 1 {
                param["gq_type"] = "1"
            }else if currentSupplyBtn?.tag == 2 {
                param["gq_type"] = "2"
            }else if currentSupplyBtn?.tag == 3 {
                url = "Public/index_user"
                param["gq_type"] = "1"
            }else if currentSupplyBtn?.tag == 4 {
                url = "Public/index_user"
                param["gq_type"] = "2"
            }
        }
        Network.request(param as NSDictionary, url: url) { (dic) in
            print(dic)
            SVProgressHUD.dismiss()
            self.dataSource = dic as? NSDictionary
            if self.currentSupplyBtn?.tag == 3 || self.currentSupplyBtn?.tag == 4 {
                self.tableView.tableHeaderView = nil
            }else{
                self.tableView.tableHeaderView = self.headerView
            }
            self.tableView.reloadData()
            self.collectionView.reloadData()
            
            var totalWidth:CGFloat = 15
            var totalHeight:CGFloat = 15
            for btn in self.typeBtns {
                btn.removeFromSuperview()
            }
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
                    if self.currentTypeBtn != nil && self.currentTypeBtn?.tag == button.tag {
                        button.backgroundColor = #colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1)
                        button.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
                        self.currentTypeBtn = button
                    }
                    button.addTarget(self, action: #selector(self.typeAction), for: .touchUpInside)
                    self.menuView.viewWithTag(2)?.addSubview(button)
                    
                    if totalWidth + width + 3 > Helpers.screanSize().width - 30 {
                        totalHeight = totalHeight + 29 + 15
                        totalWidth = 15
                    }
                    self.typeBtns.append(button)
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
