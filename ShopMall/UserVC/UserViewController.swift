//
//  UserViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/17.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit

class UserViewController: UITableViewController {

    @IBOutlet weak var mainFuncView: UIView!
    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var userName: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainFuncView.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        mainFuncView.layer.shadowOpacity = 0.08
        mainFuncView.layer.shadowRadius = 4
        mainFuncView.layer.shadowOffset = CGSize(width: 4, height: 4)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
    }

}
