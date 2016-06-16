//
//  RootViewController.swift
//  SocialAppTemplate
//
//  Created by Barry Ma on 2016-05-18.
//  Copyright © 2016 Barry Ma. All rights reserved.
//

import UIKit
import SnapKit
import SIMChat
import MBProgressHUD

class RootViewController: UIViewController {
    
    lazy var manager: SIMChatManager = ChatManager.sharedInstance
    
    lazy var user2: SIMChatUserProtocol = {
        let identifier = "admin"
        let sign = "eJx1js1Og0AYRfc8BWFbI0MHOtbEBa1jQqRUS8HuJjA-zRfS6QTGgDG*uxWbyMa7PSc599NxXdfbp-ltxfn5XVtmP4z03HvXwyHG3s0fNwYEqyzDrRh5EKLLSBBEE0sOBlrJKmVl*2tFZHH3I6KJBUJqCwquTiVOoCe4Ew0bc-93OjiOcEOLdfI0A973KG123ZuJ5-kqqUNND5tmnq3T-rE02y1o7S81L2OgsSbJzEfIr3fFXlF1jF*ecz1kFPWULnBWcDWsDiU58-r1YZK0cJLXQxEJEMIYec6X8w07oFbB"
        
        return ChatUser(identifier: identifier, sign: sign, gender: .Female)
    }()
    lazy var user1: SIMChatUserProtocol = {
        let identifier = "sagesse"
        let sign = "eJx1zk9PgzAYx-E7r6LptUbpgMFMPCDpMv*QQIREvTSlFHicg0q7qTG*dxWXyMXn*v0kv*fDQQjh4vbuVEg57HvL7btWGJ0j7Pmeh0-*utZQc2G5N9ZTp777fSGlwUypNw2j4qKxavxVQbiMfqA7U1Cr3kIDR2NEq4xRM2DqLZ8G-18y0E4xZWVyxWjJQsqSvKvI5S49YxZW*rUYsjyXCSkzf7vRskgfBr2JgcVAukP5HIu8XNw8dcXqEaoR1lkr*2g5VkCC6*ZAXtb79n64mE1a2KnjQ0FI3UXkudj5dL4AOi1Ydg__"
        
        return ChatUser(identifier: identifier, sign: sign, gender: .Male)
    }()
    
    var other: SIMChatUserProtocol {
        if UIDevice.currentDevice().name == "iPhone Simulator" {
            return user1
        } else {
            return user2
        }
    }
    
    var own: SIMChatUserProtocol {
        if UIDevice.currentDevice().name == "iPhone Simulator" {
            return user2
        } else {
            return user1
        }
    }
    

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
        
        srand(UInt32(time(nil)))
        
        SIMChatMessageBox.ActivityIndicator.begin()
        
        manager.login(own) {
            SIMChatMessageBox.ActivityIndicator.end()
            if let error = $0.error {
                SIMChatMessageBox.Alert.error(error)
                return
            }
        }
        
    }
    
    internal func showChatRoom() {
        let nvc = UINavigationController.init(rootViewController: ChatViewController(conversation: manager.conversation(other)))
        self.presentViewController(nvc, animated: true, completion: nil)
    }

}
