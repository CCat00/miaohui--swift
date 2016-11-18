//
//  MHRefreshHeader.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/21.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

typealias MHRefreshHeaderBlock = (MHRefreshHeader) -> Void

/// 下拉控件的基类
class MHRefreshHeader: MHRefreshBase {
    
    /// 下拉刷新回调
    var refreshHeaderBlock: MHRefreshHeaderBlock?
    
    /// 偏移header的高度
    private var insetTDelta: CGFloat?
    
    class func headerWithHandler(handler: MHRefreshHeaderBlock?) -> MHRefreshHeader? {
        return nil
    }
    
    // MARK: - Override
    
    /// 开始刷新
    override func beginRefreshing() {
        super.beginRefreshing()
    }
    
    override func changeRefreshState(state: MHRefreshState) {
        //print("MHRefreshHeader set state. oldState = \(refreshState), state = \(state)")
        if (state == .normal) && (refreshState != .refreshing) {
            super.changeRefreshState(state: state)
            return
        }
        
        super.changeRefreshState(state: state)
        
        if state == .normal {
            
            //从刷新状态恢复到初始状态
            UIView.animate(
                withDuration: MHRefreshAnimationDuration,
                animations: {
                    // FIXME:  insetTDelta 有时是nil
                    self.scrollView!.contentInset.top += self.insetTDelta!
                },
                completion: { (completed) in
                    
            })
            
        } else if refreshState == .refreshing {
            
            UIView.animate(
                withDuration: MHRefreshAnimationDuration,
                animations: {
                    let top = (self.scrollViewEdgeInsets?.top)! + self.frame.size.height
                    self.scrollView!.contentInset.top = top
                    self.scrollView!.setContentOffset(CGPoint.init(x: 0, y: -top), animated: false)
                },
                completion: { (completed) in
                    // 处理回调
                    self.refreshHeaderBlock?(self)
            })
            
        }
    }

    override func scrollViewContentOffsetDidChange(change: [NSKeyValueChangeKey : Any]?) {
        super.scrollViewContentOffsetDidChange(change: change)
        
        if refreshState == .refreshing {
            //正在刷新状态
            if self.window == nil { return }
            
            var insetT = max(-scrollView!.contentOffset.y, scrollViewEdgeInsets!.top)
            insetT = min(insetT, self.frame.size.height + scrollViewEdgeInsets!.top)
            scrollView!.contentInset.top = insetT
            
            insetTDelta = scrollViewEdgeInsets!.top - insetT
            return
        }
        
        scrollViewEdgeInsets = scrollView!.contentInset
        
        // scrollview的初始状态偏移量
        let normalOffsetY = -scrollViewEdgeInsets!.top
        // 当前的偏移量
        let offsetY = scrollView!.contentOffset.y
        
        //向上滑动
        if offsetY > normalOffsetY { return }
        
        // 普通 和 即将刷新 的临界点。（就是：下拉到，header完全展示的时候）
        let willRefreshOffsetY = normalOffsetY - self.frame.size.height
        
        if scrollView!.isDragging {
            //正在拽
            if (refreshState == .normal) && (offsetY < willRefreshOffsetY) {
                self.changeRefreshState(state: .pulling)
                print("松手即可刷新")
            }
            else if (refreshState == .pulling) && (offsetY >= willRefreshOffsetY) {
                self.changeRefreshState(state: .normal)
                print("回到初始状态")
            }
        }
        else if (refreshState == .pulling) {
            print("即将刷新！！（偏移量够 && 手松开了）")
            self.beginRefreshing()
        }
    }
    
    // MARK: - Public
    
    }



