//
//  MHResponseModel.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/27.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit
import HandyJSON

/// 数据请求结果的模型
class MHResponseModel: HandyJSON {
    var resultCode: Int?
    var resultMsg: String?
    var tipsMsg: String?
    
    var isSuccess: Bool {
        get {
            if resultCode == nil { return false }
            if resultCode! != 1 { return false }
            return true
        }
    }
    
    required init() {}
}
