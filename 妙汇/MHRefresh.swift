//
//  MHRefresh.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/21.
//  Copyright © 2016年 韩威. All rights reserved.
//

import Foundation
import UIKit


extension UIScrollView {
    
    func addRefreshHeader(withHandler handler: MHRefreshBlock?) -> Void {
        
        
        let header = MHRefreshNormalHeader.loadSelf()
        
        header.refreshBlock = handler
        
        header.frame = CGRect.init(x: MHRefreshHeaderX, y: MHRefreshHeaderY, width: Double(MHRefreshHeaderW), height: Double(MHRefreshHeaderH))
        self.addSubview(header)
        
    }
}
