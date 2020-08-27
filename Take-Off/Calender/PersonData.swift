//
//  PersonData.swift
//  Take-Off
//
//  Created by Jun on 2020/08/24.
//  Copyright © 2020 Jun. All rights reserved.
//

import Foundation
import UIKit

class PersonData {
    var personImage: UIImage!
    var personName: String!
    var personAge: Int!
    
    init(personImage: UIImage, personName: String, personAge: Int) {
        self.personImage = personImage
        self.personName = personName
        self.personAge = personAge
    }
}
