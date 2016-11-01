//
//  MHFieldOfViewListTableViewCell.swift
//  妙汇
//
//  Created by 韩威 on 2016/11/1.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit
import Kingfisher

class MHFieldOfViewListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var coverView: UIView!
    @IBOutlet weak var topicImage: UIImageView!
    @IBOutlet weak var topicTitle: UILabel!
    @IBOutlet weak var topicSubTitle: UILabel!
    
    var model: MHSpecialTopic? {
        didSet {
            if model == nil { return }
            topicTitle.text = model!.title
            topicImage.kf.setImage(with: URL.init(string: model!.picture_url!))
            topicSubTitle.text = model!.subtitle == nil ? model!.title : model!.subtitle
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
