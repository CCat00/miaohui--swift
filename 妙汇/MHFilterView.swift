//
//  MHFilterView.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/31.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

class MHFilterView: UIView {
    var filterTitleLabel: UILabel!
    var indicateArrow: UIImageView!
    var maskBgView: UIView!
    var tableView: UITableView!
    var isOpen: Bool = false
    
    var priceList: MHCategoryPriceList? {
        didSet {
            guard priceList != nil else { return }
            
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Life cycle

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        //print("init with frame. self = \(self)")
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        //print("init with coder. self = \(self)")
        self.setup()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    private func setup() {
        
        //print("setup self is \(self), superview is \(superview)")
        
        self.backgroundColor = UIColor.hexColor(hex: 0xfafafa)
        
        //标题
        filterTitleLabel = UILabel.init()
        filterTitleLabel.font = UIFont.systemFont(ofSize: 14.0)
        filterTitleLabel.text = "价格筛选"
        self.addSubview(filterTitleLabel)
        filterTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        let centerY = NSLayoutConstraint.init(item: filterTitleLabel, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let leading = NSLayoutConstraint.init(item: filterTitleLabel, attribute: .leading, relatedBy: .equal, toItem: self, attribute: .leading, multiplier: 1, constant: 15)
        self.addConstraints([centerY, leading]);
        
        //箭头
        indicateArrow = UIImageView.init(image: UIImage.init(named: "downTowardsArrow"))
        self.addSubview(indicateArrow)
        indicateArrow.translatesAutoresizingMaskIntoConstraints = false
        let centerY2 = NSLayoutConstraint.init(item: indicateArrow, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        let trailing = NSLayoutConstraint.init(item: indicateArrow, attribute: .trailing, relatedBy: .equal, toItem: self, attribute: .trailing, multiplier: 1, constant: -15)
        self.addConstraints([centerY2, trailing]);

        
        //遮罩
        maskBgView = UIView.init()
        maskBgView.alpha = 0
        maskBgView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        tableView = UITableView.init()
        tableView.isScrollEnabled = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib.init(nibName: "MHCustomFilterPriceTableViewCell", bundle: nil), forCellReuseIdentifier: "MHCustomFilterPriceTableViewCell")
        maskBgView.addSubview(tableView)
        
        let tap2 = UITapGestureRecognizer.init(target: self, action: #selector(MHFilterView.tapGes))
        //maskBgView.removeGestureRecognizer(tap2)
        maskBgView.addGestureRecognizer(tap2)
    
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        maskBgView.removeFromSuperview()
        superview?.addSubview(maskBgView)
        
        //点击事件
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(MHFilterView.tapGes))
        //FIXME: 在 `setup()` 方法里加tap手势就不起作用
        self.removeGestureRecognizer(tap)
        self.addGestureRecognizer(tap)
        
        maskBgView.frame = CGRect.init(x: selfX, y: selfB, width: selfW, height: SCREEN_HEIGHT - selfB)
        
        let tableViewH: CGFloat = 0.0
        tableView.frame = CGRect.init(x: 0, y: 0, width: maskBgView.selfW, height: tableViewH)
    }
    
    @objc fileprivate func tapGes() {
        
        if isOpen {
          
            //关闭
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    self.tableView.selfH = 0
                    self.indicateArrow.transform = CGAffineTransform.identity
                },
                completion: { (_) in
                    
                    self.maskBgView.alpha = 0
                    self.isOpen = false
                    self.tableView.endEditing(true)
            })

            
        } else {
            
            self.maskBgView.alpha = 1
            
            //展开
            UIView.animate(
                withDuration: 0.3,
                animations: { 
                    
                    self.tableView.selfH = CGFloat(44.0 * CGFloat(self.priceList!.price!.count + 1))
                    self.indicateArrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
                    
                },
                completion: { (_) in
                    
                    self.isOpen = true
            })
        }
    }
}

// MARK: - UITableViewDelegate  UITableViewDataSource

extension MHFilterView: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard priceList != nil else {
            return 0
        }
        return priceList!.price!.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let rows = tableView.numberOfRows(inSection: 0)
        if indexPath.row == rows - 1 {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MHCustomFilterPriceTableViewCell", for: indexPath) as! MHCustomFilterPriceTableViewCell
            return cell
            
        } else {
           
            var cell = tableView.dequeueReusableCell(withIdentifier: "normalCell")
            if cell == nil {
                cell = UITableViewCell.init(style: .default, reuseIdentifier: "normalCell")
                cell?.backgroundColor = UIColor.hexColor(hex: 0xe6e6e6)
                cell?.textLabel?.font = UIFont.systemFont(ofSize: 14.0)
            }
            let priceModel = priceList!.price![indexPath.row]
            cell?.textLabel?.text = priceModel.title
            return cell!
        }
        
    }
}


