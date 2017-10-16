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
    
}
