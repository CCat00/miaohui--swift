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
    func requestNewData(type: String, handler: @escaping ([MHGoods]?) -> Void) -> () {
        page = 1
        self.requestDetailDataWithType(type: type, handler: handler)
    }
    
    
    /// 上拉加载更多
    func requestMoreData(type: String, handler: @escaping ([MHGoods]?) -> Void) -> () {
        page += 1
        self.requestDetailDataWithType(type: type, handler: handler)
    }
    
    /// 请求分类页面的详情数据
    func requestDetailDataWithType(type: String, handler: @escaping ([MHGoods]?) -> Void) {
        
        self.tag = type
        
//        if USE_NETWORK {
//            MHNetwork.POST("http://api.magicwe.com/Goods/getRecommendTipsGoodsList", para: para, headers: headers) { (dic) in
//                if (dic != nil) {
//                    let navigation = dic!["navigation"]?.arrayObject
//                    
//                    var resArray: [MHNavigator] = []
//                    
//                    for nav in navigation! {
//                        let objDic = NSDictionary.init(dictionary: nav as! [AnyHashable : Any], copyItems:
//                            false)
//                        let model = JSONDeserializer<MHNavigator>.deserializeFrom(dict: objDic)
//                        resArray.append(model!)
//                    }
//                    handler(resArray)
//                } else {
//                    handler(nil)
//                }
//            }
//        }

    }
}

