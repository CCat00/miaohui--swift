//
//  MHCommonSetting.swift
//  妙汇
//
//  Created by 韩威 on 2016/11/3.
//  Copyright © 2016年 韩威. All rights reserved.
//

extension UIViewController/*: NavBackItem*/ {
    
    func setupNavBackItem() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "thin_nav_back"), style: .plain, target: self, action: #selector(UIViewController.navBack))
    }
    
    @objc func navBack() {
        _ = navigationController?.popViewController(animated: true)
    }
}

//protocol NavBackItem {
//    func setupNavBackItem()
//}

//extension NavBackItem where Self: UIViewController {
//    func setupNavBackItem() {
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(image: #imageLiteral(resourceName: "thin_nav_back"), style: .plain, target: self, action: #selector(UIViewController.navBack))
//    }
//}
