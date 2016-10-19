//
//  MHHomePromotionsTableViewCell.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/19.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

/// 首页促销cell（3个固定商品）
class MHHomePromotionsTableViewCell: UITableViewCell {

    @IBOutlet weak var leftItem: MHHomePromotionsItem!
    @IBOutlet weak var centerItem: MHHomePromotionsItem!
    @IBOutlet weak var rightItem: MHHomePromotionsItem!
    
    var pros: [MHPromotion]? {
        didSet {
            if pros != nil {
                leftItem.pro = pros![0]
                centerItem.pro = pros![1]
                rightItem.pro = pros![2]
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
