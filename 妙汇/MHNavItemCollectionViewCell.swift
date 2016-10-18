//
//  MHNavItemCollectionViewCell.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/18.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

class MHNavItemCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    var model: MHNavigator {
        set(newValue) {
            icon.kf.setImage(with: URL(string: newValue.icon!))
            title.text = newValue.name
        }
        get {
            return self.model
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
