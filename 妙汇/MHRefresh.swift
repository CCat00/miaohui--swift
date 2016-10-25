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
    
    // MARK: - Header
    
    func addRefreshHeader(header: MHRefreshHeader) {
        if self.refresh_header() != header {
            self.refresh_header()?.removeFromSuperview()
            self.addSubview(header)
            objc_setAssociatedObject(self, &REFRESH_HEADER_KEY, header, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func refresh_header() -> MHRefreshNormalHeader? {
        let header = objc_getAssociatedObject(self, &REFRESH_HEADER_KEY) as? MHRefreshNormalHeader
        return header
    }
    
    // MARK: - Footer
    
    
}
