//
//  MHFieldOfViewParser.swift
//  妙汇
//
//  Created by 韩威 on 2016/11/1.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit
import Alamofire
import HandyJSON

class MHFieldOfViewParser: NSObject {
    
    private var headers: HTTPHeaders {
        return [
            "timeSp" : "1477983606",
            "sign" : "b1eaaa8a4fb1d81747b1384abc60a477"
        ]
    }
    
    private var para: Parameters {
        return [
            "page" : page,
            "size" : size,
            "tagId"  : tag,
        ]
    }
    
    private var page = 1
    private var size: Int {
        return 20
    }
    private var tag = "0"
    
    /// 下拉刷新
    func requestNewData(handler: @escaping ([MHSpecialTopic]?) -> Void) -> () {
        page = 1
        self.requestListlData(handler: handler)
    }
    
    
    /// 上拉加载更多
    func requestMoreData(handler: @escaping ([MHSpecialTopic]?) -> Void) -> () {
        page += 1
        self.requestListlData(handler: handler)
    }
    
    /// 请求视野页面的列表数据
    private func requestListlData(handler: @escaping ([MHSpecialTopic]?) -> Void) {
        
        if USE_NETWORK {
            
            MHNetwork.POST("http://api.magicwe.com/Article/getSpecialTopicList", para: para, headers: headers) { (jsonString) in
                if (jsonString != nil) {
                    
                    let model = JSONDeserializer<MHFieldOfViewModel>.deserializeFrom(json: jsonString)
                    handler(model?.specialTopicList)
                } else {
                    handler(nil)
                }
            }
            
        } else {
            
            
            let jsonPath = Bundle.main.path(forResource: "fieldOfView_all", ofType: ".json")
            
            let jsonURL = URL.init(fileURLWithPath: jsonPath!)
            
            do {
                let jsonData = try Data.init(contentsOf: jsonURL)
                
                let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8)
                
                let model = JSONDeserializer<MHFieldOfViewModel>.deserializeFrom(json: jsonString)
                handler(model?.specialTopicList)
                
            } catch {
                handler(nil)
            }
            
        }
        
    }
    
    /// 请求视野界面上的分类列表
    static func requestCategoryData(handler: @escaping (MHFieldOfViewCategoryResponse?) -> Void) {
        
        if USE_NETWORK {
            
            let header: HTTPHeaders = [
                "timeSp" : "1477983606",
                "sign" : "95864fa4058633a2f4b77b16afa72629"
            ]
            MHNetwork.POST("http://api.magicwe.com/Article/getNavigator", para: nil, headers: header) { (jsonString) in
                if (jsonString != nil) {
                    
                    let model = JSONDeserializer<MHFieldOfViewCategoryResponse>.deserializeFrom(json: jsonString)
                    handler(model)
                } else {
                    handler(nil)
                }
            }
            
        } else {
            
            
            let jsonPath = Bundle.main.path(forResource: "fieldOfView_category", ofType: ".json")
            
            let jsonURL = URL.init(fileURLWithPath: jsonPath!)
            
            do {
                let jsonData = try Data.init(contentsOf: jsonURL)
                
                let jsonString = String.init(data: jsonData, encoding: String.Encoding.utf8)
                
                let model = JSONDeserializer<MHFieldOfViewCategoryResponse>.deserializeFrom(json: jsonString)
                handler(model)
                
            } catch {
                handler(nil)
            }
            
        }
        
    }
}


