//
//  MHRefreshNormalFooter.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/25.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

class MHRefreshNormalFooter: MHRefreshFooter {
    
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var arrow: UIImageView!
    
    override class func footerWithHandler(handler: MHRefreshFooterBlock?) -> MHRefreshFooter {
        
        let views = Bundle.main.loadNibNamed("MHRefreshNormalFooter", owner: nil, options: nil)
        let footer = views!.last as! MHRefreshNormalFooter
        footer.refreshFooterBlock = handler
        return footer
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.indicator.isHidden = true
        self.arrow.isHidden = false
        
        self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        self.stateLabel.text = "上拉加载更多"
//        self.stateLabel.backgroundColor = UIColor.red
    }
    
    override func placesSubviews() {
        super.placesSubviews()
        
        self.frame.size.width = SCREEN_WIDTH
        self.frame.size.height = CGFloat(MHRefreshFooterH)
        
        let labelSize = self.getLabelSize()
        let margin: CGFloat = 10.0
        
        let allW = 20.0 + margin + labelSize.width
        
        let x = self.frame.size.width / 2.0 - allW / 2.0
        
        self.arrow.frame = CGRect.init(x: x, y: 0, width: 15, height: 40)
        self.indicator.frame = CGRect.init(x: x, y: 10, width: 20, height: 20)
        
        let labelX = x + 20.0 + margin
        self.stateLabel.frame = CGRect.init(x: labelX, y: 10, width: labelSize.width + 1.0, height: 20)
    }
    
    override func changeRefreshState(state: MHRefreshState) {
        let oldState = refreshState
        if oldState == state { return }
        super.changeRefreshState(state: state)

        if state == .normal {
            if oldState == .refreshing {

                self.indicator.stopAnimating()
                self.arrow.isHidden = false
                
            }
//            else {
//                self.indicator.isHidden = true
//                self.arrow.isHidden = false
//                self.indicator.stopAnimating()
//            }
            UIView.animate(withDuration: MHRefreshAnimationDuration, animations: {
                self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            })
            self.stateLabel.text = "上拉加载更多"
            self.placesSubviews()
            
        } else if state == .pulling {
            self.arrow.isHidden = false
            self.indicator.stopAnimating()
            self.stateLabel.text = "松手即可刷新"
            self.placesSubviews()
            UIView.animate(withDuration: MHRefreshAnimationDuration, animations: { 
                self.arrow.transform = CGAffineTransform.identity
            })
            
        } else if state == .refreshing {
            
            self.indicator.isHidden = false
            self.arrow.isHidden = true
            self.indicator.startAnimating()
            self.stateLabel.text = "正在加载数据"
            self.placesSubviews()
            self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            
        } else if state == .noMoreData {
            
            self.indicator.stopAnimating()
            self.arrow.isHidden = true
            self.stateLabel.text = "没有更多数据"
            self.placesSubviews()
            self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
    }
    
    private func getLabelSize() -> CGSize {
        let content = NSString.init(string: self.stateLabel.text!)
        let size = CGSize.init(width: 1000, height: 1000)
        let rect = content.boundingRect(with: size, options: [.usesLineFragmentOrigin,], attributes: [NSFontAttributeName : UIFont.systemFont(ofSize: 15)], context: nil)
        return rect.size
    }
}
