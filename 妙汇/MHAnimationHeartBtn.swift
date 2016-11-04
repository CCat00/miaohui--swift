//
//  MHAnimationHeartBtn.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/25.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

class MHAnimationHeartBtn: UIButton {
    
    private lazy var bigRedHeart: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "heart"))
        //imageView.frame = CGRect.init(x: 0, y: 0, width: 30, height: 30)
        return imageView
    }()
    
    private lazy var heart_broken_left: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "heart-broken01"))
        return imageView
    }()
    
    private lazy var heart_broken_right: UIImageView = {
        let imageView = UIImageView.init(image: UIImage.init(named: "heart-broken02"))
        return imageView
    }()

    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        
        self.setImage(UIImage.init(named: "unheart"), for: .normal)
        self.setImage(UIImage.init(named: "heart"), for: .selected)
        
        self.addTarget(self, action: #selector(MHAnimationHeartBtn.touchAction), for: .touchUpInside)
    }

    @objc func touchAction() {
        
        if superview == nil {
            return
        }
        
        if !self.isSelected {
            //灰色->红色。
            self.showBigHeart()
        } else {
            self.heartBrokenAndFallDown()
        }
        
        self.isSelected = !self.isSelected
    }
    
    private func showBigHeart() {
        
        bigRedHeart.frame = CGRect.init(
            x: frame.minX - (bigRedHeartStartW - frame.width) / 2.0,
            y: frame.minY - bigRedHeartStartH - topMargin,
            width: bigRedHeartStartW,
            height: bigRedHeartStartH)
        
        bigRedHeart.alpha = 0
        if (bigRedHeart.superview != nil) {
            bigRedHeart.removeFromSuperview()
        }
        superview?.addSubview(bigRedHeart)
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseOut,
                       animations: {
                        
                        self.bigRedHeart.alpha = 0.6
                        self.bigRedHeart.frame.origin.y -= self.moveY
                        self.bigRedHeart.frame.origin.x -= (self.bigRedHeartEndW - self.bigRedHeartStartW) / 2.0
                        self.bigRedHeart.frame.size = CGSize.init(width: self.bigRedHeartEndW, height: self.bigRedHeartEndH)
                        
            },
                       completion: { (com) in
                        
                        UIView.animate(withDuration: 0.2, animations: {
                            self.bigRedHeart.alpha = 0
                            }, completion: { (_) in
                                self.bigRedHeart.removeFromSuperview()
                        })

        })

    }
    
    private func heartBrokenAndFallDown() {
        
        superview?.addSubview(heart_broken_left)
        superview?.addSubview(heart_broken_right)
        
        self.heart_broken_left.alpha = 1
        self.heart_broken_right.alpha = 1
        
        let scale: CGFloat = 0.7
        
        heart_broken_left.frame.size.width = 24.0 * scale
        heart_broken_left.frame.size.height = 38.0 * scale
        heart_broken_left.frame.origin.x = self.frame.minX - (heart_broken_left.frame.width - self.frame.width / 2.0)
        heart_broken_left.frame.origin.y = frame.minY - bigRedHeartEndH - topMargin
        
        heart_broken_right.frame.size.width = 24.0 * scale
        heart_broken_right.frame.size.height = 38.0 * scale
        heart_broken_right.frame.origin.x = heart_broken_left.frame.maxX - 5.0
        heart_broken_right.frame.origin.y = heart_broken_left.frame.minY
        
        
        
        
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: UIViewAnimationOptions.curveEaseIn,
                       animations: {
                        
                        // 下降
                        self.heart_broken_left.frame.origin.y += 20.0
                        self.heart_broken_right.frame.origin.y += 20.0
                        
                        // 分开
                        self.heart_broken_left.frame.origin.x -= 7
                        self.heart_broken_right.frame.origin.x += 7
                        
                        
                        //缩小
                        self.heart_broken_left.frame.size = CGSize.init(width: 24.0 * 0.4, height: 38 * 0.4)
                        self.heart_broken_right.frame.size = CGSize.init(width: 24.0 * 0.4, height: 38 * 0.4)
                        
                        // 旋转
                        self.heart_broken_left.transform = CGAffineTransform(rotationAngle: -CGFloat.pi*0.3)
                        self.heart_broken_right.transform = CGAffineTransform(rotationAngle: CGFloat.pi*0.3)
                        
                        
            },
                       completion: { (_) in
                        
                        self.heart_broken_left.alpha = 0
                        self.heart_broken_right.alpha = 0
                        
                        self.heart_broken_left.transform = CGAffineTransform.identity
                        self.heart_broken_right.transform = CGAffineTransform.identity

                        self.heart_broken_left.removeFromSuperview()
                        self.heart_broken_right.removeFromSuperview()
    
    })
        
    }
    
    /// 初始大小
    private var bigRedHeartStartW: CGFloat = 15
    private var bigRedHeartStartH: CGFloat {
        return bigRedHeartStartW
    }
    
    /// 初始间距
    private var topMargin: CGFloat = 15.0
    /// 上移的距离
    private var moveY: CGFloat = 35.0
    
    /// 结束大小
    private var bigRedHeartEndW: CGFloat = 35.0
    private var bigRedHeartEndH: CGFloat {
        return bigRedHeartEndW
    }
    
    
    
}
