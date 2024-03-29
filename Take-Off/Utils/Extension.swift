//
//  Extension.swift
//  Take-Off
//
//  Created by Jun on 2020/06/09.
//  Copyright © 2020 Jun. All rights reserved.
//

import UIKit

// MARK: UIColor Extension(자주쓰는 색과 함수 축약)
extension UIColor {
    
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    static func mainOrange() -> UIColor {
        return UIColor.rgb(red: 255, green: 85, blue: 54)
    }
    
}

// MARK: AutoLayout을 위한 Extension
extension UIView {
func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
    
    translatesAutoresizingMaskIntoConstraints = false
    
    if let top = top {
        self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
    }
    
    if let left = left {
        self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
    }
    
    if let bottom = bottom {
        bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
    }
    
    if let right = right {
        rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
    }
    
    if width != 0 {
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    if height != 0 {
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
}

}

// MARK: 시, 분, 초를 계산해주는 Date Extension
extension Date {
func timeAgoDisplay() -> String {
    let secondsAgo = Int(Date().timeIntervalSince(self))
    
    let minute = 60
    let hour = 60 * minute
    let day = 24 * hour
    let week = 7 * day
    let month = 4 * week
    
    let quotient: Int
    let unit: String
    if secondsAgo < minute {
        quotient = secondsAgo
        unit = "second"
    } else if secondsAgo < hour {
        quotient = secondsAgo / minute
        unit = "min"
    } else if secondsAgo < day {
        quotient = secondsAgo / hour
        unit = "hour"
    } else if secondsAgo < week {
        quotient = secondsAgo / day
        unit = "day"
    } else if secondsAgo < month {
        quotient = secondsAgo / week
        unit = "week"
    } else {
        quotient = secondsAgo / month
        unit = "month"
    }
    
    return "\(quotient) \(unit)\(quotient == 1 ? "" : "s") ago"
    
}
}

