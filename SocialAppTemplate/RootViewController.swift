//
//  RootViewController.swift
//  SocialAppTemplate
//
//  Created by Barry Ma on 2016-05-18.
//  Copyright © 2016 Barry Ma. All rights reserved.
//

import UIKit
import SnapKit
import MBProgressHUD

class RootViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let showBtn = UIButton(type: .Custom)
        showBtn.setTitle("Creat Chat Room", forState: .Normal)
        showBtn.setTitleColor(UIColor.purpleColor(), forState: .Normal)
        showBtn.addTarget(self, action: Selector("showChatRoom"), forControlEvents: .TouchUpInside)
        showBtn.center = view.center
        view.addSubview(showBtn)
        
        showBtn.snp_makeConstraints { (make) -> Void in
            make.center.equalTo(view)
        }
        showBtn.contentEdgeInsets = UIEdgeInsetsMake(8, 20, 8, 20)
        showBtn.layer.borderColor = UIColor.purpleColor().CGColor
        showBtn.layer.borderWidth = 1
        showBtn.layer.cornerRadius = 10
        
    }
    
    internal func showChatRoom() {
        let nvc = UINavigationController.init(rootViewController: ChatViewController())
        self.presentViewController(nvc, animated: true, completion: nil)
    }

}
