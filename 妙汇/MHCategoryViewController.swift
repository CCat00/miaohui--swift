//
//  MHCategoryViewController.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/26.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

/// 分类界面
class MHCategoryViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        MHCategoryParser().requestData { (models) in
            
            if models == nil {
                return
            }
            
            for view in self.view.allSubviews() {
                
                if view is MHCategoryBtn {
                    
                    let categoryBtn = view as! MHCategoryBtn
                    
                    categoryBtn.model = models![categoryBtn.tag - 100]
                }
            }
            
            
        }
    }
    
    @IBAction func itemAction(_ sender: MHCategoryBtn) {
//        let index = sender.tag - 100
//        print("*****(sender.tag) = \(index)")
        
//        let mainSb = UIStoryboard.init(name: "Main", bundle: nil)
//        let detailVC = mainSb.instantiateViewController(withIdentifier: "MHCategoryDetailViewController") as! MHCategoryDetailViewController
        
        //改进写法
        let detailVC: MHCategoryDetailViewController = UIStoryboard.storyboard(.Main).instantiateViewController()
        
        detailVC.navModel = sender.model
        navigationController?.pushViewController(detailVC, animated: true)
    }
    

}
