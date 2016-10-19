//
//  MHADScrollView.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/19.
//  Copyright © 2016年 韩威. All rights reserved.
//

let defaultBackgroundColor = UIColor.init(red: 178.0/255.0, green: 178.0/255.0, blue: 178.0/255.0, alpha: 1.0)
let pageControlEachWidth = 16.0
let pageControlHeight = 37.0

import UIKit
import Kingfisher

enum MHADScrollViewPageControlPosition {
    case bottomCenter
    case bottomRight
}

protocol MHADScrollViewDelegate: NSObjectProtocol {
    
}

class MHADScrollView: UIView, UIScrollViewDelegate{
    
    // MARK: - Properties
    
    // UIPageControl
    var pageControlPosition: MHADScrollViewPageControlPosition = .bottomCenter {
        didSet {
            self.layoutSubviews()
        }
    }
    var currentPageIndicatorTintColor: UIColor? {
        didSet {
            pageControl?.currentPageIndicatorTintColor = currentPageIndicatorTintColor
        }
    }
    var pageIndicatorTintColor: UIColor? {
        didSet {
            pageControl?.pageIndicatorTintColor = pageIndicatorTintColor
        }
    }
    
    // Timer
    var autoPaging: Bool = true {
        didSet {
            if autoPaging {
                self.startTimer()
            }
        }
    }
    var pagingTimeInterval: TimeInterval = 2.0 {
        didSet {
            if autoPaging {
                self.startAutoPaging()
            }
        }
    }
    
    // Image
    var imageUrls: [String]? {
        didSet {
            var tempImages: [UIImage] = []
            for url in imageUrls! {
                ImageDownloader(name: "adScrollView").downloadImage(with: URL.init(string: url)!, options: nil, progressBlock: nil, completionHandler: { (image, error, url_url, data) in
                    tempImages.append(image!)
                    self.images = tempImages
                })
            }
        }
    }
    var images: [UIImage] = [] {
        didSet {
            currentImageView?.image = images[0]
            currentImageView?.tag = 0
            
            if images.count > 1 {
                leftImageView?.image = images[images.count - 1]
                leftImageView?.tag = images.count - 1
                rightImageView?.image = images[1]
                rightImageView?.tag = 1
            }
            
            //设置页数
            pageControl?.numberOfPages = images.count
            
            // 设置显示中间的图片
            let imageViewW = scrollView?.bounds.size.width
            scrollView?.setContentOffset(CGPoint.init(x: imageViewW!, y: 0), animated: false)
            
            // 设置UIPageControl位置
            self.setPageControlPosition()
            
            // 图片过少不能拖动
            scrollView?.isScrollEnabled = !(images.count <= 1);
            
            if autoPaging {
                self.startTimer()
            }
        }
    }
    
    weak var delegate: MHADScrollViewDelegate?
    
    private var scrollView: UIScrollView?
    private var pageControl: UIPageControl?
    private var leftImageView: UIImageView?
    private var currentImageView: UIImageView?
    private var rightImageView: UIImageView?
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
        scrollView = UIScrollView.init()
        scrollView?.showsVerticalScrollIndicator = false
        scrollView?.showsHorizontalScrollIndicator = false
        scrollView?.isScrollEnabled = false
        scrollView?.isPagingEnabled = true
        scrollView?.bounces = false
        scrollView?.delegate = self
        
        pageControl = UIPageControl.init()
        pageControl?.hidesForSinglePage = true
        
        self.addSubview(scrollView!)
        self.addSubview(pageControl!)
        
        // UIImageView
        leftImageView = UIImageView.init()
        leftImageView?.contentMode = .scaleAspectFill
        leftImageView?.backgroundColor = defaultBackgroundColor
        
        currentImageView = UIImageView.init()
        currentImageView?.contentMode = .scaleAspectFill
        currentImageView?.backgroundColor = defaultBackgroundColor

        rightImageView = UIImageView.init()
        rightImageView?.contentMode = .scaleAspectFill
        rightImageView?.backgroundColor = defaultBackgroundColor

        self.scrollView?.addSubview(leftImageView!)
        self.scrollView?.addSubview(currentImageView!)
        self.scrollView?.addSubview(rightImageView!)
        
        // Tap
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(MHADScrollView.tap(tapGes:)))
        currentImageView?.isUserInteractionEnabled = true
        currentImageView?.addGestureRecognizer(tap)
    }
    
    // MARK: - TapGes
    @objc private func tap(tapGes: UITapGestureRecognizer) {
        
    }
    
    // MARK: -
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView?.frame = self.bounds
        
        let imageViewW = scrollView?.bounds.size.width
        let imageViewH = scrollView?.bounds.size.height
        
        leftImageView?.frame = CGRect.init(x: 0, y: 0, width: imageViewW!, height: imageViewH!)
        currentImageView?.frame = CGRect.init(x: imageViewW!, y: 0, width: imageViewW!, height: imageViewH!)
        rightImageView?.frame = CGRect.init(x: imageViewW! * 2.0, y: 0, width: imageViewW!, height: imageViewH!)
        
        scrollView?.contentSize = CGSize.init(width: imageViewW! * 3, height: imageViewH!)
        
        self.setPageControlPosition()
        
        self.updateContent()
    }
    
    // MARK: - Private
    private func setPageControlPosition() {
        var pageControlCenterX = 0.0 ,pageControlCenterY = 0.0
        if pageControlPosition == .bottomCenter {
            pageControlCenterX = Double(self.bounds.size.width) / 2.0
        } else {
            pageControlCenterX = Double(self.bounds.size.width) - Double(max((images.count)
                , (imageUrls?.count)!)) * pageControlEachWidth / 2.0
        }
        pageControlCenterY = Double(self.bounds.size.height) - pageControlHeight / 4.0
        pageControl?.center = CGPoint.init(x: pageControlCenterX, y: pageControlCenterY)
    }
    
    private func updateContent() {
        let imageViewW = scrollView!.bounds.size.width
        
        guard images.count > 1 else {
            return
        }
        
        if scrollView!.contentOffset.x > imageViewW {
            //左滑
            leftImageView!.tag = currentImageView!.tag
            currentImageView!.tag = rightImageView!.tag
            rightImageView!.tag = (rightImageView!.tag + 1) % (images.count)
        }
        
        if scrollView!.contentOffset.x < imageViewW {
            //右滑
            rightImageView!.tag = currentImageView!.tag
            currentImageView!.tag = leftImageView!.tag
            leftImageView!.tag = (leftImageView!.tag - 1 + images.count) % (images.count)
        }
        
        leftImageView?.image = images[leftImageView!.tag]
        currentImageView?.image = images[currentImageView!.tag]
        rightImageView?.image = images[rightImageView!.tag]
        
        scrollView?.setContentOffset(CGPoint.init(x: imageViewW, y: 0), animated: false)
    }
    
    private func startTimer() {
        guard (images.count) > 1 else {
            return
        }
        
        if timer == nil {
            timer = Timer.init(timeInterval: pagingTimeInterval, target: self, selector: #selector(MHADScrollView.timerAction), userInfo: nil, repeats: true)
            RunLoop.current.add(timer!, forMode: .commonModes)
        }
    }
    
    private func stopTimer() {
        if (timer != nil) {
            timer?.invalidate()
            timer = nil
        }
    }
    
    private func startAutoPaging() {
        self.stopTimer()
        self.autoPaging = true
        self.startTimer()
    }
    
    @objc private func timerAction() {
        if scrollView?.contentOffset.x != 0 {
            scrollView?.setContentOffset(CGPoint.init(x: scrollView!.bounds.size.width * 2.0, y: 0.0), animated: true)
        }
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard images.count > 1 else {
            return
        }
        
        let scrollViewW = scrollView.bounds.size.width
        
        if scrollView.contentOffset.x > scrollViewW * 1.5 {
            pageControl?.currentPage = rightImageView!.tag
        } else if scrollView.contentOffset.x < scrollViewW * 0.5 {
            pageControl?.currentPage = leftImageView!.tag
        } else {
            pageControl?.currentPage = currentImageView!.tag
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateContent()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.updateContent()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if autoPaging {
            timer?.invalidate()
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoPaging {
            self.startTimer()
        }
    }
}

















