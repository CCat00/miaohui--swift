//
//  MHGoodsTableViewCell.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/18.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit
import Kingfisher

/// 首页商品cell
class MHGoodsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var goodsImg: UIImageView!
    @IBOutlet weak var goodsName: UILabel!
    @IBOutlet weak var goodsPrice: UILabel!
    
    var model: MHGoods? {
        didSet {
            if model == nil {return}
            goodsImg.kf.setImage(with: URL(string: model!.list_img!))
            goodsName.text = model!.goods_name
            goodsPrice.text = "¥".appending(model!.miaohui_price!)
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
