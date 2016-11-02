//
//  MHFOVCategoryCollectionViewCell.swift
//  妙汇
//
//  Created by 韩威 on 2016/11/2.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

class MHFOVCategoryCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var indictorView: UIView!

    var model: MHFieldOfViewCategory? {
        didSet {
            guard model != nil else {
                return
            }
            title.text = model!.name
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected  {
                title.isHighlighted = true
                indictorView.alpha = 1
            } else {
                title.isHighlighted = false
                indictorView.alpha = 0

            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.isSelected = false
    }
    

}
