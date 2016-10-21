//
//  MHHomePromotionsItem.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/19.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit
import Kingfisher

enum CountDownType {
    case title
    case bottom
}

/// 促销商品的一个item
class MHHomePromotionsItem: UIView {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var bottomLabel: UILabel!
    
    var timer: Timer?
    
    var countdownType = CountDownType.bottom
    
    var pro: MHPromotion? {
        didSet {
            if pro == nil { return }
            
            if oldValue != nil { return } //滚动tableview的情况 // TODO:这里可能会出现，下拉刷新的时候，不应return，先这样写吧！！
            
            name.text = pro!.ad_name
            
            imageView.kf.setImage(with: URL.init(string: pro!.ad_code!))
            
            restTime = Int(pro!.end_time!)! - Int(pro!.server_time!)!
            
            if pro!.promote_price != nil { // 有价格：title显示倒计时，bottom显示价格
                
                countdownType = .title
                
                let attributedText = NSMutableAttributedString.init(
                    string: "¥" + pro!.promote_price! + "  ",
                    attributes: [
                        NSFontAttributeName : UIFont.boldSystemFont(ofSize: 12.0),
                        NSForegroundColorAttributeName: UIColor.rgbColor(r: 222.0, g: 43.0, b: 48.0),
                        ])
                
                let oldPrice = NSAttributedString.init(
                    string: " ¥" + pro!.shop_price!,
                    attributes: [
                        NSFontAttributeName : UIFont.systemFont(ofSize: 11.0),
                        NSForegroundColorAttributeName: UIColor.rgbColor(r: 178, g: 178, b: 178),
                        NSStrikethroughStyleAttributeName : NSNumber.init(value: NSUnderlineStyle.styleSingle.rawValue),
                        NSStrikethroughColorAttributeName : UIColor.rgbColor(r: 178, g: 178, b: 178)
                    ])
                
                attributedText.append(oldPrice)
                
                bottomLabel.attributedText = attributedText
                
                self.showCountdown()
            }
            else { // 无价格：title显示title，bottom显示倒计时
                
                countdownType = .bottom
                
                title.text = pro!.ad_title
                
                self.showCountdown()
                
            }
        }
    }
    
    private func showCountdown() {
        if timer != nil {
            timer!.invalidate()
            timer = nil
        }
        timer = Timer.init(timeInterval: 1, target: self, selector: #selector(MHHomePromotionsItem.timerAction), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
    }
    
    @objc private func timerAction() {
        if pro == nil { return }
        restTime! -= 1
        
        if countdownType == .bottom {
            bottomLabel.attributedText = jointCountdownString()
        } else {
            title.attributedText = jointCountdownString()
        }
    }
    
    var restTime: Int?
    
    private func jointCountdownString() -> NSAttributedString{
        
        if restTime! <= 0 {
            
            let endString = NSAttributedString.init(
                string: "已结束",
                attributes: [
                    NSFontAttributeName : UIFont.systemFont(ofSize: 11.0),
                    NSForegroundColorAttributeName: UIColor.rgbColor(r: 178, g: 178, b: 178),
                ])
            return endString
        }
        
        let attributedText = NSMutableAttributedString.init(
            string: "距离结束  ",
            attributes: [
                NSFontAttributeName : UIFont.systemFont(ofSize: 12.0),
                NSForegroundColorAttributeName: UIColor.rgbColor(r: 109, g: 109, b: 109)])
        
        let timeString = turnToTime(with: TimeInterval(restTime!))
        
        let countdonwColor = countdownType == .title ? UIColor.black : UIColor.rgbColor(r: 252, g: 187, b: 53)
        attributedText.append(NSAttributedString.init(
            string: timeString,
            attributes: [
                NSFontAttributeName : UIFont.boldSystemFont(ofSize: 11.0),
                NSForegroundColorAttributeName: countdonwColor
            ]))
        return attributedText
    }
    
    private func turnToTime(with timestmp: TimeInterval) -> String{
        
        if timestmp > (24*60*60) {
            //大于一天
            return "\(Int(timestmp / (24*60*60)))天"
        }
        
        let hours = Int(timestmp/(60.0*60.0))
        let minutes = Int((timestmp - TimeInterval(hours*60*60))/60)
        let seconds = Int(timestmp) - hours*60*60 - minutes*60
        
        let dateString = "\(hours.format(f: "02")):\(minutes.format(f: "02")):\(seconds.format(f: "02"))"
    
        return dateString
    }
}

extension Int {
    func format(f: String) -> String {
        return String(format: "%\(f)d", self)
    }
}
