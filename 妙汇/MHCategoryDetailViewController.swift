//
//  MHCategoryDetailViewController.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/27.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

class MHCategoryDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var topFilterView: MHFilterView!
    
    @IBOutlet weak var tableView: UITableView!
    
    var navModel: MHNavigator? {
        didSet {
            if navModel == nil {
                return
            }
            
            self.title = navModel!.name
        }
    }
    
    private var dataList: [MHGoods]?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBackItem()
        
        let tag = self.getTagWithUrl(url: (navModel?.url)!)
        MHCategoryDetailParser().requestNewData(type: tag!) { (list) in
            self.dataList = list?.goods
            self.topFilterView.priceList = list?.filter
            self.tableView.reloadData()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (dataList != nil) {
            return dataList!.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeGoodsCell", for: indexPath) as! MHGoodsTableViewCell
        if (dataList != nil) {
            cell.model = dataList![indexPath.row]
        }
        return cell
    }
    
    // MARK: - Private
    
    /// 拆分字符串，拿到tag
    ///
    /// - parameter url:   e.g.   mwgoodstag://hot
    ///
    /// - returns: hot
    private func getTagWithUrl(url: String) -> String? {
        let array = url.components(separatedBy: "//")
        return array.last
    }


}
