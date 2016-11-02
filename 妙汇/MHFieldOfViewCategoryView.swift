//
//  MHFieldOfViewCategoryView.swift
//  妙汇
//
//  Created by 韩威 on 2016/11/2.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

class MHFieldOfViewCategoryView: UIView {
    
    fileprivate lazy var segmentedControl: HMSegmentedControl = {
        let seg = HMSegmentedControl.init()
        seg.translatesAutoresizingMaskIntoConstraints = false
        seg.backgroundColor = UIColor.clear
        seg.selectionIndicatorColor = MH_MAIN_COLOR_YELLOW
        seg.selectionIndicatorLocation = .down
        seg.titleTextAttributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: 14)
        ]
        seg.selectionIndicatorHeight = 3.0
        seg.indexChangeBlock = { (index) in
            print("index is \(index)")
            //TODO:这里由于是抓的包，就不切换下面的网络数据了。
        }
        var names: [String] = []
        for nav in self.model.navigator! {
            names.append(nav.name!)
        }
        seg.sectionTitles = names
        return seg
    }()
    
    fileprivate lazy var arrowBgView: UIView = {
        let view = UIView.init()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.addSubview(self.arrowImgView)
        NSLayoutConstraint.activate(
            [self.arrowImgView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
             self.arrowImgView.centerYAnchor.constraint(equalTo: view.centerYAnchor)]
        )
        
        //点击手势，点击出现collectionview
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(MHFieldOfViewCategoryView.tapGes))
        view.addGestureRecognizer(tap)
        return view
    }()
    
    fileprivate lazy var arrowImgView: UIImageView = {
        let arrowImg = #imageLiteral(resourceName: "downTowardsArrow")
        let imgView = UIImageView.init(image: arrowImg)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    /// 数据
    var model: MHFieldOfViewCategoryResponse
    
    init(model: MHFieldOfViewCategoryResponse, maskViewBgView bgView: UIView?) {
        self.model = model
        self.maskViewBgView = bgView
        super.init(frame: CGRect.init())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        addSubview(segmentedControl)
        addSubview(arrowBgView)
    }
    
    override func updateConstraints() {
        
        /// 右侧的箭头视图
        NSLayoutConstraint.activate(
            [arrowBgView.rightAnchor.constraint(equalTo: rightAnchor),
             arrowBgView.topAnchor.constraint(equalTo: topAnchor),
             arrowBgView.bottomAnchor.constraint(equalTo: bottomAnchor),
             arrowBgView.widthAnchor.constraint(equalToConstant: 65.0)]
        )
        
        /// 滑动选择视图
        NSLayoutConstraint.activate(
            [segmentedControl.leftAnchor.constraint(equalTo: leftAnchor),
             segmentedControl.topAnchor.constraint(equalTo: topAnchor),
             segmentedControl.bottomAnchor.constraint(equalTo: bottomAnchor),
             segmentedControl.rightAnchor.constraint(equalTo: arrowBgView.leftAnchor)]
        )
        
        super.updateConstraints()
    }
    
    // MARK: - CollectionView部分
    
    /// collectionview是否展开
    var isOpen: Bool = false

    lazy var titleLabel: UILabel = {
       let label = UILabel.init()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "切换频道"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.hexColor(hex: 0x9c9c9c)
        return label
    }()
    /// 遮罩的父视图
    var maskViewBgView: UIView?
    /// 遮罩
    private lazy var maskView_black: UIView = {
        let view = UIView.init(frame: CGRect.init(x: self.selfX, y: self.selfB, width: self.selfW, height: SCREEN_HEIGHT - self.selfB))
        view.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).withAlphaComponent(0.3)
        view.addSubview(self.collectionView)
        
        let btn = UIButton.init(type: .custom)
        btn.backgroundColor = UIColor.clear
        btn.addTarget(self, action: #selector(MHFieldOfViewCategoryView.tapGes), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btn)
        
        NSLayoutConstraint.activate(
            [btn.leftAnchor.constraint(equalTo: view.leftAnchor),
             btn.topAnchor.constraint(equalTo: view.topAnchor, constant: self.collectionViewH),
             btn.rightAnchor.constraint(equalTo: view.rightAnchor),
             btn.bottomAnchor.constraint(equalTo: view.bottomAnchor)]
        )
        
        return view
    }()
    private let itemSpacing: CGFloat = 0.5
    private let columns = 5
    private var itemSize: CGSize {
        let width: CGFloat = (selfW - CGFloat(columns - 1) * itemSpacing) / CGFloat(columns)
        let height: CGFloat = 37
        return CGSize.init(width: width, height: height)
    }
    private var collectionViewH: CGFloat {
        
        var lines = 0
        if model.navigator!.count % columns == 0 {
            lines = model.navigator!.count / columns
        } else {
            lines = model.navigator!.count / columns + 1
        }
        return CGFloat(lines) * itemSize.height + CGFloat(lines - 1) * itemSpacing
    }
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.itemSize = self.itemSize
        layout.minimumLineSpacing = self.itemSpacing
        layout.minimumInteritemSpacing = self.itemSpacing
        let frame = CGRect.init(x: self.selfX, y: 0, width: self.selfW, height: 0)
        let collectionView = UICollectionView.init(frame: frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = #colorLiteral(red: 0.8862745098, green: 0.8862745098, blue: 0.8862745098, alpha: 1)
        collectionView.register(UINib.init(nibName: "MHFOVCategoryCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "MHFOVCategoryCollectionViewCell")
        return collectionView
    }()
    
    
    @objc fileprivate func tapGes() {
        
        if isOpen {
            //隐藏
            
            UIView.animate(withDuration: 0.3,
                           animations: {
                            
                            self.arrowImgView.transform = CGAffineTransform.identity
                            self.collectionView.selfH = 0
                            
                },
                           completion: { (_) in
                            self.maskView_black.alpha = 0
                            self.maskView_black.removeFromSuperview()
                            self.isOpen = false
                            self.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9607843137, blue: 0.9607843137, alpha: 1)
                            self.segmentedControl.isHidden = false
                            self.titleLabel.removeFromSuperview()
            })
            
            
        } else {
            //展开
            maskView_black.alpha = 1
            maskViewBgView?.addSubview(maskView_black)
            
            collectionView.selectItem(at: IndexPath.init(row: segmentedControl.selectedSegmentIndex, section: 0), animated: false, scrollPosition: .bottom)
            
            self.backgroundColor = #colorLiteral(red: 0.9019607843, green: 0.9019607843, blue: 0.9019607843, alpha: 1)
            self.segmentedControl.isHidden = true
            addSubview(titleLabel)
            NSLayoutConstraint.activate(
                [titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                 titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15)]
            )
            
            
            UIView.animate(withDuration: 0.3,
                           animations: { 
                            
                            self.arrowImgView.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                           self.collectionView.selfH = self.collectionViewH
                            
                },
                           completion: { (_) in
                            
                            self.isOpen = true
            })
            
        }
        
    }
    
}

extension MHFieldOfViewCategoryView: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.navigator!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MHFOVCategoryCollectionViewCell", for: indexPath) as!MHFOVCategoryCollectionViewCell
        cell.model = model.navigator![indexPath.row]
        return cell
    }
}

extension MHFieldOfViewCategoryView: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let allSelctedIndexPath = collectionView.indexPathsForSelectedItems
        
        for selectedIndexPath in allSelctedIndexPath! {
            collectionView.deselectItem(at: selectedIndexPath, animated: true)
        }
        
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
        
        self.segmentedControl.selectedSegmentIndex = indexPath.row
        self.tapGes()
    }
}


