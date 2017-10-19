//
//  Helpers.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/16.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit

class Helpers: NSObject {

    public class func screanSize() -> CGSize{
        return UIScreen.main.bounds.size
    }
    
    public class func findSuperViewClass(_ className:AnyClass,with view:UIView) -> UIView? {
        var superView:UIView? = view
        for _ in 0...10 {
            superView = superView?.superview
            if superView!.isKind(of: className) {
                return superView
            }
        }
        return superView
    }
    
    public class func findClass(_ className:AnyClass,at parentView:UIView) -> UIView? {
        var view:UIView? = nil
        for v in parentView.subviews {
            if v.isKind(of: className) {
                view = v
                break
            }else{
                view = self.findClass(className, at: v)
                if view != nil {
                    break
                }
            }
        }
        
        return view
    }
    
    public class func baseImgUrl() -> String {
        return "http://anfutong.cq1b1.com/"
    }
    
    public class func updateTimeForRow(_ str: String) -> String {
        let currentTime = Date().timeIntervalSince1970
        let createTime = Double(str)!
        let time = currentTime - createTime
        
        let small =  time / 60
        if small == 0 {
            return "刚刚"
        }
        
        if small < 60 {
            return "\(Int(small))分钟前"
        }
        
        let hours = time / 3600
        if hours < 24 {
            return "\(Int(hours))小时前"
        }
        
        let days = time / 3600 / 24
        if days < 30 {
            return "\(Int(days))天前"
        }
        
        let mouths = time / 3600 / 24 / 30
        if mouths < 12 {
            return "\(Int(mouths))月前"
        }
        
        let years = time / 3600 / 24 / 30 / 12
        return "\(Int(years))年前"
    }
    
    public class func barInit(_ tabBarController: UITabBarController) -> Void {
        var i:Int = 0
        var titleArr = ["首页","发现","发布","消息","我的"]
        for item in (tabBarController.tabBar.items)! {
            let normalImg = UIImage(named: "tabbar-not-" + String(i))?.withRenderingMode(.alwaysOriginal)
            let selectImg = UIImage(named: "tabbar-" + String(i))?.withRenderingMode(.alwaysOriginal)
            item.selectedImage = selectImg
            item.image = normalImg
            item.title = titleArr[i]
            item .setTitleTextAttributes([NSAttributedStringKey.foregroundColor:#colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1)], for: .selected)
            item .setTitleTextAttributes([NSAttributedStringKey.foregroundColor:#colorLiteral(red: 0.003166638315, green: 0.003166806418, blue: 0.003166715847, alpha: 1)], for: .normal)
            i = i + 1
        }
    }
    
}
