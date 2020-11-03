//
//  Calendar.swift
//  Take-Off
//
//  Created by Jun on 2020/08/30.
//  Copyright © 2020 Jun. All rights reserved.
//

import Foundation

struct Calendar {
    var user: String
    var dday: String
    var event: String
    var start: String
    var end: String
    var location: String
    
    init(dictionary: [String: Any]) {
        self.user = dictionary["user"] as? String ?? ""
        self.dday = dictionary["dday"] as? String ?? ""
        self.event = dictionary["event"] as? String ?? ""
        self.start = dictionary["start"] as? String ?? ""
        self.end = dictionary["end"] as? String ?? ""
        self.location = dictionary["location"] as? String ?? ""
    }
    
    
}
