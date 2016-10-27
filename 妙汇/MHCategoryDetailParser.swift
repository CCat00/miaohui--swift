//
//  MHCategoryDetailParser.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/27.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON

class MHCategoryDetailParser: NSObject {

    private var headers: HTTPHeaders {
        return [
            "timeSp" : "1476694322",
            "sign" : "f0387efefe7280e285f5476b33ed5ebd"
        ]
    }
    
    private var para: Parameters {
        return [
            "page" : page,
            "size" : size,
            "tag"  : tag,
        ]
    }
    
    private var page = 1
    private var size: Int {
        return 20
    }
    private var tag = "new"
    
    /// 下拉刷新
    func requestNewData(type: String, handler: @escaping (MHCategoryList?) -> Void) -> () {
        page = 1
        self.requestDetailDataWithType(type: type, handler: handler)
    }
    
    
    /// 上拉加载更多
    func requestMoreData(type: String, handler: @escaping (MHCategoryList?) -> Void) -> () {
        page += 1
        self.requestDetailDataWithType(type: type, handler: handler)
    }
    
    /// 请求分类页面的详情数据
    private func requestDetailDataWithType(type: String, handler: @escaping (MHCategoryList?) -> Void) {
        
        self.tag = type
        
        if USE_NETWORK {
            
            MHNetwork.POST("http://api.magicwe.com/Goods/getRecommendTipsGoodsList", para: para, headers: headers) { (jsonString) in
                if (jsonString != nil) {
                    
                    let model = JSONDeserializer<MHCategoryDetail>.deserializeFrom(json: jsonString)
                    handler(model?.list)
                } else {
                    handler(nil)
                }
            }
            
        } else {
            
            let jsonStringFileName = "category_" + type
            
            let jsonPath = Bundle.main.path(forResource: jsonStringFileName, ofType: ".json")
            if jsonPath == nil {
                handler(nil)
                return
            }
            let jsonURL = URL.init(fileURLWithPath: jsonPath!)
            
            do {
                let jsonData = try Data.init(contentsOf: jsonURL)
                
                let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8)
                
                let model = JSONDeserializer<MHCategoryDetail>.deserializeFrom(json: jsonString)
                handler(model?.list)
                
            } catch {
                handler(nil)
            }

        }

    }
}

