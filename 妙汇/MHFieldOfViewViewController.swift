//
//  MHFieldOfViewViewController.swift
//  妙汇
//
//  Created by 韩威 on 2016/11/1.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

class MHFieldOfViewViewController: UIViewController {
    
    @IBOutlet weak var topBgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    fileprivate var dataList: [MHSpecialTopic]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setup()
        self.setupRefresh()
        
        tableView.refresh_header()?.beginRefreshing()
    }
    
    private func setup() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(image: UIImage.init(named: "More"), style: .plain, target: self, action: #selector(MHFieldOfViewViewController.rightNavBarItemAction))
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 260
    }
    
    /// 上拉 & 下拉 刷新
    private func setupRefresh() {
        
        /// 下拉刷新
        self.tableView.addRefreshHeader(header: MHRefreshNormalHeader.headerWithHandler(handler: { (header) in
            
            MHFieldOfViewParser().requestNewData(handler: { (data) in
                self.dataList = data
                self.tableView.reloadData()
                header.endRefreshing()
                
            })

        }))
        
        self.tableView.addRefreshFooter(footer: MHRefreshNormalFooter.footerWithHandler(handler: { (footer) in
            let time = DispatchTime.now() + DispatchTimeInterval.seconds(5)
            DispatchQueue.main.asyncAfter(deadline: time, execute: {
                //                footer.endRefreshingWithNoMoreData()
                footer.endRefreshing()
            })
        }))
        
    }

    
    @objc private func rightNavBarItemAction() {
        
    }
}

// MARK: - UITableViewDataSource UITableViewDelegate

extension MHFieldOfViewViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard dataList != nil else {
            return 0
        }
        return dataList!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "fieldOfViewCell", for: indexPath) as! MHFieldOfViewListTableViewCell
        cell.model = dataList![indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = dataList![indexPath.row]
        let detailVC = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MHFieldOfViewDetailViewController") as! MHFieldOfViewDetailViewController
        detailVC.model = model
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
    
}
