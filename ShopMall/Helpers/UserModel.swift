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
    
    private var _address:String?
    var address:String {
        get{
            if self._address == nil {
                if UserDefaults.standard.object(forKey: "ADDRESS") != nil {
                    self._address = UserDefaults.standard.object(forKey: "ADDRESS") as? String
                    return self._address!
                }
                return ""
            }else{
                return self._address!
            }
        }
    }
    
    private var _face:String?
    var face:String {
        get{
            if self._face == nil {
                if UserDefaults.standard.object(forKey: "FACE") != nil {
                    self._face = UserDefaults.standard.object(forKey: "FACE") as? String
                    return self._face!
                }
                return ""
            }else{
                return self._face!
            }
        }
    }
    
    private var _goodsType:String?
    var goodsType:String {
        get{
            if self._goodsType == nil {
                if UserDefaults.standard.object(forKey: "GOODSTYPE") != nil {
                    self._goodsType = UserDefaults.standard.object(forKey: "GOODSTYPE") as? String
                    return self._goodsType!
                }
                return ""
            }else{
                return self._goodsType!
            }
        }
    }
    
    private var _jianjie:String?
    var jianjie:String {
        get{
            if self._jianjie == nil {
                if UserDefaults.standard.object(forKey: "JIANJIE") != nil {
                    self._jianjie = UserDefaults.standard.object(forKey: "JIANJIE") as? String
                    return self._jianjie!
                }
                return ""
            }else{
                return self._jianjie!
            }
        }
    }
    
    private var _name:String?
    var name:String {
        get{
            if self._name == nil {
                if UserDefaults.standard.object(forKey: "NAME") != nil {
                    self._name = UserDefaults.standard.object(forKey: "NAME") as? String
                    return self._name!
                }
                return ""
            }else{
                return self._name!
            }
        }
    }
    
    private var _password:String?
    var password:String {
        get{
            if self._password == nil {
                if UserDefaults.standard.object(forKey: "PASSWORD") != nil {
                    self._password = UserDefaults.standard.object(forKey: "PASSWORD") as? String
                    return self._password!
                }
                return ""
            }else{
                return self._password!
            }
        }
    }
    
    private var _phone:String?
    var phone:String {
        get{
            if self._phone == nil {
                if UserDefaults.standard.object(forKey: "PHONE") != nil {
                    self._phone = UserDefaults.standard.object(forKey: "PHONE") as? String
                    return self._phone!
                }
                return ""
            }else{
                return self._phone!
            }
        }
    }
    
    private var _qq:String?
    var qq:String {
        get{
            if self._qq == nil {
                if UserDefaults.standard.object(forKey: "QQ") != nil {
                    self._qq = UserDefaults.standard.object(forKey: "QQ") as? String
                    return self._qq!
                }
                return ""
            }else{
                return self._qq!
            }
        }
    }
    
    private var _shakey:String?
    var shakey:String {
        get{
            if self._shakey == nil {
                if UserDefaults.standard.object(forKey: "SHAKEY") != nil {
                    self._shakey = UserDefaults.standard.object(forKey: "SHAKEY") as? String
                    return self._shakey!
                }
                return ""
            }else{
                return self._shakey!
            }
        }
    }
    
    private var _time:String?
    var time:String {
        get{
            if self._time == nil {
                if UserDefaults.standard.object(forKey: "TIME") != nil {
                    self._time = UserDefaults.standard.object(forKey: "TIME") as? String
                    return self._time!
                }
                return ""
            }else{
                return self._time!
            }
        }
    }
    
    private var _type:String?
    var type:String {
        get{
            if self._type == nil {
                if UserDefaults.standard.object(forKey: "TYPE") != nil {
                    self._type = UserDefaults.standard.object(forKey: "TYPE") as? String
                    return self._type!
                }
                return ""
            }else{
                return self._type!
            }
        }
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
    
    private var _weixin:String?
    var weixin:String {
        get{
            if self._weixin == nil {
                if UserDefaults.standard.object(forKey: "WEIXIN") != nil {
                    self._weixin = UserDefaults.standard.object(forKey: "WEIXIN") as? String
                    return self._weixin!
                }
                return ""
            }else{
                return self._weixin!
            }
        }
    }
    
    public class func saveUserinfo(_ dic:Any) -> Void {
        let userDefault = UserDefaults.standard
        var dict = NSDictionary()
        if (dic as! NSDictionary)["uinfo"] != nil {
            dict = (dic as! NSDictionary)["uinfo"] as! NSDictionary
        }else {
            dict = (dic as! NSDictionary)["list"] as! NSDictionary
        }
        userDefault.set(dict["address"], forKey: "ADDRESS")
        userDefault.set(dict["face"], forKey: "FACE")
        userDefault.set(dict["goods_type"], forKey: "GOODSTYPE")
        userDefault.set(dict["jianjie"], forKey: "JIANJIE")
        userDefault.set(dict["name"], forKey: "NAME")
        userDefault.set(dict["password"], forKey: "PASSWORD")
        userDefault.set(dict["phone"], forKey: "PHONE")
        userDefault.set(dict["qq"], forKey: "QQ")
        userDefault.set(dict["shakey"], forKey: "SHAKEY")
        userDefault.set(dict["time"], forKey: "TIME")
        userDefault.set(dict["type"], forKey: "TYPE")
        userDefault.set(dict["user_id"], forKey: "USERID")
        userDefault.set(dict["weixin"], forKey: "WEIXIN")
        userDefault.synchronize()
    }
    
    func resetAvatar() -> Void {
        _face = nil
    }
    
    func resetQQ() -> Void {
        _qq = nil
    }
    
    func resetWeixin() -> Void {
        _weixin = nil
    }
    
    func resetJianjie() -> Void {
        _jianjie = nil
    }
    
}
