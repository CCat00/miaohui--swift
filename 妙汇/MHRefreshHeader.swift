//
//  MHRefreshHeader.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/21.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

typealias MHRefreshHeaderBlock = (MHRefreshHeader) -> Void

class MHRefreshHeader: MHRefreshBase {
    
    var refreshHeaderBlock: MHRefreshHeaderBlock?
    
    private var insetTDelta: CGFloat?
    
    // MARK: - Override
    
    override func beginRefreshing() {
        super.beginRefreshing()
        self.changeRefreshState(state: .refreshing)
    }
    
    override func changeRefreshState(state: MHRefreshState) {
//        print("MHRefreshHeader set state. oldState = \(refreshState), state = \(state)")
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
                    //TODO:处理回调
                    self.refreshHeaderBlock?(self as! MHRefreshNormalHeader)
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
    
    func endRefreshing() {
        self.changeRefreshState(state: .normal)
    }
}



