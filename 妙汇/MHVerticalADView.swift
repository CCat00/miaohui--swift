//
//  MHVerticalADView.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/20.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

/// 垂直方向自动滚动的视图
class MHVerticalADView: UIView, UIScrollViewDelegate {
    
    // MARK: - Properties
    
    var pagingTimeInterval: TimeInterval = 3.0 {
        didSet {
        }
    }
    
    var contentViews: [UIView]? {
        didSet {
            // TODO:
            if contentViews == nil { return }
            
            contentView1.addSubview(contentViews![0])
            contentView1.tag = 0
            
            contentView2.addSubview(contentViews![1])
            contentView2.tag = 1
            
            contentView1.addConstranitToSubviewEquleToSelfBounds(toView: contentViews![0])
            contentView2.addConstranitToSubviewEquleToSelfBounds(toView: contentViews![1])
            
            self.startTimer()
        }
    }
    
    private var scrollView = UIScrollView.init()
    private var contentView1 = UIView.init()
    private var contentView2 = UIView.init()
    private var timer: Timer?
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        scrollView.delegate = self
        scrollView.isScrollEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.addSubview(contentView1)
        scrollView.addSubview(contentView2)
        self.addSubview(scrollView)
    }
    
    // MARK: - 
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.frame = self.bounds
        contentView1.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: frame.height)
        contentView2.frame = CGRect.init(x: 0, y: frame.height, width: frame.width, height: frame.height)
        scrollView.contentSize = CGSize.init(width: frame.width, height: frame.height * 2.0)
    }
    
    // MARK: - Private
    
    private func startTimer() {
        if timer == nil {
            timer = Timer.init(timeInterval: pagingTimeInterval, target: self, selector: #selector(MHVerticalADView.timerAction), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .commonModes)
        }
    }
    
    @objc private func timerAction() {
        self.updateContent()
    }
    
    private func updateContent() {
        scrollView.setContentOffset(CGPoint.init(x: 0, y: frame.height), animated: true)
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        contentView1.removeAllSubviews()
        contentView2.removeAllSubviews()
        
        contentView1.tag = contentView2.tag
        contentView2.tag = (contentView2.tag + 1) % contentViews!.count
        
        contentView1.addSubview(contentViews![contentView1.tag])
        contentView1.addConstranitToSubviewEquleToSelfBounds(toView: contentViews![contentView1.tag])
        
        contentView2.addSubview(contentViews![contentView2.tag])
        contentView2.addConstranitToSubviewEquleToSelfBounds(toView: contentViews![contentView2.tag])
        
        scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: false)
    }

}

extension UIView {
    // 1-> 3,4   2-> 5,6
    func allSubviews() -> [UIView] {
        var res = self.subviews //1,2   3,4
        for subview in self.subviews {
            // subview = 1
            let riz = subview.allSubviews()
            // riz = 3,4
            res.append(contentsOf: riz)
        }
        return res
    }
    
    func removeAllSubviews() {
        for subview in self.subviews {
            subview.removeFromSuperview()
        }
    }

    func addConstranitToSubviewEquleToSelfBounds(toView subview: UIView) {
        
        subview.translatesAutoresizingMaskIntoConstraints = false
        
        let topC = NSLayoutConstraint.init(item: subview, attribute: .top, relatedBy: .equal, toItem: self, attribute: .top, multiplier: 1.0, constant: 0)
        
        let leftC = NSLayoutConstraint.init(item: subview, attribute: .left, relatedBy: .equal, toItem: self, attribute: .left, multiplier: 1.0, constant: 0)
        
        let bottomC = NSLayoutConstraint.init(item: subview, attribute: .bottom, relatedBy: .equal, toItem: self, attribute: .bottom, multiplier: 1.0, constant: 0)
        
        let rightC = NSLayoutConstraint.init(item: subview, attribute: .right, relatedBy: .equal, toItem: self, attribute: .right, multiplier: 1.0, constant: 0)
        
        self.addConstraints([topC, leftC, bottomC, rightC])
    }
}









