//
//  MHRefreshCommon.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/21.
//  Copyright © 2016年 韩威. All rights reserved.
//

import Foundation


let MHRefreshHeaderX = 0.0
let MHRefreshHeaderY = -40.0
let MHRefreshHeaderW = SCREEN_WIDTH
let MHRefreshHeaderH = 40.0

let MHRefreshFooterH = 40.0


enum MHRefreshState {
    case normal
    case pulling
    case willRefesh
    case refreshing
    case noMoreData
}


let MHRefreshKeyPathContentOffset = "contentOffset"
var MHRefreshKeyPathContentOffsetContext = 0

let MHRefreshKeyPathContentSize = "contentSize"
var MHRefreshKeyPathContentSizeContext = 0


let MHRefreshAnimationDuration = 0.3




