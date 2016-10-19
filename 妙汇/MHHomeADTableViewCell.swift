//
//  MHHomeADTableViewCell.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/19.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

class MHHomeADTableViewCell: UITableViewCell {

    @IBOutlet weak var adScrollView: MHADScrollView!
    
    var models: [MHBanner] = [] {
        didSet {
            if oldValue.count > 0 {
                return
            }
            var urls: [String] = []
            for banner in models {
                urls.append(banner.pic!)
                adScrollView.imageUrls = urls
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        adScrollView.currentPageIndicatorTintColor = MH_MAIN_COLOR_YELLOW
        adScrollView.pageIndicatorTintColor = UIColor.lightGray
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
