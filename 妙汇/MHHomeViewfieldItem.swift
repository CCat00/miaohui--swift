//
//  MHHomeViewfieldItem.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/20.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

class MHHomeViewfieldItem: UIView {
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!

    @IBOutlet weak var label1Tap: UITapGestureRecognizer!
    @IBOutlet weak var label2Tap: UITapGestureRecognizer!
    @IBOutlet weak var label3Tap: UITapGestureRecognizer!
    
    var articles: [MHArticle]? {
        didSet {
            if articles == nil { return }
            label1.text = articles![0].title
            label2.text = articles![1].title
            label3.text = articles![2].title
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func label1TapAction(_ sender: AnyObject) {
        label1.isHighlighted = true
    
//        sleep(1)
//        label1.isHighlighted = false
    }
    
    @IBAction func label2TapAction(_ sender: AnyObject) {
        label2.isHighlighted = true
        sleep(1)
        label2.isHighlighted = false
    }
    
    @IBAction func label3TapAction(_ sender: AnyObject) {
        label3.isHighlighted = true
        sleep(1)
        label3.isHighlighted = false
    }
    
    
}
