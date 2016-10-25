//
//  MHRefreshBase.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/21.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

/// 刷新控件的基类
class MHRefreshBase: UIView {
    
    // MARK: - Properties
    
    var refreshState: MHRefreshState = .normal
    var scrollView: UIScrollView?
    var scrollViewEdgeInsets: UIEdgeInsets?

    // MARK: - Life cycle
    
    // MARK: - Life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        
    }


    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        
        if (newSuperview != nil) && !(newSuperview is UIScrollView) { return }
        
        scrollView = newSuperview! as? UIScrollView
        scrollView!.bounces = true
        
        scrollViewEdgeInsets = scrollView!.contentInset
        
//        self.removeObservers()
        
        self.frame.size.width = (newSuperview?.frame.size.width)!
        self.frame.origin.x = 0.0
        
        self.addObservers()

    }
    
    // MARK: - Private
    
    private func addObservers() {
        scrollView!.addObserver(self, forKeyPath: MHRefreshKeyPathContentOffset, options: [.new, .old], context: &MHRefreshKeyPathContentOffsetContext)
        scrollView!.addObserver(self, forKeyPath: MHRefreshKeyPathContentSize, options: [.new, .old], context: &MHRefreshKeyPathContentSizeContext)
        
    }
    
    private func removeObservers() {
        
        scrollView!.removeObserver(self, forKeyPath: MHRefreshKeyPathContentOffset, context: &MHRefreshKeyPathContentOffsetContext)
        scrollView!.removeObserver(self, forKeyPath: MHRefreshKeyPathContentSize, context: &MHRefreshKeyPathContentSizeContext)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.placesSubviews()
    }
    
    // MARK: - KVO
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if !self.isUserInteractionEnabled { return }
        
        if self.isHidden { return }
        
        if keyPath == MHRefreshKeyPathContentOffset {
            self.scrollViewContentOffsetDidChange(change: change)
        } else if keyPath == MHRefreshKeyPathContentSize {
            self.scrollViewContentSizeDidChange(change: change)
        }
        
    }
    
    // MARK: -
    
    func placesSubviews() { }
    
    func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) { }
    func scrollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) { }
    
    func changeRefreshState(state: MHRefreshState) {
        refreshState = state
    }
    
    func beginRefreshing() {
        UIView.animate(withDuration: MHRefreshAnimationDuration) { 
            self.alpha = 1.0
        }
        self.changeRefreshState(state: .refreshing)
    }
    
    func endRefreshing() {
        self.changeRefreshState(state: .normal)
    }

    
}



