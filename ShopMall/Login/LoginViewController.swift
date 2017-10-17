//
//  LoginViewController.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/17.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var tagLeading: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tagLeading.constant = Helpers.screanSize().width / 4 - 9
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func swicthAction(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            if sender.tag == 1 {
                self.tagLeading.constant = Helpers.screanSize().width / 4 - 9
            }else{
                self.tagLeading.constant = Helpers.screanSize().width / 4 * 3 - 9
            }
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func swipeAction(_ sender: UISwipeGestureRecognizer) {
        if sender.direction == .down {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
