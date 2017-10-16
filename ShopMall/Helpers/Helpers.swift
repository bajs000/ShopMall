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
    
    public class func updateTimeForRow(_ str: String){
        let currentTime = Date().timeIntervalSince1970
//        let createTime = Float(str) / 1000
        
        
    }
    
}
