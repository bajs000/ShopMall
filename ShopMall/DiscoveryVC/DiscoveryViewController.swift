//
//  DiscoveryViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/17.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import Masonry
import SVProgressHUD
import SDWebImage
import MJRefresh
import MBProgressHUD

enum DiscoveryType {
    case vender     //商家
    case product    //产品
    case customer   //客户
}

class DiscoveryViewController: UITableViewController {

    @IBOutlet var headerView: DiscoveryHeaderView!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var type: DiscoveryType = .product
    var dataSource: NSDictionary?
    var type1 = "1"
    var type2: String?
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableHeaderView = headerView
        headerView.completeChose = {(dic) in
            self.page = 1
            self.type2 = dic["type_id"] as? String
            self.requestDiscovery(self.type1, type2: dic["type_id"] as? String)
        }
        requestDiscovery(self.type1,type2: nil)
        
        self.tableView.mj_header = MJRefreshNormalHeader(refreshingBlock: {
            [unowned self] in
            self.page = 1
            self.requestDiscovery(self.type1,type2: nil)
        })
        
        self.tableView.mj_footer = MJRefreshBackNormalFooter(refreshingBlock: {
            self.page = self.page + 1
            self.requestDiscovery(self.type1,type2: self.type2)
        })
        setupTitleView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func setupTitleView() -> Void {
        let discoveryTitleView = CutomTitleView(frame: CGRect(x: 0, y: 0, width: 75 * 3, height: 44))
        self.navigationItem.titleView = discoveryTitleView
        
        let venderBtn = UIButton(type: .custom)
        venderBtn.setTitle("产品", for: .normal)
        venderBtn.setTitleColor(#colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1), for: .selected)
        venderBtn.setTitleColor(#colorLiteral(red: 0.6509803922, green: 0.6509803922, blue: 0.6509803922, alpha: 1), for: .normal)
        venderBtn.isSelected = true
        venderBtn.tag = 1
        discoveryTitleView.addSubview(venderBtn)
        venderBtn.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(discoveryTitleView.mas_top)
            _ = make?.left.equalTo()(discoveryTitleView.mas_left)
            _ = make?.bottom.equalTo()(discoveryTitleView.mas_bottom)
            _ = make?.width.equalTo()(discoveryTitleView.mas_width)?.with().dividedBy()(3)
        }
        
        let productBtn = UIButton(type: .custom)
        productBtn.setTitle("商家", for: .normal)
        productBtn.setTitleColor(#colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1), for: .selected)
        productBtn.setTitleColor(#colorLiteral(red: 0.6509803922, green: 0.6509803922, blue: 0.6509803922, alpha: 1), for: .normal)
        productBtn.isSelected = false
        productBtn.tag = 3
        discoveryTitleView.addSubview(productBtn)
        productBtn.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(discoveryTitleView.mas_top)
            _ = make?.left.equalTo()(venderBtn.mas_right)
            _ = make?.bottom.equalTo()(discoveryTitleView.mas_bottom)
            _ = make?.width.equalTo()(discoveryTitleView.mas_width)?.with().dividedBy()(3)
        }
        
        let customerBtn = UIButton(type: .custom)
        customerBtn.setTitle("客户", for: .normal)
        customerBtn.setTitleColor(#colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1), for: .selected)
        customerBtn.setTitleColor(#colorLiteral(red: 0.6509803922, green: 0.6509803922, blue: 0.6509803922, alpha: 1), for: .normal)
        customerBtn.isSelected = false
        customerBtn.tag = 5
        discoveryTitleView.addSubview(customerBtn)
        customerBtn.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(discoveryTitleView.mas_top)
            _ = make?.right.equalTo()(discoveryTitleView.mas_right)
            _ = make?.bottom.equalTo()(discoveryTitleView.mas_bottom)
            _ = make?.width.equalTo()(discoveryTitleView.mas_width)?.with().dividedBy()(3)
        }
        
        let typeView = UIView()
        typeView.tag = 2
        typeView.backgroundColor = #colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1)
        discoveryTitleView.addSubview(typeView)
        typeView.mas_makeConstraints { (make) in
            _ = make?.bottom.equalTo()(discoveryTitleView.mas_bottom)?.with().offset()(-10)
            _ = make?.left.equalTo()(discoveryTitleView.mas_left)?.with().offset()(discoveryTitleView.frame.width / 6 - 20)
            _ = make?.width.equalTo()(40)
            _ = make?.height.equalTo()(1.5)
        }
        
        venderBtn.addTarget(self, action: #selector(discoveryTypeAction(_:)), for: .touchUpInside)
        productBtn.addTarget(self, action: #selector(discoveryTypeAction(_:)), for: .touchUpInside)
        customerBtn.addTarget(self, action: #selector(discoveryTypeAction(_:)), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.dataSource == nil {
            return 0
        }
        return (self.dataSource!["list"] as! NSArray).count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentify = "Cell"
        if type == .product {
            cellIdentify = "productCell"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentify, for: indexPath)
        cell.viewWithTag(4)?.layer.borderWidth = 1
        cell.viewWithTag(4)?.layer.borderColor = #colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1)
        let dic = (self.dataSource!["list"] as! NSArray)[indexPath.row] as! NSDictionary
        if type == .product {
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["img"] as! String)), completed: nil)
            (cell.viewWithTag(2) as! UILabel).text = dic["describe"] as? String
            let time = dic["time"] as! String
            (cell.viewWithTag(3) as! UILabel).text = String(time[..<time.index(time.startIndex, offsetBy: 10)])
            (cell.viewWithTag(4) as! UIButton).setTitle("联系", for: .normal)
        }else {
            cell.viewWithTag(1)?.layer.cornerRadius = 22
            if dic["face"] != nil && (dic["face"] as! NSObject).isKind(of: NSString.self)  && (dic["face"] as! String).count > 0 {
                (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["face"] as! String)), completed: nil)
            }
            (cell.viewWithTag(2) as! UILabel).text = dic["name"] as? String
            (cell.viewWithTag(3) as! UILabel).text = dic["jianjie"] as? String
            (cell.viewWithTag(4) as! UIButton).setTitle("关注", for: .normal)
        }
        (cell.viewWithTag(4) as! UIButton).addTarget(self, action: #selector(rightAction(_:)), for: .touchUpInside)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .product {
            self.performSegue(withIdentifier: "detailPush", sender: indexPath)
        }else {
            self.performSegue(withIdentifier: "businessPush", sender: indexPath)
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.isKind(of: UICollectionView.self) {
            self.pageControl.currentPage = Int(floor((scrollView.contentOffset.x - Helpers.screanSize().width / 2) / Helpers.screanSize().width) + 1)
        }
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: TypeViewController.self) {
            let type = segue.destination as! TypeViewController
            type.pushByMain = true
            type.completeType = {(dic) in
                self.page = 1
                self.requestDiscovery(dic["type_id"] as? String,type2: nil)
                self.type1 = dic["type_id"] as! String
                if self.type == .product {
//                    self.discoveryTypeAction(self.navigationItem.titleView!.viewWithTag(1) as! UIButton)
                    self.typeLabel.text = "产品·" + (dic["type_title"] as! String)
                }else if self.type == .vender {
//                    self.discoveryTypeAction(self.navigationItem.titleView!.viewWithTag(3) as! UIButton)
                    self.typeLabel.text = "商家·" + (dic["type_title"] as! String)
                }else {
//                    self.discoveryTypeAction(self.navigationItem.titleView!.viewWithTag(5) as! UIButton)
                    self.typeLabel.text = "客户·" + (dic["type_title"] as! String)
                }
            }
        }else if segue.destination.isKind(of: GoodsDetailViewController.self) {
            if (sender as! NSObject).isKind(of: NSIndexPath.self){
                let indexPath = sender as? IndexPath
                (segue.destination as! GoodsDetailViewController).detailInfo = (self.dataSource!["list"] as! NSArray)[indexPath!.row] as! NSDictionary
            }else{
                let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: ((sender as! UITapGestureRecognizer).view as! UICollectionView))
                let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
                (segue.destination as! GoodsDetailViewController).detailInfo = (self.dataSource!["list"] as! NSArray)[indexPath!.row] as! NSDictionary
            }
        }else if segue.destination.isKind(of: BusinessViewController.self) {
            let indexPath = sender as? IndexPath
            (segue.destination as! BusinessViewController).businessInfo = (self.dataSource!["list"] as! NSArray)[indexPath!.row] as? NSDictionary
        }
    }
    
    @objc func rightAction(_ sender: UIButton) {
        let cell = Helpers.findSuperViewClass(UITableViewCell.self, with: sender)
        let indexPath = self.tableView.indexPath(for: cell as! UITableViewCell)
        let dic = (self.dataSource!["list"] as! NSArray)[indexPath!.row] as! NSDictionary
        if type == .product {//联系
            if dic["phone"] != nil && (dic["phone"] as! NSObject).isKind(of: NSString.self){
                UIApplication.shared.openURL(URL(string:"tel://" + (dic["phone"] as! String))!)
            }else {
                SVProgressHUD.showError(withStatus: "系统错误，请联系管理员")
            }
        }else {//关注
            if UserModel.checkUserLogin(at: self) {
                SVProgressHUD.show()
                Network.request(["bus_id":dic["user_id"] as! String,"user_id":UserModel.share.userId], url: "Public/guanzhu_add", complete: { (dic) in
                    print(dic)
                    if (dic as! NSDictionary)["code"] as! String == "200" {
                        SVProgressHUD.showSuccess(withStatus: "关注成功")
                    }else {
                        SVProgressHUD.dismiss()
                        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                        hud.mode = .text
                        hud.label.text = (dic as! NSDictionary)["msg"] as? String
                        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2, execute: {
                            hud.hide(animated: true)
                        })
//                        SVProgressHUD.showError(withStatus: (dic as! NSDictionary)["msg"] as? String)
//                        SVProgressHUD.show(#imageLiteral(resourceName: "no_image"), status: (dic as! NSDictionary)["msg"] as? String)
                    }
                })
            }
        }
    }
    
    @objc func discoveryTypeAction(_ sender: UIButton) {
        sender.isSelected = true
        if sender.tag == 1 {
            type = .product
            (sender.superview?.viewWithTag(3) as! UIButton).isSelected = false
            (sender.superview?.viewWithTag(5) as! UIButton).isSelected = false
            typeLabel.text = "产品·自主品牌"
        }else if sender.tag == 3 {
            type = .vender
            (sender.superview?.viewWithTag(1) as! UIButton).isSelected = false
            (sender.superview?.viewWithTag(5) as! UIButton).isSelected = false
            typeLabel.text = "商家·自主品牌"
        }else {
            type = .customer
            (sender.superview?.viewWithTag(1) as! UIButton).isSelected = false
            (sender.superview?.viewWithTag(3) as! UIButton).isSelected = false
            typeLabel.text = "客户·自主品牌"
        }

        let typeView = sender.superview?.viewWithTag(2)
        typeView!.mas_remakeConstraints { (make) in
            _ = make?.bottom.equalTo()(sender.superview!.mas_bottom)?.with().offset()(-10)
            _ = make?.left.equalTo()(sender.superview!.mas_left)?.with().offset()(sender.superview!.frame.width / 6 * CGFloat(sender.tag) - 20)
            _ = make?.width.equalTo()(40)
            _ = make?.height.equalTo()(1.5)
        }
        
        UIView.animate(withDuration: 0.5) {
            sender.superview!.layoutIfNeeded()
        }
        self.type1 = "1"
        self.page = 1
        requestDiscovery(self.type1,type2: nil)
    }
    
    func requestDiscovery(_ sender: String?, type2: String?) -> Void {
        SVProgressHUD.show()
        var url = ""
        var param = [String:String]()
        if type == .vender {
            url = "Public/find_bus"
            if sender == nil {
                param = ["type_id":"1"]
            }else {
                param = ["type_id":sender!]
            }
        }else if type == .customer {
            url = "Public/find_bus"
            if sender == nil {
                param = ["type_id":"1"]
            }else {
                param = ["type_id":sender!]
            }
        }else {
            url = "Public/find_goods"
            if sender == nil {
                param = ["type_id":"1"]
            }else {
                param = ["type_id":sender!]
            }
            param["page"] = String(self.page)
        }
        if type2 != nil {
            param["type_two_id"] = type2!
        }
        Network.request(param as NSDictionary, url: url) { (dic) in
            SVProgressHUD.dismiss()
            self.tableView.mj_header.endRefreshing()
            self.tableView.mj_footer.endRefreshing()
            if self.type == .vender {
                self.dataSource = dic as? NSDictionary
            }else {
                if self.page == 1 {
                    self.dataSource = dic as? NSDictionary
                }else {
                    let arr = NSMutableArray(array: self.dataSource!["list"] as! NSArray)
                    arr.addObjects(from: (dic as! NSDictionary)["list"] as! [Any])
                    let tempDic = NSMutableDictionary(dictionary: self.dataSource!)
                    tempDic.setValue(arr, forKey: "list")
                    self.dataSource = tempDic
                }
            }
            
            self.headerView.dataSource = self.dataSource
            self.tableView.reloadData()
            let count = (self.dataSource?["type"] as! NSArray).count / 5
            if count > 0{
                self.tableView.tableHeaderView = nil
                self.tableView.beginUpdates()
                self.headerView.frame = CGRect(x: 0, y: 0, width: Int(Helpers.screanSize().width), height: 185 + count * 91)
                self.tableView.tableHeaderView = self.headerView
                self.tableView.endUpdates()
            }else if (self.dataSource?["type"] as! NSArray).count > 0 {
                self.tableView.tableHeaderView = nil
                self.tableView.beginUpdates()
                self.headerView.frame = CGRect(x: 0, y: 0, width: Int(Helpers.screanSize().width), height: 185 + 1 * 91)
                self.tableView.tableHeaderView = self.headerView
                self.tableView.endUpdates()
            }else {
                self.tableView.beginUpdates()
                self.headerView.frame = CGRect(x: 0, y: 0, width: Int(Helpers.screanSize().width), height: 185)
                self.tableView.endUpdates()
            }
            self.pageControl.numberOfPages = (self.dataSource!["img"] as! NSArray).count
            
        }
    }
    
}

class CutomTitleView: UIView {
    override var intrinsicContentSize: CGSize{
        return CGSize(width: 75 * 3, height: 44)
    }
}
