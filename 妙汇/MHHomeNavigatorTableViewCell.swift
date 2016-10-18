//
//  MHHomeNavigatorTableViewCell.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/18.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

class MHHomeNavigatorTableViewCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionViewLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var models: [MHNavigator] = [] {
        didSet {
            let pageC = Int(models.count / 5) + 1
            pageControl.numberOfPages = pageC
            collectionView.reloadData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewLayout.itemSize = CGSize.init(width: SCREEN_WIDTH / 5.0, height: 100)
        collectionViewLayout.minimumLineSpacing = 0.0
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib.init(nibName: "MHNavItemCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MHNavItemCollectionViewCell")
        
        pageControl.pageIndicatorTintColor = UIColor.lightGray
        pageControl.currentPageIndicatorTintColor = UIColor.hexColor(hex: 0xEDB329)
    }

    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if !models.isEmpty {
            return models.count
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MHNavItemCollectionViewCell", for: indexPath) as! MHNavItemCollectionViewCell
        if !models.isEmpty {
            cell.model = models[indexPath.row]
        }
        return cell
    }
    
    // MARK: - 
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == collectionView {
            let page = Int(scrollView.contentOffset.x / SCREEN_WIDTH)
            pageControl.currentPage = page
        }
    }
    
}
