//
//  MHHomePromotionsItem.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/19.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit
import Kingfisher

/// 促销商品的一个item
class MHHomePromotionsItem: UIView {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var pro: MHPromotion? {
        didSet {
            if pro != nil {
                name.text = pro!.ad_name
                title.text = pro!.ad_title
                imageView.kf.setImage(with: URL.init(string: pro!.ad_code!))
                // TODO: attribute
                bottomLabel.text = "距离结束"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
}
