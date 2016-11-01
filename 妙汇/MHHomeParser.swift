//
//  MHHomeParser.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/18.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit
import Alamofire
//import SwiftyJSON
import HandyJSON

class MHHomeParser: NSObject {
    
    private var headers: HTTPHeaders {
        return [
            "timeSp" : "1476692647",
            "sign" : "0e8cea7fd6faeac6bf0457cc8d32ac3f"
        ]
    }
    
    private var para: Parameters {
        return [
            "page" : page,
            "size" : size
        ]
    }

    private var page = 1
    private var size: Int {
        return 20
    }
    
    /// 下拉刷新
    func requestNewData(handler: @escaping (MHHomeDataModel?) -> Void) -> () {
        page = 1
        self.requestData(handler)
    }
    
    
    /// 上拉加载更多
    func requestMoreData(handler: @escaping (MHHomeDataModel?) -> Void) -> () {
        page += 1
        self.requestData(handler)
    }
    
    /// 核心请求数据方法
    private func requestData(_ handler: @escaping (MHHomeDataModel?) -> Void) {
        
        if USE_NETWORK {
            MHNetwork.POST("http://api.magicwe.com/Recommend/getHomeGoods", para: para, headers: headers) { (jsonString) in
                if (jsonString != nil) {
                    
                    let homeData = JSONDeserializer<MHHomeData>.deserializeFrom(json: jsonString!)
                    
                    if (homeData?.isSuccess)! {
                        handler(homeData?.list)
                    } else {
                        handler(nil)
                    }
                    
                    
                    
//                    let listDic = dic!["list"]?.dictionaryObject
//                    let objDic = NSDictionary.init(dictionary: listDic!, copyItems: false)
//                    let list = JSONDeserializer<MHHomeDataModel>.deserializeFrom(dict: objDic)
//                    handler(list)
                } else {
                    handler(nil)
                }
            }
        }
        else {
            
            let jsonPath = Bundle.main.path(forResource: "home", ofType: ".json")
            let jsonURL = URL.init(fileURLWithPath: jsonPath!)
            
            do {
                let jsonData = try Data.init(contentsOf: jsonURL)
                
                let dic = try JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
                
                
                var dict = dic as! NSDictionary
                dict = dict.object(forKey: "list") as! NSDictionary
                let list = JSONDeserializer<MHHomeDataModel>.deserializeFrom(dict: dict)
                handler(list)
                
            } catch {
                
            }
        }
        
  
    }
    
    
}





