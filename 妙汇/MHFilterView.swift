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
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setup()
    }
    
    private func setup() {
        
        //标题
        filterTitleLabel = UILabel.init()
        filterTitleLabel.font = UIFont.systemFont(ofSize: 14.0)
        filterTitleLabel.text = "价格筛选"
        self.addSubview(filterTitleLabel)
        
        //点击事件
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(MHFilterView.tapGes))
        self.addGestureRecognizer(tap)
        
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
        
        maskBgView.addGestureRecognizer(tap)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        filterTitleLabel.frame = CGRect.init(x: <#T##CGFloat#>, y: <#T##CGFloat#>, width: <#T##CGFloat#>, height: <#T##CGFloat#>)
        
        maskBgView.removeFromSuperview()
        superview?.addSubview(maskBgView)
        
        maskBgView.frame = CGRect.init(x: selfX, y: selfB, width: selfW, height: SCREEN_HEIGHT - selfB)
        
        let tableViewH: CGFloat = 0.0
//        if priceList != nil {
//            tableViewH = CGFloat(44.0 * CGFloat(priceList!.price!.count + 1))
//        }
        tableView.frame = CGRect.init(x: 0, y: 0, width: maskBgView.selfW, height: tableViewH)
    }
    
    @objc fileprivate func tapGes() {
    
        if isOpen {
            
            //关闭
            UIView.animate(
                withDuration: 0.3,
                animations: {
                    
                    self.maskBgView.alpha = 0
                    self.tableView.selfH = 0
                    
                },
                completion: { (_) in
                    
                    self.isOpen = false
            })

            
        } else {
            
            //展开
            UIView.animate(
                withDuration: 0.3,
                animations: { 
                    
                    self.maskBgView.alpha = 1
                    self.tableView.selfH = CGFloat(44.0 * CGFloat(self.priceList!.price!.count + 1))
                    
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


