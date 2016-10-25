//
//  MHRefresh.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/21.
//  Copyright © 2016年 韩威. All rights reserved.
//

import Foundation
import UIKit

private var REFRESH_HEADER_KEY = 0

extension UIScrollView {
    
//    var refresh_header: MHRefreshNormalHeader?
    
    func addRefreshHeader(withHandler handler: MHRefreshHeaderBlock?) -> Void {
        
        let header = MHRefreshNormalHeader.loadSelf()
        
        header.refreshHeaderBlock = handler
        
        header.frame = CGRect.init(x: MHRefreshHeaderX, y: MHRefreshHeaderY, width: Double(MHRefreshHeaderW), height: Double(MHRefreshHeaderH))
        
        self.addSubview(header)
        
        objc_setAssociatedObject(self, &REFRESH_HEADER_KEY, header, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
    
    func refresh_header() -> MHRefreshNormalHeader {
        
        let header = objc_getAssociatedObject(self, &REFRESH_HEADER_KEY) as! MHRefreshNormalHeader
        return header
    }
}
