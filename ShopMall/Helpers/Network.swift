//
//  Network.swift
//  ShopMall
//
//  Created by YunTu on 2017/10/16.
//  Copyright © 2017年 YunTu. All rights reserved.
//

import UIKit
import SVProgressHUD
import AFNetworking

class Network: NSObject {

    public class func request(_ param:NSDictionary, url:String, complete: ((_ responseObject:Any) -> Void)?){
        let reqUrl = "http://anfutong.cq1b1.com/api.php/" + url
        var req = URLRequest(url: URL(string: reqUrl)!)
        let tempParam = NSMutableDictionary(dictionary: param)
        tempParam.setValue("f74dd39951a0b6bbed0fe73606ea5476", forKey: "apikey")
        tempParam.setValue("1.1", forKey: "version")
        //        tempParam.setValue("ios", forKey: "terminal")
        
        var body = ""
        for key in tempParam.allKeys {
            body = body + (key as! String) + "=" + (tempParam[(key as! String)] as! String)
            body = body + "&"
        }
        body = body.substring(to: body.index(body.endIndex, offsetBy: -1))
        print(body)
        let bodyData = body.data(using: .utf8)
        req.httpBody = bodyData
        req.httpMethod = "POST"
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        NSURLConnection.sendAsynchronousRequest(req, queue: OperationQueue(), completionHandler: {
            (_ response:URLResponse?, data:Data?, error:Error?) -> Void in
            if error == nil {
                DispatchQueue.main.async(execute: {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    do {
                        let dic = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! NSDictionary
                        if complete != nil {
                            complete!(dic)
                        }
                    }catch{
                        
                    }
                })
            }else{
                print(error!)
                SVProgressHUD.dismiss()
            }
        })
        
        
    }
    
}
