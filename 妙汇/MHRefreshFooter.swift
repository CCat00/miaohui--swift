//
//  MHRefreshFooter.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/25.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

typealias MHRefreshFooterBlock = (MHRefreshFooter) -> Void

/// 上拉加载控件的基类
class MHRefreshFooter: MHRefreshBase {
    
    /// 上拉加载回调
    var refreshFooterBlock: MHRefreshFooterBlock?
    
    static func footerWithHandler(handler: MHRefreshFooterBlock?) -> MHRefreshFooter? {
        return nil
    }
    
}
