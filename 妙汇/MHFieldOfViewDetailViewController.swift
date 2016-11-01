//
//  MHFieldOfViewDetailViewController.swift
//  妙汇
//
//  Created by 韩威 on 2016/11/1.
//  Copyright © 2016年 韩威. All rights reserved.
//

import UIKit

class MHFieldOfViewDetailViewController: UIViewController {

    @IBOutlet weak var webView: UIWebView!
    
    var model: MHSpecialTopic? {
        didSet {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if model == nil { return }
        let url = URL.init(string: (model!.link_url)!)
        let request = URLRequest.init(url: url!)
        webView.loadRequest(request)
        
        self.title = model!.title
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
