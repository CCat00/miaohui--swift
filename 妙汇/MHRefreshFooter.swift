//
//  MHRefreshFooter.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/25.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

typealias MHRefreshFooterBlock = (MHRefreshFooter) -> Void

/// 上拉加载控件的基类
class MHRefreshFooter: MHRefreshBase {
    
    /// 上拉加载回调
    var refreshFooterBlock: MHRefreshFooterBlock?
    
    var automaticallyHidden: Bool = false
    
    
    
    // MARK: - Override 
    override func setup() {
        super.setup()
        self.frame.size.height = CGFloat(MHRefreshFooterH)
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        if (self.scrollView is UITableView) || (self.scrollView is UICollectionView) {
            
        }
        self.scrollViewContentSizeDidChange(change: nil)
    }
    
    override func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change: change)
        
        if refreshState == .refreshing { return }
        
        let currentOffsetY = scrollView!.contentOffset.y
        let willAppearFooterOffsetY = self.getWillAppearFooterOffsetY()
        
        if currentOffsetY <= willAppearFooterOffsetY { return }
        
        if refreshState == .noMoreData {
            return
        }
        
        if scrollView!.isDragging {
            let willRefreshOffsetY = willAppearFooterOffsetY + self.frame.size.height
            if refreshState == .normal && currentOffsetY > willRefreshOffsetY {
                self.changeRefreshState(state: .pulling)
                print("可以松手了")
            } else if refreshState == .pulling && currentOffsetY <= willRefreshOffsetY {
                self.changeRefreshState(state: .normal)
                print("回到原始状态")
            }
        } else if refreshState == .pulling {
            self.beginRefreshing()
            print("开始刷新")
        }

    }
    
    override func scrollViewContentSizeDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentSizeDidChange(change: change)
        
        let contentH = scrollView!.contentSize.height
        let scrollH = scrollView!.frame.size.height - scrollViewEdgeInsets!.top - scrollViewEdgeInsets!.bottom
        self.frame.origin.y = max(contentH, scrollH)
    }
    
    override func changeRefreshState(state: MHRefreshState) {
        let oldState = refreshState
        if oldState == state { return }
        super.changeRefreshState(state: state)
        
        if state == .normal || state == .noMoreData {
            // 刷新完毕
            if oldState == .refreshing {
                
                UIView.animate(withDuration: MHRefreshAnimationDuration, animations: { 
                
                    self.scrollView!.contentInset.bottom -= self.lastBottomDelta
                    
                    })
            }
            
            if oldState == .refreshing && deltaH > 0 && self.scrollView!.getTotalCount() != self.lastRefreshCount {
                self.scrollView!.contentOffset.y = self.scrollView!.contentOffset.y
            }
            
        } else if state == .refreshing {
            lastRefreshCount = scrollView!.getTotalCount()
            
            UIView.animate(
                withDuration: MHRefreshAnimationDuration,
                animations: {
                    
                    var bottom = self.frame.size.height + self.scrollViewEdgeInsets!.bottom
                    if self.deltaH < 0 {
                        bottom -= self.deltaH
                    }
                    self.lastBottomDelta = bottom - self.scrollView!.contentInset.bottom
                    self.scrollView!.contentInset.bottom = bottom
                    self.scrollView!.contentOffset.y = self.getWillAppearFooterOffsetY() + self.frame.size.height
                },
                completion: { (com) in
                    self.refreshFooterBlock?(self)
            })
        }
    }

    
    // MARK: - Public
    /// 创建一个footer控件
    ///
    /// - parameter handler: 回调
    ///
    /// - returns: footer
    class func footerWithHandler(handler: MHRefreshFooterBlock?) -> MHRefreshFooter? {
        return nil
    }

    func endRefreshingWithNoMoreData() {
        self.changeRefreshState(state: .noMoreData)
    }
    
    func resetNoMoreData() {
        self.changeRefreshState(state: .normal)
    }
    
    // MARK: - Private
    
    private var deltaH: CGFloat {
        let scrollViewRealH = scrollView!.frame.size.height - scrollViewEdgeInsets!.bottom - scrollViewEdgeInsets!.top
        return scrollView!.contentSize.height - scrollViewRealH
    }
    
    private func getWillAppearFooterOffsetY() -> CGFloat {
        
//        let scrollViewRealH = scrollView!.frame.size.height - scrollViewEdgeInsets!.bottom - scrollViewEdgeInsets!.top
//        let deltaH = scrollView!.contentSize.height - scrollViewRealH
        
        if deltaH > 0 {
            return deltaH - scrollViewEdgeInsets!.top
        } else {
            return -scrollViewEdgeInsets!.top
        }
    }
    
    private var lastRefreshCount = 0
    private var lastBottomDelta: CGFloat = 0
}






