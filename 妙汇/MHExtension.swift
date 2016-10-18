//
//  MHExtension.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/18.
//  Copyright © 2016年 韩威. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func hexColor(hex: Int32) -> UIColor {
        let r = Double((hex & 0xFF0000) >> 16)
        let g = Double((hex & 0x00FF00) >> 8)
        let b = Double((hex & 0xFF00FF) >> 0)
        
        return UIColor.init(
            red: CGFloat(r/255.0),
            green: CGFloat(g/255.0),
            blue: CGFloat(b/255.0)
            , alpha: 1.0)
    }
}
