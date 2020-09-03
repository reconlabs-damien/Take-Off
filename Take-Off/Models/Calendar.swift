//
//  Calendar.swift
//  Take-Off
//
//  Created by Jun on 2020/08/30.
//  Copyright © 2020 Jun. All rights reserved.
//

import Foundation

struct Calendar {
    let user: User
    let dday: String
    let event: String
    let start: String
    let end: String
    let location: String
    
    init(user: User, dictionary: [String: Any]) {
        self.user = user
        self.dday = dictionary["dday"] as? String ?? ""
        self.event = dictionary["event"] as? String ?? ""
        self.start = dictionary["start"] as? String ?? ""
        self.end = dictionary["end"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
    }
    
    
}
