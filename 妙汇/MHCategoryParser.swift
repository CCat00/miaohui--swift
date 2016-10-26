//
//  MHCategoryParser.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/26.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import HandyJSON

class MHCategoryParser: NSObject {
    
    private var headers: HTTPHeaders {
        return [
            "timeSp" : "1476694166",
            "sign" : "a9ea77996987018fe500b93f29d95dd7"
        ]
    }
    /// 核心请求数据方法
    func requestData(_ handler: @escaping ([MHNavigator]?) -> Void) {
        
        if USE_NETWORK {
            MHNetwork.POST("http://api.magicwe.com/Navigator/getAppNavigator", para: nil, headers: headers) { (dic) in
                if (dic != nil) {
                    let navigation = dic!["navigation"]?.arrayObject
                    
                    var resArray: [MHNavigator] = []
                    
                    for nav in navigation! {
                        let objDic = NSDictionary.init(dictionary: nav as! [AnyHashable : Any], copyItems:
                            false)
                        let model = JSONDeserializer<MHNavigator>.deserializeFrom(dict: objDic)
                        resArray.append(model!)
                    }
                    handler(resArray)
                } else {
                    handler(nil)
                }
            }
        }
        else {
            
            let jsonPath = Bundle.main.path(forResource: "category", ofType: ".json")
            let jsonURL = URL.init(fileURLWithPath: jsonPath!)
            
            do {
                let jsonData = try Data.init(contentsOf: jsonURL)
                
                let dic = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                
                let dict = dic as! NSDictionary
                let navigation = dict.object(forKey: "navigation") as! NSArray
                
                var resArray: [MHNavigator] = []
                
                for nav in navigation {
                    let objDic = NSDictionary.init(dictionary: nav as! [AnyHashable : Any], copyItems:
                        false)
                    let model = JSONDeserializer<MHNavigator>.deserializeFrom(dict: objDic)
                    resArray.append(model!)
                }
                handler(resArray)
                
            } catch {
                handler(nil)
            }
        }
        
        
    }
    
    
}





