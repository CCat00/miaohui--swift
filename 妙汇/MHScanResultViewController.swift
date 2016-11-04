//
//  MHScanResultViewController.swift
//  妙汇
//
//  Created by 韩威 on 2016/11/3.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

class MHScanResultViewController: UIViewController {

    @IBOutlet weak var resultText: UITextView!
    
    var resultSting: String
    
    init(resultString str: String) {
        self.resultSting = str
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "扫描结果"
        setupNavBackItem()
        resultText.text = resultSting
    }

}
