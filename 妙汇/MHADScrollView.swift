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

enum MHADScrollViewImageType {
    case local
    case network
}

@objc protocol MHADScrollViewDelegate: NSObjectProtocol {
    @objc optional func didClickImage(index: Int, view: MHADScrollView) -> Void
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
    var pagingTimeInterval: TimeInterval = 3.0 {
        didSet {
            if autoPaging {
                self.startAutoPaging()
            }
        }
    }
    
    // Image
    var imageType: MHADScrollViewImageType = .local
    
    var imageUrls: [String]? {
        didSet {
            imageType = .network
            self.initImageContent()
        }
    }
    var images: [UIImage]? {
        didSet {
            imageType = .local
            self.initImageContent()
        }
    }
    
    weak var delegate: MHADScrollViewDelegate?
    
    private var scrollView: UIScrollView?
    private var pageControl: UIPageControl?
    private var leftImageView: UIImageView?
    private var currentImageView: UIImageView?
    private var rightImageView: UIImageView?
    private var timer: Timer?
    private var imgCount: Int {
        get {
            let imgCount = self.imageType == .local ? images!.count : imageUrls!.count
            return imgCount
        }
    }
    private var imageViewW: CGFloat {
        get {
            return self.scrollView!.bounds.size.width
        }
    }
    private var imageViewH: CGFloat {
        get {
            return self.scrollView!.bounds.size.height
        }
    }
    
    
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
        //scrollView?.backgroundColor = UIColor.red
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
        leftImageView?.clipsToBounds = true
        leftImageView?.contentMode = .scaleAspectFill
        leftImageView?.backgroundColor = defaultBackgroundColor
        //leftImageView?.layer.masksToBounds = true
        
        currentImageView = UIImageView.init()
        currentImageView?.clipsToBounds = true
        currentImageView?.contentMode = .scaleAspectFill
        currentImageView?.backgroundColor = defaultBackgroundColor
        //currentImageView?.layer.masksToBounds = true
        
        rightImageView = UIImageView.init()
        rightImageView?.clipsToBounds = true
        rightImageView?.contentMode = .scaleAspectFill
        rightImageView?.backgroundColor = defaultBackgroundColor
        //rightImageView?.layer.masksToBounds = true
        
        self.scrollView?.addSubview(leftImageView!)
        self.scrollView?.addSubview(currentImageView!)
        self.scrollView?.addSubview(rightImageView!)
        
        // Tap
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(MHADScrollView.tap(tapGes:)))
        currentImageView?.isUserInteractionEnabled = true
        currentImageView?.addGestureRecognizer(tap)
        
        scrollView?.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: nil)
    }
    
    // MARK: - TapGes
    @objc private func tap(tapGes: UITapGestureRecognizer) {
        delegate?.didClickImage!(index: currentImageView!.tag, view: self)
    }
    
    // MARK: -
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView?.frame = self.bounds
        
        leftImageView?.frame = CGRect.init(x: 0, y: 0, width: imageViewW, height: imageViewH)
        currentImageView?.frame = CGRect.init(x: imageViewW, y: 0, width: imageViewW, height: imageViewH)
        rightImageView?.frame = CGRect.init(x: imageViewW * 2.0, y: 0, width: imageViewW, height: imageViewH)
        
        scrollView?.contentSize = CGSize.init(width: imageViewW * 3, height: imageViewH)
        
        self.setPageControlPosition()
        
        // 设置显示中间的图片
        scrollView?.setContentOffset(CGPoint.init(x: imageViewW, y: 0), animated: false)
    }
    
    // MARK: - Private
    private func initImageContent() {
        
        currentImageView?.loadImage(with: images?[0], or: imageUrls?[0], imgType: imageType)
        currentImageView?.tag = 0
        
        if (imgCount > 1) {
            leftImageView?.loadImage(with: images?[imgCount - 1], or: imageUrls?[imgCount - 1], imgType: imageType)
            leftImageView?.tag = imgCount - 1
            rightImageView?.loadImage(with: images?[1], or: imageUrls?[1], imgType: imageType)
            rightImageView?.tag = 1
        }
        
        //设置页数
        pageControl?.numberOfPages = imgCount
        
        // 图片过少不能拖动
        scrollView?.isScrollEnabled = !(imgCount <= 1);
        
        if autoPaging {
            self.startTimer()
        }
    }
    
    private func setPageControlPosition() {
        var pageControlCenterX = 0.0 ,pageControlCenterY = 0.0
        if pageControlPosition == .bottomCenter {
            pageControlCenterX = Double(self.bounds.size.width) / 2.0
        } else {
            pageControlCenterX = Double(self.bounds.size.width) - Double(imgCount) * pageControlEachWidth / 2.0
        }
        pageControlCenterY = Double(self.bounds.size.height) - pageControlHeight / 4.0
        pageControl?.center = CGPoint.init(x: pageControlCenterX, y: pageControlCenterY)
    }
    
    private func updateContent() {
        
        guard imgCount > 1 else {
            return
        }
        
        if scrollView!.contentOffset.x > imageViewW {
            //左滑
            leftImageView!.tag = currentImageView!.tag
            currentImageView!.tag = rightImageView!.tag
            rightImageView!.tag = (rightImageView!.tag + 1) % (imgCount)
        }
        
        if scrollView!.contentOffset.x < imageViewW {
            //右滑
            rightImageView!.tag = currentImageView!.tag
            currentImageView!.tag = leftImageView!.tag
            leftImageView!.tag = (leftImageView!.tag - 1 + imgCount) % (imgCount)
        }
        leftImageView?.loadImage(with: images?[leftImageView!.tag], or: imageUrls?[leftImageView!.tag], imgType: imageType)
        currentImageView?.loadImage(with: images?[currentImageView!.tag], or: imageUrls?[currentImageView!.tag], imgType: imageType)
        rightImageView?.loadImage(with: images?[rightImageView!.tag], or: imageUrls?[rightImageView!.tag], imgType: imageType)
        
        scrollView?.setContentOffset(CGPoint.init(x: imageViewW, y: 0), animated: false)
    }
    
    private func startTimer() {
        guard (imgCount) > 1 else {
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
            
//            let oldFrame = self.currentImageView?.frame
//            
//            currentImageView?.layer.anchorPoint = CGPoint.init(x: 0, y: 0)
//            
//            self.currentImageView?.frame = oldFrame!
//
//            UIView.animate(withDuration: pagingTimeInterval - 1.0, animations: {
//                
//                let roz = CATransform3DRotate(CATransform3DIdentity, CGFloat.pi / 4.0, 0, 1, 0)
//                self.currentImageView?.transform = CATransform3DGetAffineTransform(roz)
//                
//                }, completion: { (_) in
//                    
//                    self.currentImageView?.transform = CGAffineTransform.identity
//                    
//                    self.scrollView?.setContentOffset(CGPoint.init(x: self.imageViewW * 2.0, y: 0.0), animated: true)
////
//            })
            
//            UIView.animate(withDuration: 2, animations: {
//                
//                let rect = CGRect.init(x: self.imageViewW*2, y: 0.0, width: self.imageViewW, height: self.imageViewH)
//                self.scrollView?.scrollRectToVisible(rect, animated: false)
////                self.scrollView?.setContentOffset(CGPoint.init(x: self.imageViewW * 2.0, y: 0.0), animated: false)
//                
//                }, completion: { (_) in
//                    
//                    self.updateContent()
//            })
            
            let duration = 0.35
            
            /// 立方体动画
            let cube = CATransition.init()
            cube.type = "cube"
            cube.duration = duration
            cube.subtype = kCATransitionFromRight
            self.currentImageView?.image = self.rightImageView?.image
            self.currentImageView?.layer.add(cube, forKey: "cube")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + DispatchTimeInterval.milliseconds(Int(duration)*1000), execute: {
                self.scrollView?.setContentOffset(CGPoint.init(x: self.imageViewW * 2.0, y: 0.0), animated: false)
                self.updateContent()
            })
        }
    }
    
    // MARK: - UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard imgCount > 1 else {
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
        print("ssss===== \(scrollView.contentOffset.x)")
//        self.transform3D()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.updateContent()
        self.identityTransform3D()
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        self.updateContent()
        self.identityTransform3D()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if autoPaging {
            timer?.invalidate()
            timer = nil
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if autoPaging {
            self.startTimer()
        }
    }
    
    
    // MARK: - KVO
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "contentOffset" {
//            print("ssss=====\(scrollView?.contentOffset.x)")
//            self.transform3D()
        }
    }
    
    func transform3D() {
        
        let disZ: CGFloat = 1000.0
        
        currentImageView?.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        
        //本次偏移距离
        let currentOffset = scrollView!.contentOffset.x - imageViewW
        
        //本次偏移角度
        let deltaAngle = currentOffset/imageViewW * CGFloat.pi/2;
        
        //向屏幕前方移动
        let move = CATransform3DMakeTranslation(0, 0, imageViewW/2.0)
        
        //旋转
        let rotate = CATransform3DMakeRotation(-deltaAngle, 0, 1, 0)
        
        //平移
        let plaintMove = CATransform3DMakeTranslation(currentOffset, 0, 0)
        
        //向屏幕后方移动
        let back = CATransform3DMakeTranslation(0, 0, -imageViewW/2.0);
        
        //连接
        let concat = CATransform3DConcat(CATransform3DConcat(move, CATransform3DConcat(rotate, plaintMove)),back);
        
        let point = CGPoint.init(x: currentOffset / 2.0, y: imageViewH)
        
        let transform = CATransform3DPerspect(t: concat, center: point, disZ: disZ)
        
        //添加变幻特效
        currentImageView!.layer.transform = transform
        
        
        //*******************************************
        
        rightImageView?.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        
        //向屏幕前方移动
        let move2 = CATransform3DMakeTranslation(0, 0, imageViewW/2.0);
        
        //旋转
        let rotate2 = CATransform3DMakeRotation(-deltaAngle+CGFloat.pi/2.0, 0, 1, 0);
        
        //平移
        let plaintMove2 = CATransform3DMakeTranslation( currentOffset-imageViewW, 0, 0);
        
        //向屏幕后方移动
        let back2 = CATransform3DMakeTranslation(0, 0, -imageViewW/2.0);
        
        //拼接
        let concat2 = CATransform3DConcat( CATransform3DConcat(move2, CATransform3DConcat(rotate2, plaintMove2)),back2);
        
        let point2 = CGPoint.init(x: imageViewW / 2.0 + currentOffset / 2.0, y: imageViewH)
        
        let transform2 = CATransform3DPerspect(t: concat2, center: point2, disZ: disZ)

        
        //添加变幻特效
        rightImageView!.layer.transform = transform2;
        
        
        //************************************
        
        
        //设置锚点
        leftImageView?.layer.anchorPoint = CGPoint.init(x: 0.5, y: 0.5)
        
        //向屏幕前方移动
        let move3 = CATransform3DMakeTranslation(0, 0, imageViewW/2.0);
        
        //旋转
        let rotate3 = CATransform3DMakeRotation(-deltaAngle-CGFloat.pi / 2.0, 0, 1, 0);
        
        //平移
        let plaintMove3 = CATransform3DMakeTranslation( currentOffset+imageViewW, 0, 0);
        
        //向屏幕后方移动
        let back3 = CATransform3DMakeTranslation(0, 0, -imageViewW/2.0);
        
        //拼接
        let concat3 = CATransform3DConcat(CATransform3DConcat(move3, CATransform3DConcat(rotate3, plaintMove3)),back3);
        
        let transform3 = CATransform3DPerspect(t: concat3, center: CGPoint.init(x: -imageViewW/2.0+currentOffset/2.0, y: imageViewH), disZ: disZ);

        leftImageView?.layer.transform = transform3
        
    }
    
    func identityTransform3D() {
        leftImageView?.layer.transform = CATransform3DIdentity
        currentImageView?.layer.transform = CATransform3DIdentity
        rightImageView?.layer.transform = CATransform3DIdentity
    }
    
    //3D透视函数
    func CATransform3DMakePerspective(center: CGPoint, disZ: CGFloat) -> CATransform3D {
        
        let transToCenter = CATransform3DMakeTranslation(-center.x, -center.y, 0);
        let transBack = CATransform3DMakeTranslation(center.x, center.y, 0);
        var scale = CATransform3DIdentity;
        scale.m34 = -1.0/disZ;
        return CATransform3DConcat(CATransform3DConcat(transToCenter, scale), transBack);
    }
    
    
    func CATransform3DPerspect(t: CATransform3D, center: CGPoint, disZ: CGFloat) -> CATransform3D {
        return CATransform3DConcat(t, CATransform3DMakePerspective(center: center, disZ: disZ));
    }


}

extension MHADScrollView {
    
}


extension UIImageView {
    
    /// 加载图片
    ///（如果urlString为空，就加载imgOrPlaceholder，如果urlString就加载网络图片，这时，如图imgOrPlaceholder不为空，就当做默认图）
    ///
    /// - parameter imgOrPlaceholder: 图片
    /// - parameter urlString:        url
    func loadImage(with imgOrPlaceholder: UIImage?, or urlString: String?, imgType: MHADScrollViewImageType = .local) -> () {
        
        if imgType == .local {
            self.image = imgOrPlaceholder
        } else {
            self.kf.setImage(with: URL.init(string: urlString!), placeholder: imgOrPlaceholder, options: nil, progressBlock: nil, completionHandler: nil)
        }
    }
}














