//
//  MHHomeParser.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/18.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

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
    func requestNewData() -> () {
        page = 1
        self.requestData()
    }
    
    
    /// 上拉加载更多
    func requestMoreData() -> () {
        page += 1
        self.requestData()
    }
    
    /// 核心请求数据方法
    private func requestData() {
        MHNetwork.POST("http://api.magicwe.com/Recommend/getHomeGoods", para: para, headers: headers) { (dic) in
            
        }
    }
}





