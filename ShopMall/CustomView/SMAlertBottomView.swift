//
//  SMAlertBottomView.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/18.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import Masonry
import SnapKit

class SMAlertBottomView: UIView, UITextViewDelegate {

    @IBOutlet weak var alertView: UITextView!
    @IBOutlet weak var alertCenterY: NSLayoutConstraint!
    
    var placeholderStr: String?
    var text: String?
    var keyboardType: UIKeyboardType = .default
    var completeEnter: ((String) -> Void)?
    
    override func awakeFromNib() {
        superview?.awakeFromNib()
        alertView.textContainerInset = UIEdgeInsetsMake(15, 0, 44, 0)
        alertCenterY.constant = Helpers.screanSize().height / 2
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        
        let placeholder = UILabel()
        placeholder.font = UIFont.systemFont(ofSize: 14)
        placeholder.textColor = #colorLiteral(red: 0.7095867991, green: 0.7096036673, blue: 0.709594667, alpha: 1)
        placeholder.tag = 9
        alertView.addSubview(placeholder)
        placeholder.mas_makeConstraints { (make) in
            _ = make?.top.equalTo()(self.alertView.mas_top)?.with().offset()(14)
            _ = make?.left.equalTo()(self.alertView.mas_left)?.with().offset()(4)
        }
        
        let sureBtn = UIButton(type: .custom)
        sureBtn.tag = 11
        sureBtn.backgroundColor = #colorLiteral(red: 0.9624364972, green: 0.3781699538, blue: 0.3513175845, alpha: 1)
        sureBtn.setTitle("确定", for: .normal)
        sureBtn.setTitleColor(#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0), for: .normal)
        sureBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        alertView.addSubview(sureBtn)
        
        let container = UILayoutGuide()
        alertView.addLayoutGuide(container)
        
        container.snp.makeConstraints { (make) in
            make.edges.equalTo(alertView)
        }

        sureBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(container)
            make.left.equalTo(container)
            make.width.equalTo(150)
            make.height.equalTo(44)
        }
        
        let line = UIView()
        line.backgroundColor = #colorLiteral(red: 0.5704585314, green: 0.5704723597, blue: 0.5704649091, alpha: 1)
        alertView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.equalTo(container)
            make.right.equalTo(container)
            make.height.equalTo(0.5)
            make.top.equalTo(sureBtn)
        }
        
        let cancelBtn = UIButton(type: .custom)
        cancelBtn.tag = 12
        alertView.addSubview(cancelBtn)
        cancelBtn.setTitle("取消", for: .normal)
        cancelBtn.setTitleColor(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        cancelBtn.snp.makeConstraints { (make) in
            make.bottom.equalTo(container)
            make.right.equalTo(container)
            make.width.equalTo(150)
            make.height.equalTo(44)
        }
        
        sureBtn.addTarget(self, action: #selector(alertAction(_:)), for: .touchUpInside)
        cancelBtn.addTarget(self, action: #selector(alertAction(_:)), for: .touchUpInside)
        
        
        UIView.animate(withDuration: 0, delay: 0, options: .curveEaseInOut, animations: ({
            self.alertCenterY.constant = Helpers.screanSize().height / 2
            self.layoutIfNeeded()
        }), completion: {(_ finish:Bool) -> Void in
            UIView.animate(withDuration: 0.23, delay: 0, options: .curveEaseInOut, animations: ({
                self.alertCenterY.constant = -10
                self.layoutIfNeeded()
            }), completion: {(_ finish:Bool) -> Void in
                UIView.animate(withDuration: 0.09, delay: 0.02, options: .curveEaseInOut, animations: ({
                    self.alertCenterY.constant = 5
                    self.layoutIfNeeded()
                }), completion: {(_ finish:Bool) -> Void in
                    UIView.animate(withDuration: 0.05, delay: 0.02, options: .curveEaseInOut, animations: ({
                        self.alertCenterY.constant = 0
                        self.layoutIfNeeded()
                    }), completion: {(_ finish:Bool) -> Void in
                        
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
//        if (text?.characters.count)! > 0 {
//            (self.viewWithTag(9) as! UILabel).isHidden = true
//        }
        (self.viewWithTag(9) as! UILabel).text = placeholderStr
//        alertView.text = text
        alertView.keyboardType = keyboardType
        self.layoutIfNeeded()
    }
    
    @objc func alertAction(_ sender: UIButton) {
        if sender.tag == 11 {
            if completeEnter != nil {
                completeEnter!(alertView.text)
            }
        }else {
            
        }
        self.removeFromSuperview()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    // MARK: - UIKeyboard Show And Hide
    @objc func keyboardWillShow(_ notification: NSNotification) -> Void {
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let keyboardRect:CGRect = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        UIView.animate(withDuration: duration, animations: {
            self.alertCenterY.constant = -keyboardRect.size.height/2
            self.layoutIfNeeded()
        }) { (finish) in
            
        }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) -> Void {
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        UIView.animate(withDuration: duration, animations: {
            self.alertCenterY.constant = 0
            self.layoutIfNeeded()
        }) { (finish) in
            
        }
    }
    
    // MARK: - UITextViewDelegate
    func textViewDidChange(_ textView: UITextView) {
        self.viewWithTag(9)?.isHidden = (textView.text.characters.count != 0)
    }
    
}

