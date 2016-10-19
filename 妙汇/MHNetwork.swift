//
//  MHNetwork.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/18.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MHNetwork: NSObject {
    
    static func POST(
        _ url: URLConvertible,
        para: Parameters? = nil,
        headers: HTTPHeaders? = nil,
        completionHandler: @escaping ([String : JSON]?) -> Void) {
        
        var var_headers: HTTPHeaders = self.defaultHeaders()
        
        if !(headers?.isEmpty)! {
            for (key, value) in headers! {
                var_headers[key] = value
            }
        }
        
        Alamofire.request(url, method: .post, parameters: para, encoding: URLEncoding.default, headers: var_headers).responseJSON { (response) in
            
            switch response.result.isSuccess {
            case true:
                //print("response success.")
                
                if let value = response.result.value {
                    
                    let json = JSON(value)
                    let dic = json.dictionary
                    completionHandler(dic)
                }
                else {
                    completionHandler(nil)
                }
            case false:
                print("response.result.error = \(response.result.error)")
                completionHandler(nil)
            }
            
        }
    }
    
    // MARK: - Private
    
    private static func defaultHeaders() -> HTTPHeaders {
        let headers: HTTPHeaders = [
            "openUDID" : "iphone-CA54803B-58D0-41A3-88BD-850DD5EB6D93",
            "jpushRegistrationID" : "1a1018970aa18886766",
            "platform" : "iphone",
            "ver" : "2.2.4.5",
            "format" : "json",
            "deviceInfo" : "iPhone 6",
            "pushToken" : "9e266fb0c0f42c47214dbb69507be7ed638bb985025a92e3ca12f4cdaded97c5",
        ]
        return headers
    }
}



