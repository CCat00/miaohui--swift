//
//  MHHomeParser.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/18.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit
import Alamofire

class MHHomeParser: NSObject {
    
    func requestNewData() -> () {
        
        
        let headers: HTTPHeaders = [
            "openUDID" : "iphone-CA54803B-58D0-41A3-88BD-850DD5EB6D93",
            "jpushRegistrationID" : "1a1018970aa18886766",
            "platform" : "iphone",
            "ver" : "2.2.4.5",
            "format" : "json",
            "timeSp" : "1476692647",
            "deviceInfo" : "iPhone 6",
            "pushToken" : "9e266fb0c0f42c47214dbb69507be7ed638bb985025a92e3ca12f4cdaded97c5",
            "sign" : "0e8cea7fd6faeac6bf0457cc8d32ac3f"
        ]
        let para: Parameters = [
            "page" : 1,
            "size" : 20
        ]
        Alamofire.request("http://api.magicwe.com/Recommend/getHomeGoods", method: .post, parameters: para, encoding: URLEncoding.default, headers: headers).responseJSON { (response) in
            
            switch response.result.isSuccess {
            case true:
                print(response.result.value)
                // json(data)
//                let resultDic = response.result.value as! Dictionary<>
//                
//                let allKey = resultDic.allKeys
//                
//                for key in allKey {
//                    
//                }
                
                
            case false:
                print(response.result.error)
            }
            
            
        }
    }
    func requestMoreData() -> () {
        
    }
}
