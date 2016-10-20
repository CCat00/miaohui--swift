//
//  MHHomeViewfieldTableViewCell.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/20.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

/// 首页视野cell
class MHHomeViewfieldTableViewCell: UITableViewCell {
    
    @IBOutlet weak var vericalADView: MHVerticalADView!
    
    var articles: [MHArticle]? {
        didSet {
            if articles == nil { return }
            
            var contentViews: [UIView] = []
            for (index, _) in articles!.enumerated() {
                
                if (index + 1) % 3 == 0 {
                    let viewfieldItem = Bundle.main.loadNibNamed("MHHomeViewfieldItem", owner: nil, options: nil)?.last as! MHHomeViewfieldItem
                    viewfieldItem.articles = [articles![index-2],articles![index-1],articles![index]]
                    contentViews.append(viewfieldItem)
                }
            }
            vericalADView.contentViews = contentViews
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
