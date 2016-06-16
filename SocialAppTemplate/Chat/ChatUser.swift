//
//  ChatUser.swift
//  SocialAppTemplate
//
//  Created by Barry Ma on 2016-05-19.
//  Copyright © 2016 Barry Ma. All rights reserved.
//

import UIKit
import SIMChat

class ChatUser: SIMChatBaseUser {

    convenience init(
        identifier: String,
        sign: String,
        gender: SIMChatUserGender = .Unknow,
        name: String? = nil,
        portrait: String? = nil) {
            self.init(identifier: identifier, name: name, portrait: portrait)
            self.sign = sign
            self.gender = gender
    }
    
    convenience init(
        identifier: String,
        gender: SIMChatUserGender,
        name: String? = nil,
        portrait: String? = nil) {
            self.init(identifier: identifier, name: name, portrait: portrait)
            self.gender = gender
    }
    
    var sign: String?
    
}
