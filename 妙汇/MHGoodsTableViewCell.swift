//
//  MHGoodsTableViewCell.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/18.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit
import Kingfisher

class MHGoodsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var goodsImg: UIImageView!
    @IBOutlet weak var goodsName: UILabel!
    @IBOutlet weak var goodsPrice: UILabel!
    
    var model: MHGoods {
        set(newValue) {
            goodsImg.kf.setImage(with: URL(string: newValue.list_img!))
            goodsName.text = newValue.goods_name
            goodsPrice.text = "¥".appending(newValue.miaohui_price!)
        }
        get {
            return self.model
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
