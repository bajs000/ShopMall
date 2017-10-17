//
//  UserModel.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/17.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit

class UserModel: NSObject {

    static let share = UserModel()
    
    public class func checkUserLogin(at viewController: UIViewController) -> Bool {
        if UserModel.share.userId.characters.count == 0 {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "loginNav")
            viewController.present(vc, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    private var _userId:String?
    var userId:String {
        get{
            if self._userId == nil {
                if UserDefaults.standard.object(forKey: "USERID") != nil {
                    self._userId = UserDefaults.standard.object(forKey: "USERID") as? String
                    return self._userId!
                }
                return ""
            }else{
                return self._userId!
            }
        }
    }
    
}
