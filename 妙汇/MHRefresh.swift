//
//  MHRefresh.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/21.
//  Copyright © 2016年 韩威. All rights reserved.
//

import Foundation
import UIKit

private var REFRESH_HEADER_KEY = 0
private var REFRESH_FOOTER_KEY = 0

extension UIScrollView {
    
    // MARK: - Header
    
    func addRefreshHeader(header: MHRefreshHeader) {
        if self.refresh_header() != header {
            self.refresh_header()?.removeFromSuperview()
            self.addSubview(header)
            objc_setAssociatedObject(self, &REFRESH_HEADER_KEY, header, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func refresh_header() -> MHRefreshHeader? {
        let header = objc_getAssociatedObject(self, &REFRESH_HEADER_KEY) as? MHRefreshNormalHeader
        return header
    }
    
    // MARK: - Footer
    
    func addRefreshFooter(footer: MHRefreshFooter) {
        if self.refresh_footer() != footer {
            self.refresh_footer()?.removeFromSuperview()
            self.addSubview(footer)
            objc_setAssociatedObject(self, &REFRESH_FOOTER_KEY, footer, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    func refresh_footer() -> MHRefreshFooter? {
        let footer = objc_getAssociatedObject(self , &REFRESH_FOOTER_KEY) as? MHRefreshFooter
        return footer
    }
    
}

extension UIScrollView {
    
    func getTotalCount() -> Int {
        var totalCount = 0
        if self is UITableView {
            let tableView = self as! UITableView
            for section in 0..<tableView.numberOfSections {
                totalCount += tableView.numberOfRows(inSection: section)
            }
            return totalCount
        }
        else if self is UICollectionView {
            let collectionView = self as! UICollectionView
            for section in 0..<collectionView.numberOfSections {
                totalCount += collectionView.numberOfItems(inSection: section)
            }
            return totalCount
        }
        return totalCount
    }
}
