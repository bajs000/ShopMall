//
//  SMAlertView.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/18.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import Masonry

class SMAlertView: UIView {

    @IBOutlet weak var alertView: UITextView!
    
    override func awakeFromNib() {
        superview?.awakeFromNib()
        alertView.textContainerInset = UIEdgeInsetsMake(20, 0, 44, 0)
        
        let placeholder = UILabel()
        placeholder.font = UIFont.systemFont(ofSize: 14)
        placeholder.textColor = #colorLiteral(red: 0.7095867991, green: 0.7096036673, blue: 0.709594667, alpha: 1)
        placeholder.text = "aaaaaaaaaaaa"
        alertView.addSubview(placeholder)
        placeholder.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(self.alertView.mas_top)?.with().offset()(18)
            _ = make?.left.equalTo()(self.alertView.mas_left)?.with().offset()(4)
        }
        
        let sureBtn = UIButton(type: .custom)
        sureBtn.tag = 11
        sureBtn.backgroundColor = #colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1)
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        alertView.addSubview(sureBtn)
//        let left = NSLayoutConstraint(item: sureBtn, attribute: .left, relatedBy: .equal, toItem: alertView, attribute: .left, multiplier: 1, constant: 0)
//        let bottom = NSLayoutConstraint(item: sureBtn, attribute: .bottom, relatedBy: .equal, toItem: alertView, attribute: .bottom, multiplier: 1, constant: 0)
//        let width = NSLayoutConstraint(item: sureBtn, attribute: .width, relatedBy: .equal, toItem: alertView, attribute: .width, multiplier: 0.5, constant: 0)
//        let height = NSLayoutConstraint(item: sureBtn, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: 44)
//        sureBtn.addConstraint(left)
//        sureBtn.addConstraint(bottom)
//        sureBtn.addConstraint(width)
//        sureBtn.addConstraint(height)
        sureBtn.mas_makeConstraints { (make) in
            if #available(iOS 11.0, *) {
                _ = make?.bottom.equalTo()(self.alertView.mas_safeAreaLayoutGuideBottom)
            } else {
                // Fallback on earlier versions
            }
            _ = make?.left.equalTo()(self.alertView.mas_left)
            _ = make?.width.equalTo()(150)
            _ = make?.height.equalTo()(44)
        }
        
        let line = UIView()
        line.backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
        alertView.addSubview(line)
        line.mas_makeConstraints { (make) in
            _ = make?.left.equalTo()(self.alertView.mas_left)
            _ = make?.right.equalTo()(self.alertView.mas_right)
            _ = make?.height.equalTo()(0.5)
            _ = make?.centerY.equalTo()(self.alertView.mas_centerY)
            
        }
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.tag = 2
        alertView.addSubview(cancelBtn)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelBtn.mas_makeConstraints { (make) in
            _ = make?.bottom.equalTo()(self.alertView.mas_bottom)
            _ = make?.right.equalTo()(self.alertView.mas_right)
            _ = make?.width.equalTo()(self.alertView.mas_width)?.with().dividedBy()(2)
            _ = make?.height.equalTo()(44)
        }
        
        sureBtn.addTarget(self, action: #selector(alertAction(_:)), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(alertAction(_:)), for: .touchUpInside)
        
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: ({
            self.alertView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }), completion: {(_ finish:Bool) -> Void in
            UIView.animate(withDuration: 0.23, delay: 0, options: .curveEaseInOut, animations: ({
                self.alertView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }), completion: {(_ finish:Bool) -> Void in
                UIView.animate(withDuration: 0.09, delay: 0.02, options: .curveEaseInOut, animations: ({
                    self.alertView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
                }), completion: {(_ finish:Bool) -> Void in
                    UIView.animate(withDuration: 0.05, delay: 0.02, options: .curveEaseInOut, animations: ({
                        self.alertView.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                    }), completion: {(_ finish:Bool) -> Void in
                        print(self.viewWithTag(11)!.frame)
                    })
                })
            })
        })
    }
    
    func showOnWindows() -> Void {
        let window:UIWindow = ((UIApplication.shared.delegate?.window)!)! as UIWindow
        self.frame = window.frame
        window.addSubview(self)
        window.bringSubview(toFront: self)
        self.layoutIfNeeded()
    }
    
    @objc func alertAction(_ sender: UIButton) {
        self.removeFromSuperview()
    }
    
}

