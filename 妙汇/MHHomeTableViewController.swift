//
//  MHHomeTableViewController.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/18.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

class MHHomeTableViewController: UITableViewController {
    
    var homeData: MHHomeDataModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        
        MHHomeParser().requestNewData { (homeDataModel) in
            
            self.homeData = homeDataModel
            self.tableView.reloadData()
        }

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Private
    
    private func setupUI() {
        
        // navigationBar
        let leftBarBtn = UIButton.init(type: .custom)
        leftBarBtn.frame = CGRect.init(x: 0, y: 0, width: 30.0, height: 30.0)
        leftBarBtn.setBackgroundImage(UIImage.init(named: "profile_touxiang"), for: .normal)
        leftBarBtn.addTarget(self, action: #selector(MHHomeTableViewController.leftNavBarAction), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: leftBarBtn)
        
        let centerSearchBtn = UIButton.init(type: .custom)
        centerSearchBtn.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH - 120, height: 30.0)
        centerSearchBtn.setImage(UIImage.init(named: "home_search"), for: .normal)
        centerSearchBtn.setTitle(" 搜索妙汇创意商品", for: .normal)
        centerSearchBtn.setTitleColor(UIColor.black, for: .normal)
        centerSearchBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14.0)
        centerSearchBtn.backgroundColor = MH_MAIN_COLOR_YELLOW
        centerSearchBtn.layer.cornerRadius = 5.0
        centerSearchBtn.layer.masksToBounds = true
        centerSearchBtn.addTarget(self, action: #selector(MHHomeTableViewController.searchAction), for: .touchUpInside)
        self.navigationItem.titleView = centerSearchBtn
        
        let rightBarBtn = UIButton.init(type: .custom)
        rightBarBtn.frame = CGRect.init(x: 0, y: 0, width: 25.0, height: 25.0)
        rightBarBtn.setBackgroundImage(UIImage.init(named: "nav_right"), for: .normal)
        rightBarBtn.addTarget(self, action: #selector(MHHomeTableViewController.rightNavBarAction), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(customView: rightBarBtn)
        
        // tableView
        self.tableView.register(UINib.init(nibName: "MHHomeADTableViewCell", bundle: nil), forCellReuseIdentifier: "MHHomeADTableViewCell")
        self.tableView.register(UINib.init(nibName: "MHHomeNavigatorTableViewCell", bundle: nil), forCellReuseIdentifier: "MHHomeNavigatorTableViewCell")
        self.tableView.register(UINib.init(nibName: "MHHomePromotionsTableViewCell", bundle: nil), forCellReuseIdentifier: "MHHomePromotionsTableViewCell")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if ((homeData?.goods?.count) != nil) {
            return (homeData?.goods?.count)! + 4
        }
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0: //轮播图cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MHHomeADTableViewCell", for: indexPath) as! MHHomeADTableViewCell
            if ((homeData?.banner) != nil) {
                cell.models = (homeData?.banner)!
            }
            return cell

        case 1: //导航cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MHHomeNavigatorTableViewCell", for: indexPath) as! MHHomeNavigatorTableViewCell
            if ((homeData?.navigator) != nil) {
                cell.models = (homeData?.navigator)!
            }
            return cell
        case 2: //视野cell
            let cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell2")
            return cell
        case 3: //广告cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "MHHomePromotionsTableViewCell", for: indexPath) as! MHHomePromotionsTableViewCell
            if ((homeData?.promotions) != nil) {
                cell.pros = (homeData?.promotions)!
            }
            return cell
        default: //商品cell
            let cell = tableView.dequeueReusableCell(withIdentifier: "homeGoodsCell", for: indexPath) as! MHGoodsTableViewCell
            if ((homeData?.goods?.count) != nil) {
                cell.model = (homeData?.goods?[indexPath.row - 4])!
            }
            return cell
        }
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: //轮播图cell
            return 180.0
        case 1: //导航cell
            return 100.0
        case 2: //视野cell
            return 80.0
        case 3: //广告cell
            return 170.0
        default: //商品cell
            return 250.0
        }
    }
    
    // MARK: - Action
    
    /// 个人页面
    @objc private func leftNavBarAction() {
        
    }
    
    /// 搜索框
    @objc private func searchAction() {
        
    }

    /// 扫一扫
    @objc private func rightNavBarAction() {
        
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
