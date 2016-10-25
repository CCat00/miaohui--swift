//
//  MHRefreshBase.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/21.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit


//typealias MHRefreshFooterBlock = (MHRefreshNormalHeader) -> Void

/// 刷新控件的基类
class MHRefreshBase: UIView {
    
    // MARK: - Properties
    
    var refreshState: MHRefreshState = .normal
    var scrollView: UIScrollView?
    var scrollViewEdgeInsets: UIEdgeInsets?

    
    // MARK: - Life cycle

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
        
    }
    
    private func removeObservers() {
        
        scrollView!.removeObserver(self, forKeyPath: MHRefreshKeyPathContentOffset, context: &MHRefreshKeyPathContentOffsetContext)
    }
    
    // MARK: - Layout
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - KVO
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if !self.isUserInteractionEnabled { return }
        
        if self.isHidden { return }
        
        if keyPath == MHRefreshKeyPathContentOffset {
            self.scrollViewContentOffsetDidChange(change: change)
        }
        
    }
    
    // MARK: -
    
    func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        
    }
    
    func changeRefreshState(state: MHRefreshState) {
        refreshState = state
    }
    
    func beginRefreshing() {
        UIView.animate(withDuration: MHRefreshAnimationDuration) { 
            self.alpha = 1.0
        }
    }
    
}



