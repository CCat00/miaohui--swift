//
//  MHCategoryDetail.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/27.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit
import HandyJSON

//{
//    "resultCode": 1,
//    "resultMsg": "成功",
//    "tipsMsg": "",
//    "list": {
//        "goods": [

class MHCategoryList: HandyJSON {
    var goods: [MHGoods]?
    
    required init() {}
}

class MHCategoryDetail: MHResponseModel {
    var list: MHCategoryList?
    
    required init() {}
}
