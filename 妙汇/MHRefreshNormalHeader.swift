//
//  MHRefreshNormalHeader.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/21.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

class MHRefreshNormalHeader: MHRefreshHeader {
    
    @IBOutlet weak var refresh_arrow: UIImageView!
    @IBOutlet weak var refresh_indicator: UIActivityIndicatorView!
    
     override class func headerWithHandler(handler: MHRefreshHeaderBlock?) -> MHRefreshNormalHeader {
        let views = Bundle.main.loadNibNamed("MHRefreshNormalHeader", owner: nil, options: nil)
        let header = views!.last as! MHRefreshNormalHeader
        header.refreshHeaderBlock = handler
        return header
    }
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        refresh_indicator.isHidden = true
        refresh_arrow.isHidden = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = CGRect.init(x: MHRefreshHeaderX, y: MHRefreshHeaderY, width: Double(MHRefreshHeaderW), height: Double(MHRefreshHeaderH))
        /*
         <Â¶ôÊ±á.MHRefreshNormalHeader: 0x155671810; frame = (0 -40; 375 0); autoresize = W+H; layer = <CALayer: 0x1556032b0>>
         */
        // 15 40
        refresh_arrow.frame = CGRect.init(x: SCREEN_WIDTH / 2.0 - 15.0 / 2.0, y: self.bounds.height / 2.0 - 40.0 / 2.0, width: 15, height: 40)
        refresh_indicator.frame = CGRect.init(x: SCREEN_WIDTH / 2.0 - 20.0 / 2.0, y: self.bounds.height / 2.0 - 20.0 / 2.0, width: 20, height: 20)
    }
    
    // MARK: - Override
    
    override func changeRefreshState(state: MHRefreshState) {
        
        let oldState = refreshState
        //print("MHRefreshNormalHeader set state. oldState = \(oldState), state = \(state)")
        if state == oldState {
            return
        }
        super.changeRefreshState(state: state)
        
        if state == .normal {
            if oldState == .refreshing {
                refresh_arrow.transform = CGAffineTransform.identity
                UIView.animate(withDuration: MHRefreshAnimationDuration, animations: { 
                    
                    self.refresh_indicator.alpha = 0.0
                    
                    }, completion: { (com) in
                        
                        self.refresh_indicator.alpha = 1.0
                        self.refresh_indicator.stopAnimating()
                        self.refresh_arrow.isHidden = false
                })
            } else {
                self.refresh_indicator.stopAnimating()
                self.refresh_arrow.isHidden = false
                UIView.animate(withDuration: MHRefreshAnimationDuration, animations: { 
                    self.refresh_arrow.transform = CGAffineTransform.identity
                })
            }
        } else if state == .pulling {
            refresh_indicator.stopAnimating()
            refresh_arrow.isHidden = false
            UIView.animate(withDuration: MHRefreshAnimationDuration, animations: { 
                self.refresh_arrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
            })
        } else if state == .refreshing {
            refresh_indicator.alpha = 1.0
            refresh_indicator.startAnimating()
            refresh_arrow.isHidden = true
        }
    }
}
