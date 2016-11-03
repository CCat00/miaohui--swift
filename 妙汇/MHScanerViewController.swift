//
//  MHScanerViewController.swift
//  妙汇
//
//  Created by 韩威 on 2016/11/3.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

/// 扫一扫页面
class MHScanerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate func setup() {
        title = "扫一扫"
        setupNavBackItem()
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
