//
//  Comment.swift
//  Take-Off
//
//  Created by Jun on 2020/06/09.
//  Copyright © 2020 Jun. All rights reserved.
//

import Foundation

struct Comment {
    
    let user: User
    let text: String
    let uid: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
