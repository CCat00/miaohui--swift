//
//  MHCategoryDetailViewController.swift
//  妙汇
//
//  Created by 韩威 on 2016/10/27.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

class MHCategoryDetailViewController: UIViewController {
    
    var navModel: MHNavigator? {
        didSet {
            if navModel == nil {
                return
            }
            
            self.title = navModel!.name
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
//        if ((homeData?.goods?.count) != nil) {
//            return (homeData?.goods?.count)! + 4
//        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "homeGoodsCell", for: indexPath) as! MHGoodsTableViewCell
        //            if ((homeData?.goods?.count) != nil) {
        //                cell.model = (homeData?.goods?[indexPath.row - 4])!
        //            }
        return cell
    }


}
