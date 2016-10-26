//
//  MHCategoryBtn.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/26.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit
import Kingfisher

class MHCategoryBtn: UIButton {
    
    private lazy var label: UILabel = {
        let label = UILabel.init()
        label.textColor = UIColor.white
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var model : MHNavigator? {
        didSet {
            if model == nil {
                return
            }
            label.text = model!.name
            
            let gray = UIColor.black.withAlphaComponent(0.7)
            self.setImage(UIImage.imageWithColor(color: gray, size: CGSize.init(width: SCREEN_WIDTH, height: SCREEN_HEIGHT / 6.0)), for: .normal)
            self.kf.setBackgroundImage(with: URL.init(string: model!.image!), for: .normal)
            
            self.setImage(UIImage.imageWithColor(color: UIColor.clear), for: .highlighted)
            self.kf.setBackgroundImage(with: URL.init(string: model!.image!), for: .highlighted)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setTitle(nil, for: .normal)
        
        self.addSubview(label)

        let centerX = NSLayoutConstraint.init(item: label, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0)
        let centerY = NSLayoutConstraint.init(item: label, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0)
        self.addConstraints([centerX, centerY])
        
        self.addTarget(self, action: #selector(MHCategoryBtn.touchUpInsideAction), for: .touchUpInside)
        self.addTarget(self, action: #selector(MHCategoryBtn.touchUpInsideAction), for: .touchDragOutside)
        self.addTarget(self, action: #selector(MHCategoryBtn.touchUpInsideAction), for: .touchCancel)
        
        self.addTarget(self, action: #selector(MHCategoryBtn.touchDown), for: .touchDown)
    }
    
    @objc private func touchDown() {
        label.alpha = 0
    }
    
    @objc private func touchUpInsideAction() {
        
        label.alpha = 1
    }

}
