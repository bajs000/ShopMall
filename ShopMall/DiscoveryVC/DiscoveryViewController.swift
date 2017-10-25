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

enum DiscoveryType {
    case vender
    case product
}

class DiscoveryViewController: UITableViewController {

    @IBOutlet var headerView: DiscoveryHeaderView!
    @IBOutlet weak var typeLabel: UILabel!
    
    var type: DiscoveryType = .vender
    var dataSource: NSDictionary?
    var type1 = "1"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableHeaderView = headerView
        headerView.completeChose = {(dic) in
            self.requestDiscovery(self.type1, type2: dic["type_id"] as? String)
        }
        requestDiscovery(self.type1,type2: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupTitleView()
    }
    
    func setupTitleView() -> Void {
        let discoveryTitleView = CutomTitleView(frame: CGRect(x: 0, y: 0, width: 150, height: 44))
        self.navigationItem.titleView = discoveryTitleView
        
        let venderBtn = UIButton(type: .custom)
        venderBtn.setTitle("厂家", for: .normal)
        venderBtn.setTitleColor(#colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1), for: .selected)
        venderBtn.setTitleColor(#colorLiteral(red: 0.6509803922, green: 0.6509803922, blue: 0.6509803922, alpha: 1), for: .normal)
        venderBtn.isSelected = true
        venderBtn.tag = 1
        discoveryTitleView.addSubview(venderBtn)
        venderBtn.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(discoveryTitleView.mas_top)
            _ = make?.left.equalTo()(discoveryTitleView.mas_left)
            _ = make?.bottom.equalTo()(discoveryTitleView.mas_bottom)
            _ = make?.width.equalTo()(discoveryTitleView.mas_width)?.with().dividedBy()(2)
        }
        
        let productBtn = UIButton(type: .custom)
        productBtn.setTitle("产品", for: .normal)
        productBtn.setTitleColor(#colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1), for: .selected)
        productBtn.setTitleColor(#colorLiteral(red: 0.6509803922, green: 0.6509803922, blue: 0.6509803922, alpha: 1), for: .normal)
        productBtn.isSelected = false
        productBtn.tag = 3
        discoveryTitleView.addSubview(productBtn)
        productBtn.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(discoveryTitleView.mas_top)
            _ = make?.right.equalTo()(discoveryTitleView.mas_right)
            _ = make?.bottom.equalTo()(discoveryTitleView.mas_bottom)
            _ = make?.width.equalTo()(discoveryTitleView.mas_width)?.with().dividedBy()(2)
        }
        
        let typeView = UIView()
        typeView.tag = 2
        typeView.backgroundColor = #colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1)
        discoveryTitleView.addSubview(typeView)
        typeView.mas_makeConstraints { (make) in
            _ = make?.bottom.equalTo()(discoveryTitleView.mas_bottom)?.with().offset()(-10)
            _ = make?.left.equalTo()(discoveryTitleView.mas_left)?.with().offset()(discoveryTitleView.frame.width / 4 - 20)
            _ = make?.width.equalTo()(40)
            _ = make?.height.equalTo()(1.5)
        }
        
        venderBtn.addTarget(self, action: #selector(discoveryTypeAction(_:)), for: .touchUpInside)
        productBtn.addTarget(self, action: #selector(discoveryTypeAction(_:)), for: .touchUpInside)
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
        }else{
            cell.viewWithTag(1)?.layer.cornerRadius = 22
            (cell.viewWithTag(1) as! UIImageView).sd_setImage(with: URL(string: Helpers.baseImgUrl() + (dic["face"] as! String)), completed: nil)
            (cell.viewWithTag(2) as! UILabel).text = dic["name"] as? String
            (cell.viewWithTag(3) as! UILabel).text = dic["jianjie"] as? String
        }
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination.isKind(of: TypeViewController.self) {
            let type = segue.destination as! TypeViewController
            type.pushByMain = true
            type.completeType = {(dic) in
                self.requestDiscovery(dic["type_id"] as? String,type2: nil)
                self.type1 = dic["type_id"] as! String
            }
        }
    }
    
    @objc func discoveryTypeAction(_ sender: UIButton) {
        sender.isSelected = true
        if sender.tag == 1 {
            type = .vender
            (sender.superview?.viewWithTag(3) as! UIButton).isSelected = false
            typeLabel.text = "厂家·自主品牌"
        }else {
            type = .product
            (sender.superview?.viewWithTag(1) as! UIButton).isSelected = false
            typeLabel.text = "产品·自主品牌"
        }

        let typeView = sender.superview?.viewWithTag(2)
        typeView!.mas_remakeConstraints { (make) in
            _ = make?.bottom.equalTo()(sender.superview!.mas_bottom)?.with().offset()(-10)
            _ = make?.left.equalTo()(sender.superview!.mas_left)?.with().offset()(sender.superview!.frame.width / 4 * CGFloat(sender.tag) - 20)
            _ = make?.width.equalTo()(40)
            _ = make?.height.equalTo()(1.5)
        }
        
        UIView.animate(withDuration: 0.5) {
            sender.superview!.layoutIfNeeded()
        }
        self.type1 = "1"
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
        }else {
            url = "Public/find_goods"
            if sender == nil {
                param = ["type_id":"1"]
            }else {
                param = ["type_id":sender!]
            }
            param["page"] = "1"
        }
        if type2 != nil {
            param["type_two_id"] = type2!
        }
        Network.request(param as NSDictionary, url: url) { (dic) in
            SVProgressHUD.dismiss()
            self.dataSource = dic as? NSDictionary
            
            let count = (self.dataSource?["type"] as! NSArray).count / 5
            if count > 0{
                self.tableView.beginUpdates()
                self.headerView.frame = CGRect(x: 0, y: 0, width: Int(Helpers.screanSize().width), height: 185 + count * 91)
                self.tableView.tableHeaderView = self.headerView
                self.tableView.endUpdates()
            }
            
            self.headerView.dataSource = self.dataSource
            self.tableView.reloadData()
        }
    }
    
}

class CutomTitleView: UIView {
    override var intrinsicContentSize: CGSize{
        return CGSize(width: 150, height: 44)
    }
}
