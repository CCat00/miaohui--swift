//
//  MHTabBarController.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/19.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

class MHTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let images_normal = [
            #imageLiteral(resourceName: "tab_home_wt"),
            #imageLiteral(resourceName: "tab_Category_wt"),
            #imageLiteral(resourceName: "tab_fieldOfView_wt"),
            #imageLiteral(resourceName: "tab_cart_wt"),
            #imageLiteral(resourceName: "tab_personal_wt")
//            UIImage.init(named: "tab_Category_wt"),
//            UIImage.init(named: "tab_fieldOfView_wt"),
//            UIImage.init(named: "tab_cart_wt"),
//            UIImage.init(named: "tab_personal_wt"),
            ]
        
        let images_selected = [
            #imageLiteral(resourceName: "tab_home"),
            #imageLiteral(resourceName: "tab_Category"),
            #imageLiteral(resourceName: "tab_fieldOfView"),
            #imageLiteral(resourceName: "tab_cart"),
            #imageLiteral(resourceName: "tab_personal")
//            UIImage.init(named: "tab_home"),
//            UIImage.init(named: "tab_Category"),
//            UIImage.init(named: "tab_fieldOfView"),
//            UIImage.init(named: "tab_cart"),
//            UIImage.init(named: "tab_personal"),
            ]
        
        let titles = [
        "首页",
        "分类",
        "视野",
        "购物车",
        "我的妙汇"
        ]

        for (index, value) in self.tabBar.items!.enumerated() {
            
            var img_normal = images_normal[index]
            var img_selected = images_selected[index]
            let title = titles[index]
            
            img_normal = img_normal.withRenderingMode(.alwaysOriginal)
            img_selected = img_selected.withRenderingMode(.alwaysOriginal)
            
            value.title = title
            value.selectedImage = img_selected
            value.image = img_normal
            
        }

        self.tabBar.isTranslucent = false
//        self.tabBar.backgroundImage = nil
//        self.tabBar.backgroundColor = UIColor.red.withAlphaComponent(0.3)
//        self.tabBar.barTintColor = UIColor.clear
        self.tabBar.tintColor = MH_MAIN_COLOR_YELLOW
        UITabBarItem.appearance().titlePositionAdjustment = UIOffset.init(horizontal: 0, vertical: -4)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSFontAttributeName : UIFont.systemFont(ofSize: 10.0),
             NSForegroundColorAttributeName : UIColor.white
            ], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes(
            [NSFontAttributeName : UIFont.systemFont(ofSize: 10.0),
             NSForegroundColorAttributeName : MH_MAIN_COLOR_YELLOW
            ], for: .selected)

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
