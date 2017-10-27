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
    
    public class func requestLocation(url:String, complete: ((_ responseObject:Any) -> Void)?){
        let reqUrl = url
        var req = URLRequest(url: URL(string: (reqUrl as NSString).addingPercentEscapes(using: String.Encoding.utf8.rawValue)!)!)
        req.httpMethod = "GET"
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
                        print(error)
                    }
                })
            }else{
                print(error!)
                SVProgressHUD.dismiss()
            }
        })
        
        
    }
    
}

class UploadNetwork: NSObject {
    
    public class func request(_ param: [String:String], data: Any, paramName: String, url:String, complete: ((_ responseObject:Any) -> Void)?) -> Void {
        let tempParam = NSMutableDictionary(dictionary: param)
        tempParam.setValue("f74dd39951a0b6bbed0fe73606ea5476", forKey: "apikey")
        tempParam.setValue("1.1", forKey: "version")
        
        let manager = AFHTTPSessionManager.init()
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html","text/plain","application/json","application/xml")
        let reqUrl = "http://anfutong.cq1b1.com/api.php/" + url
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        manager.post(reqUrl, parameters: tempParam, constructingBodyWith: { (formData) in
            let format = DateFormatter.init()
            format.dateFormat = "yyyyMMddHHmmss"
            let timeName = format.string(from: Date()) + ".jpg"
            let imgData = UIImageJPEGRepresentation(data as! UIImage, 0.2)
            formData.appendPart(withFileData: imgData!, name: paramName, fileName: timeName, mimeType: "image/jpg")
        }, progress: { (progress) in
            print(progress.fractionCompleted)
            SVProgressHUD.showProgress(Float(progress.fractionCompleted))
            if progress.fractionCompleted >= 1 {
                SVProgressHUD.dismiss()
            }
        }, success: { (task, responseObject) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if responseObject != nil {
                complete!(responseObject!)
            }
        }) { (task, error) in
            print(error)
        }
    }
    
    public class func request(_ param: [String:String], datas: [Any], paramName: String, url:String, complete: ((_ responseObject:Any) -> Void)?) -> Void {
        let tempParam = NSMutableDictionary(dictionary: param)
        tempParam.setValue("f74dd39951a0b6bbed0fe73606ea5476", forKey: "apikey")
        tempParam.setValue("1.1", forKey: "version")
        
        let manager = AFHTTPSessionManager.init()
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html","text/plain","application/json","application/xml")
        let reqUrl = "http://anfutong.cq1b1.com/api.php/" + url
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        manager.post(reqUrl, parameters: tempParam, constructingBodyWith: { (formData) in
            let format = DateFormatter.init()
            format.dateFormat = "yyyyMMddHHmmss"
            let timeName = format.string(from: Date()) + ".jpg"
            for data in datas {
                let imgData = UIImageJPEGRepresentation(data as! UIImage, 0.2)
                formData.appendPart(withFileData: imgData!, name: paramName, fileName: timeName, mimeType: "image/jpg")
            }
        }, progress: { (progress) in
            print(progress.fractionCompleted)
            SVProgressHUD.showProgress(Float(progress.fractionCompleted))
            if progress.fractionCompleted >= 1 {
                SVProgressHUD.dismiss()
            }
        }, success: { (task, responseObject) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if responseObject != nil {
                complete!(responseObject!)
            }
        }) { (task, error) in
            print(error)
        }
    }
    
    public class func request(_ param: [String:String], datas: [String:Any], paramName: String?, url:String, complete: ((_ responseObject:Any) -> Void)?) -> Void {
        let tempParam = NSMutableDictionary(dictionary: param)
        tempParam.setValue("f74dd39951a0b6bbed0fe73606ea5476", forKey: "apikey")
        tempParam.setValue("1.1", forKey: "version")
        
        let manager = AFHTTPSessionManager.init()
        manager.responseSerializer.acceptableContentTypes = Set(arrayLiteral: "text/html","text/plain","application/json","application/xml")
        let reqUrl = "http://anfutong.cq1b1.com/api.php/" + url
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        manager.post(reqUrl, parameters: tempParam, constructingBodyWith: { (formData) in
            let format = DateFormatter.init()
            format.dateFormat = "yyyyMMddHHmmss"
            let timeName = format.string(from: Date()) + ".jpg"
//            for data in datas {
//                let imgData = UIImageJPEGRepresentation(data as! UIImage, 0.2)
//                formData.appendPart(withFileData: imgData!, name: paramName, fileName: timeName, mimeType: "image/jpg")
//            }
            for key in (datas as NSDictionary).allKeys {
                let imgData = UIImageJPEGRepresentation(datas[key as! String] as! UIImage, 0.2)
                formData.appendPart(withFileData: imgData!, name: key as! String, fileName: timeName, mimeType: "image/jpg")
            }
            
        }, progress: { (progress) in
            print(progress.fractionCompleted)
            SVProgressHUD.showProgress(Float(progress.fractionCompleted))
            if progress.fractionCompleted >= 1 {
                SVProgressHUD.dismiss()
            }
        }, success: { (task, responseObject) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            if responseObject != nil {
                complete!(responseObject!)
            }
        }) { (task, error) in
            print(error)
        }
    }
    
}
