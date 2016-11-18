//
//  MHMeViewController.swift
//  妙汇
//
//  Created by 韩威 on 2016/11/18.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

let topViewMaxH: CGFloat = 210.0
let topViewMinH: CGFloat = 125.0
let tableViewTopInset = topViewMaxH - topViewMinH

class MHMeViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var topView: UIView!
    /// 上面背景视图的高
    @IBOutlet weak var topViewH: NSLayoutConstraint!
    /// 联系客服
    @IBOutlet weak var CCSLabel: UILabel!
    /// 头像
    @IBOutlet weak var avatarImgView: UIView!
    /// 登录提示1
    @IBOutlet weak var loginLabel: UILabel!
    /// 登录提示2
    @IBOutlet weak var loginPromptLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.contentInset = UIEdgeInsets.init(top: tableViewTopInset, left: 0, bottom: 0, right: 0)
        
        setupSubviewsFrame()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /// 联系客服
    let CCSLabelMinX: CGFloat = 15.0
    let CCSLabelW: CGFloat = 66.0
    
    /// 头像
    let avatarImgViewY: CGFloat = 60.0
    let avatarImgViewW: CGFloat = 54.0
    let avatarImgViewMinX: CGFloat = 15.0
    var avatarImgViewMaxX: CGFloat {
       return SCREEN_WIDTH/2.0 - avatarImgViewW/2.0
    }
    
    /// 登录提示
    let loginLabelW: CGFloat = 110.0
    let loginLabelH: CGFloat = 21.0
    var loginLabelMaxX: CGFloat {
        return SCREEN_WIDTH/2.0 - loginLabelW/2.0
    }
    var loginLabelMinX: CGFloat {
        return avatarImgViewMinX + avatarImgViewW + 10
    }
    var loginLabelMaxY: CGFloat {
        return avatarImgViewY + avatarImgViewW + 30
    }
    var loginLabelMinY: CGFloat {
        return avatarImgViewY + 10
    }
    
    let loginPromptLabelW: CGFloat = 146.0
    var loginPromptLabelMaxX: CGFloat {
        return SCREEN_WIDTH/2.0 - loginPromptLabelW/2.0
    }
    var loginPromptLabelMinX: CGFloat {
        return loginLabelMinX
    }
    var loginPromptLabelMaxY: CGFloat {
        return loginLabelMaxY + loginLabelH + 5
    }
    var loginPromptLabelMinY: CGFloat {
        return loginLabelMinY + loginLabelH + 5
    }
    
    /// 滑动比例
    var rate: CGFloat {
        /// max(tableView.contentOffset.y, -tableViewTopInset) >=-tableViewTopInset
        /// min(0, max(tableView.contentOffset.y, -tableViewTopInset))
        /// -tableViewTopInset <= x <= 0
        let x = min(0, max(tableView.contentOffset.y, -tableViewTopInset))
        return 1 - (x / (-tableViewTopInset))
    }
    
    fileprivate func setupSubviewsFrame() {
        CCSLabel.frame = CGRect.init(x: CCSLabelMinX, y: 32, width: CCSLabelW, height: 20)
        avatarImgView.frame = CGRect.init(x: avatarImgViewMaxX, y: avatarImgViewY, width: avatarImgViewW, height: avatarImgViewW)
    }
}

extension MHMeViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("scrollViewDidScroll = \(scrollView.contentOffset.y)")
        
        let offsetY = scrollView.contentOffset.y
        
        if offsetY >= -tableViewTopInset //上滑
        {
            topViewH.constant = topViewMinH + -min(offsetY, 0)
            if offsetY >= 0 {
                tableView.contentInset = UIEdgeInsets.zero
            }
            
            //print("rate is \(rate)")
            moveCCSLabel()
            moveAvatarImgView()
            moveloginPromptLabel()
        }
        else
        {
            topViewH.constant = topViewMaxH
            tableView.contentInset = UIEdgeInsets.init(top: tableViewTopInset, left: 0, bottom: 0, right: 0)
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        //
//        let offsetY = scrollView.contentOffset.y
//        if offsetY >= -tableViewTopInset //上滑
//        {
////            scrollView.setContentOffset(CGPoint.zero, animated: true)
//            scrollView.scrollRectToVisible(CGRect.zero, animated: true)
//        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    /// 移动 联系客服 位置
    ///
    /// - Parameter offsetY: 偏移量
    fileprivate func moveCCSLabel() {
        let settingBtnRight: CGFloat = 15
        let settingBtnW: CGFloat = 24
        let settingBtnLeftMargin: CGFloat = 10
        
        let CCSLabelMaxX = SCREEN_WIDTH - settingBtnRight - settingBtnW - settingBtnLeftMargin - CCSLabelW
        
        CCSLabel.frame.origin.x  = CCSLabelMinX + (CCSLabelMaxX - CCSLabelMinX) * rate
    }
    
    fileprivate func moveAvatarImgView() {
        avatarImgView.frame.origin.x = avatarImgViewMaxX - rate * (avatarImgViewMaxX - avatarImgViewMinX)
    }
    
    fileprivate func moveloginPromptLabel() {
        loginLabel.frame.origin.x = loginLabelMaxX - rate * (loginLabelMaxX - loginLabelMinX)
        loginLabel.frame.origin.y = loginLabelMaxY - rate * (loginLabelMaxY - loginLabelMinY)
        
        loginPromptLabel.frame.origin.x = loginPromptLabelMaxX - rate * (loginPromptLabelMaxX - loginPromptLabelMinX)
        loginPromptLabel.frame.origin.y = loginPromptLabelMaxY - rate * (loginPromptLabelMaxY - loginPromptLabelMinY)
    }
}



extension MHMeViewController: UITableViewDelegate {
    
}

extension MHMeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .default, reuseIdentifier: nil)
        //cell.backgroundColor = UIColor.clear
        cell.textLabel?.text = "row \(indexPath.row)"
        return cell
    }
}
